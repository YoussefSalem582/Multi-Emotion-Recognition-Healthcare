import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/usecases/detect_emotions_usecase.dart';

/// Provider for emotion detection
class EmotionProvider extends ChangeNotifier {
  final DetectEmotionsUseCase _detectEmotionsUseCase;

  Emotion? _currentEmotion;
  List<Emotion> _detectedEmotions = [];
  bool _isDetecting = false;
  String? _error;
  StreamSubscription<Emotion>? _liveDetectionSubscription;

  EmotionProvider(this._detectEmotionsUseCase);

  /// Get current emotion
  Emotion? get currentEmotion => _currentEmotion;

  /// Get all detected emotions
  List<Emotion> get detectedEmotions => _detectedEmotions;

  /// Check if detection is in progress
  bool get isDetecting => _isDetecting;

  /// Get error message
  String? get error => _error;

  /// Detect emotions from audio
  Future<List<Emotion>> detectFromAudio(String audioFilePath) async {
    _isDetecting = true;
    _error = null;
    notifyListeners();

    try {
      _detectedEmotions = await _detectEmotionsUseCase.detectFromAudio(
        audioFilePath,
      );
      if (_detectedEmotions.isNotEmpty) {
        _currentEmotion = _detectedEmotions.first;
      }
      return _detectedEmotions;
    } catch (e) {
      _error = 'Failed to detect emotions: ${e.toString()}';
      notifyListeners();
      return [];
    } finally {
      _isDetecting = false;
      notifyListeners();
    }
  }

  /// Detect emotions from video
  Future<List<Emotion>> detectFromVideo(String videoFilePath) async {
    _isDetecting = true;
    _error = null;
    notifyListeners();

    try {
      _detectedEmotions = await _detectEmotionsUseCase.detectFromVideo(
        videoFilePath,
      );
      if (_detectedEmotions.isNotEmpty) {
        _currentEmotion = _detectedEmotions.first;
      }
      return _detectedEmotions;
    } catch (e) {
      _error = 'Failed to detect emotions: ${e.toString()}';
      notifyListeners();
      return [];
    } finally {
      _isDetecting = false;
      notifyListeners();
    }
  }

  /// Start live emotion detection
  void startLiveDetection() {
    _isDetecting = true;
    _detectedEmotions = [];
    _error = null;
    notifyListeners();

    try {
      _liveDetectionSubscription?.cancel();
      _liveDetectionSubscription = _detectEmotionsUseCase.detectLive().listen(
        (emotion) {
          _currentEmotion = emotion;
          _detectedEmotions.add(emotion);
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error in live detection: ${e.toString()}';
          _isDetecting = false;
          notifyListeners();
        },
        onDone: () {
          _isDetecting = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Failed to start live detection: ${e.toString()}';
      _isDetecting = false;
      notifyListeners();
    }
  }

  /// Stop live emotion detection
  void stopLiveDetection() {
    _liveDetectionSubscription?.cancel();
    _liveDetectionSubscription = null;
    _isDetecting = false;
    notifyListeners();
  }

  /// Save an emotion detection
  Future<void> saveEmotionDetection(String sessionId, Emotion emotion) async {
    try {
      await _detectEmotionsUseCase.saveEmotionDetection(
        sessionId,
        emotion,
        DateTime.now(),
      );
    } catch (e) {
      _error = 'Failed to save emotion: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _liveDetectionSubscription?.cancel();
    super.dispose();
  }
}
