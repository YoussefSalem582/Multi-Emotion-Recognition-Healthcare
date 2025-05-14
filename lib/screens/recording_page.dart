import 'package:flutter/material.dart';
import '../models/emotion_data.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool _isRecording = false;
  int _recordingSeconds = 0;
  String _currentEmotion = 'Neutral';
  Color _emotionColor = Colors.grey;
  List<EmotionData> _emotionHistory = [];

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startRecordingTimer();
        _emotionHistory = [];
      } else {
        _saveRecording();
      }
    });
  }

  void _startRecordingTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingSeconds++;

          // Simulate emotion changes
          if (_recordingSeconds % 5 == 0) {
            List<Map<String, dynamic>> emotions = [
              {'emotion': 'Happy', 'color': Colors.green},
              {'emotion': 'Neutral', 'color': Colors.grey},
              {'emotion': 'Confused', 'color': Colors.blue},
              {'emotion': 'Frustrated', 'color': Colors.orange},
            ];
            var randomEmotion = emotions[_recordingSeconds % emotions.length];
            _currentEmotion = randomEmotion['emotion'];
            _emotionColor = randomEmotion['color'];

            // Add to emotion history
            _emotionHistory.add(
              EmotionData(
                timestamp: _recordingSeconds,
                emotion: _currentEmotion,
                confidence:
                    0.7 +
                    (_recordingSeconds % 3) *
                        0.1, // Random confidence between 0.7-0.9
              ),
            );
          }
        });
        _startRecordingTimer();
      }
    });
  }

  void _saveRecording() {
    // In a real app, this would save the recording to a database or file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Recording saved with ${_emotionHistory.length} detected emotions',
        ),
        action: SnackBarAction(
          label: 'Review',
          onPressed: () => Navigator.pushNamed(context, '/sessionReview'),
        ),
      ),
    );
  }

  String get _formattedTime {
    int minutes = _recordingSeconds ~/ 60;
    int seconds = _recordingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Confused':
        return Colors.blue;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Session'),
        actions: [
          if (_emotionHistory.isNotEmpty && !_isRecording)
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exporting recording data...')),
                );
              },
              tooltip: 'Export recording',
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer display
              Text(
                _formattedTime,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              // Recording status
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      _isRecording
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isRecording ? Icons.mic : Icons.mic_off,
                      color: _isRecording ? Colors.red : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _isRecording ? 'Recording' : 'Not Recording',
                      style: TextStyle(
                        color: _isRecording ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Current emotion
              if (_isRecording || _emotionHistory.isNotEmpty) ...[
                Text(
                  _isRecording
                      ? 'Current Detected Emotion:'
                      : 'Last Detected Emotion:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: _emotionColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _currentEmotion,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _emotionColor,
                    ),
                  ),
                ),
              ],

              // Emotion history timeline
              if (_emotionHistory.isNotEmpty) ...[
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Emotion History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_emotionHistory.length} detected',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _emotionHistory.length,
                    itemBuilder: (context, index) {
                      final emotion = _emotionHistory[index];
                      final color = _getEmotionColor(emotion.emotion);

                      return Card(
                        margin: EdgeInsets.only(right: 12),
                        color: color.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                emotion.emotion,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.timeline, size: 14, color: color),
                                  SizedBox(width: 4),
                                  Text(
                                    '${(emotion.confidence * 100).round()}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${(emotion.timestamp ~/ 60).toString().padLeft(2, '0')}:${(emotion.timestamp % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              Spacer(),

              // Record button
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color:
                        _isRecording
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording
                                ? Colors.red
                                : Theme.of(context).primaryColor)
                            .withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _isRecording ? 'Tap to stop' : 'Tap to start recording',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
