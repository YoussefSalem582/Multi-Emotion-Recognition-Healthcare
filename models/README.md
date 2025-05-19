# Emotion Detection Model for EmoSense

This directory contains the emotion detection model and API server for the EmoSense Flutter application.

## Overview

The model is based on the MELD (Multimodal EmotionLines Dataset) and is trained to detect 7 emotions:
- Neutral
- Anger
- Disgust
- Fear
- Joy
- Sadness
- Surprise

## Setup Instructions

### Prerequisites

- Python 3.8+ installed
- PyTorch and OpenCV installed
- Flutter development environment set up

### Step 1: Export the model from the notebook

1. Open the `Grad_project_MELD_model.ipynb` notebook in Jupyter or Google Colab
2. Run all cells to train the model (or load a pre-trained model)
3. Add the following code at the end of the notebook to export the model:

```python
# Save the model
torch.save(model.state_dict(), 'emotion_model.pth')
```

4. Copy the exported `emotion_model.pth` file to the `models/` directory

### Step 2: Set up the Flask API server

1. Install the required Python packages:

```bash
cd models
pip install -r requirements.txt
```

2. Start the Flask server:

```bash
python emotion_api.py
```

The server will start on `http://localhost:5000`.

### Step 3: Test the API

You can test the API using curl or Postman:

```bash
curl -X GET http://localhost:5000/health
```

This should return:

```json
{
  "status": "healthy",
  "model_loaded": true
}
```

To analyze a video:

```bash
curl -X POST -F "video=@path/to/video.mp4" http://localhost:5000/analyze
```

## Integration with Flutter

The Flutter app is already set up to communicate with the API. Make sure the API server is running when using the video analysis feature in the app.

By default, the app looks for the API at `http://localhost:5000`. If you deploy the API to a different URL, update the `baseUrl` in `lib/services/emotion_detection_service.dart`.

## Deployment

For production use, you should deploy the Flask API to a proper server. Here are some options:

1. Deploy to a cloud provider like AWS, Google Cloud, or Azure
2. Use a service like Heroku or PythonAnywhere
3. Deploy to your own server using Gunicorn and Nginx

Example deployment with Gunicorn:

```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 emotion_api:app
```

## Troubleshooting

If you encounter issues:

1. Make sure the model file is correctly placed in the models directory
2. Check that all dependencies are installed
3. Look at the Flask server logs for error messages
4. Verify that the Flutter app can connect to the API server

## License

This model and API code are for use with the EmoSense application only. 