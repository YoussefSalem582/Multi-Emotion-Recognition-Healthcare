from flask import Flask, request, jsonify
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import cv2
import os
import tempfile
from werkzeug.utils import secure_filename

app = Flask(__name__)

# Define the model architecture (same as in the notebook)
class EmotionClassifier(nn.Module):
    def __init__(self, num_classes=7):
        super(EmotionClassifier, self).__init__()
        self.conv1 = nn.Conv2d(3, 64, kernel_size=3, padding=1)
        self.bn1 = nn.BatchNorm2d(64)
        self.conv2 = nn.Conv2d(64, 128, kernel_size=3, padding=1)
        self.bn2 = nn.BatchNorm2d(128)
        self.pool1 = nn.MaxPool2d(2, 2)
        self.dropout1 = nn.Dropout(0.3)
        
        self.conv3 = nn.Conv2d(128, 128, kernel_size=3, padding=1)
        self.bn3 = nn.BatchNorm2d(128)
        self.conv4 = nn.Conv2d(128, 256, kernel_size=3, padding=1)
        self.bn4 = nn.BatchNorm2d(256)
        self.pool2 = nn.MaxPool2d(2, 2)
        self.dropout2 = nn.Dropout(0.3)
        
        self.conv5 = nn.Conv2d(256, 256, kernel_size=3, padding=1)
        self.bn5 = nn.BatchNorm2d(256)
        self.conv6 = nn.Conv2d(256, 512, kernel_size=3, padding=1)
        self.bn6 = nn.BatchNorm2d(512)
        self.pool3 = nn.MaxPool2d(2, 2)
        self.dropout3 = nn.Dropout(0.3)
        
        self.fc1 = nn.Linear(512 * 8 * 8, 1024)
        self.bn7 = nn.BatchNorm1d(1024)
        self.dropout4 = nn.Dropout(0.5)
        self.fc2 = nn.Linear(1024, num_classes)
        
    def forward(self, x):
        x = F.relu(self.bn1(self.conv1(x)))
        x = F.relu(self.bn2(self.conv2(x)))
        x = self.pool1(x)
        x = self.dropout1(x)
        
        x = F.relu(self.bn3(self.conv3(x)))
        x = F.relu(self.bn4(self.conv4(x)))
        x = self.pool2(x)
        x = self.dropout2(x)
        
        x = F.relu(self.bn5(self.conv5(x)))
        x = F.relu(self.bn6(self.conv6(x)))
        x = self.pool3(x)
        x = self.dropout3(x)
        
        x = x.view(-1, 512 * 8 * 8)
        x = F.relu(self.bn7(self.fc1(x)))
        x = self.dropout4(x)
        x = self.fc2(x)
        return x

# Load the model
model = EmotionClassifier()
model_path = os.path.join(os.path.dirname(__file__), 'emotion_model.pth')
if os.path.exists(model_path):
    model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')))
    model.eval()
    print("Model loaded successfully")
else:
    print("Model file not found. Please place the trained model at:", model_path)

# Emotion labels from MELD dataset
emotion_labels = ['neutral', 'anger', 'disgust', 'fear', 'joy', 'sadness', 'surprise']

def preprocess_frame(frame):
    # Resize to 64x64 as per the model training
    frame = cv2.resize(frame, (64, 64))
    # Convert to RGB if it's BGR
    if frame.shape[2] == 3:
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    # Normalize
    frame = frame / 255.0
    # Convert to tensor and add batch dimension
    frame = torch.FloatTensor(frame).permute(2, 0, 1).unsqueeze(0)
    return frame

def process_video(video_path):
    results = []
    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    duration = frame_count / fps
    
    # Process every second of video
    sample_rate = int(fps)
    frame_number = 0
    
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
            
        if frame_number % sample_rate == 0:  # Process 1 frame per second
            timestamp = frame_number / fps
            processed_frame = preprocess_frame(frame)
            
            with torch.no_grad():
                output = model(processed_frame)
                probabilities = F.softmax(output, dim=1)[0]
                top_prob, top_class = torch.max(probabilities, 0)
                
                emotion = emotion_labels[top_class.item()]
                confidence = top_prob.item()
                
                results.append({
                    'timestamp': int(timestamp),
                    'emotion': emotion,
                    'confidence': confidence
                })
                
        frame_number += 1
        
    cap.release()
    
    # Calculate overall emotion distribution
    emotion_distribution = {emotion: 0.0 for emotion in emotion_labels}
    for result in results:
        emotion_distribution[result['emotion']] += 1
    
    # Normalize to get percentages
    total_frames = len(results)
    if total_frames > 0:
        for emotion in emotion_distribution:
            emotion_distribution[emotion] = emotion_distribution[emotion] / total_frames
    
    return {
        'duration': duration,
        'frame_count': frame_count,
        'fps': fps,
        'emotion_timestamps': results,
        'emotion_distribution': emotion_distribution
    }

@app.route('/analyze', methods=['POST'])
def analyze_video():
    if 'video' not in request.files:
        return jsonify({'error': 'No video file provided'}), 400
    
    video_file = request.files['video']
    if video_file.filename == '':
        return jsonify({'error': 'No video file selected'}), 400
    
    if video_file:
        # Save the video to a temporary file
        filename = secure_filename(video_file.filename)
        temp_dir = tempfile.gettempdir()
        temp_path = os.path.join(temp_dir, filename)
        video_file.save(temp_path)
        
        try:
            # Process the video
            results = process_video(temp_path)
            # Delete the temporary file
            os.remove(temp_path)
            return jsonify(results)
        except Exception as e:
            # Delete the temporary file in case of error
            if os.path.exists(temp_path):
                os.remove(temp_path)
            return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'model_loaded': os.path.exists(model_path)})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000) 