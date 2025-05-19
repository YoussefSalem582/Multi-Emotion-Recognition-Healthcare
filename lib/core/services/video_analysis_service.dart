import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';

/// A class that represents a video analysis result
class VideoAnalysisResult {
  /// Source of the video (file path or URL)
  final String source;

  /// Type of source ('file', 'youtube', 'tiktok', etc.)
  final String sourceType;

  /// Timestamp when the analysis was performed
  final DateTime timestamp;

  /// Overall analysis summary (average emotions throughout video)
  final Map<String, double> overallEmotions;

  /// Detailed emotion data at specific timestamps (in milliseconds)
  final Map<int, Map<String, double>> timelineData;

  /// Duration of the analyzed video in milliseconds
  final int duration;

  /// Additional analysis metadata
  final Map<String, dynamic> metadata;

  VideoAnalysisResult({
    required this.source,
    required this.sourceType,
    required this.timestamp,
    required this.overallEmotions,
    required this.timelineData,
    required this.duration,
    this.metadata = const {},
  });

  /// Create a VideoAnalysisResult from JSON
  factory VideoAnalysisResult.fromJson(Map<String, dynamic> json) {
    // Parse timeline data
    final Map<int, Map<String, double>> timeline = {};
    final Map<String, dynamic> timelineJson = Map<String, dynamic>.from(
      json['timelineData'] ?? {},
    );

    timelineJson.forEach((key, value) {
      final int timestamp = int.parse(key);
      final Map<String, double> emotions = {};

      (value as Map<String, dynamic>).forEach((emotion, val) {
        emotions[emotion] = (val as num).toDouble();
      });

      timeline[timestamp] = emotions;
    });

    // Parse overall emotions
    final Map<String, double> overall = {};
    final Map<String, dynamic> overallJson = Map<String, dynamic>.from(
      json['overallEmotions'] ?? {},
    );

    overallJson.forEach((emotion, value) {
      overall[emotion] = (value as num).toDouble();
    });

    return VideoAnalysisResult(
      source: json['source'] as String,
      sourceType: json['sourceType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      overallEmotions: overall,
      timelineData: timeline,
      duration: json['duration'] as int,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    // Convert timeline data
    final Map<String, Map<String, double>> timelineJson = {};
    timelineData.forEach((key, value) {
      timelineJson[key.toString()] = value;
    });

    return {
      'source': source,
      'sourceType': sourceType,
      'timestamp': timestamp.toIso8601String(),
      'overallEmotions': overallEmotions,
      'timelineData': timelineJson,
      'duration': duration,
      'metadata': metadata,
    };
  }

  /// Get the appropriate emotion color map
  Map<String, Color> getEmotionColors() {
    return {
      'Happy': Colors.green,
      'Sad': Colors.blue,
      'Angry': Colors.red,
      'Surprised': Colors.purple,
      'Fearful': Colors.deepOrange,
      'Disgusted': Colors.brown,
      'Neutral': Colors.grey,
    };
  }

  /// Get the dominant emotion at a specific point in time
  String getDominantEmotionAt(int timestamp) {
    final emotions = timelineData[timestamp];
    if (emotions == null || emotions.isEmpty) return 'Unknown';

    String dominant = emotions.keys.first;
    double maxValue = emotions.values.first;

    emotions.forEach((emotion, value) {
      if (value > maxValue) {
        maxValue = value;
        dominant = emotion;
      }
    });

    return dominant;
  }

  /// Find the most frequent dominant emotion
  String getMostFrequentEmotion() {
    final Map<String, int> counts = {};

    timelineData.forEach((_, emotions) {
      String dominant = 'Unknown';
      double maxValue = 0;

      emotions.forEach((emotion, value) {
        if (value > maxValue) {
          maxValue = value;
          dominant = emotion;
        }
      });

      counts[dominant] = (counts[dominant] ?? 0) + 1;
    });

    String mostFrequent = 'Unknown';
    int maxCount = 0;

    counts.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = emotion;
      }
    });

    return mostFrequent;
  }
}

/// Service for handling video analysis
class VideoAnalysisService {
  /// Maximum number of analysis results to keep in history
  final int maxHistoryItems;

  /// Constructor
  VideoAnalysisService({this.maxHistoryItems = 20});

  /// Save analysis result to local storage
  Future<bool> saveAnalysisResult(VideoAnalysisResult result) async {
    try {
      // Get existing history
      final List<VideoAnalysisResult> history = await getAnalysisHistory();

      // Add new result to the beginning
      history.insert(0, result);

      // Trim history if needed
      if (history.length > maxHistoryItems) {
        history.removeRange(maxHistoryItems, history.length);
      }

      // Convert to JSON
      final List<Map<String, dynamic>> historyJson =
          history.map((e) => e.toJson()).toList();

      // Save to file
      final file = await _getHistoryFile();
      await file.writeAsString(jsonEncode(historyJson));

      return true;
    } catch (e) {
      debugPrint('Error saving analysis result: $e');
      return false;
    }
  }

  /// Get analysis history
  Future<List<VideoAnalysisResult>> getAnalysisHistory() async {
    try {
      final file = await _getHistoryFile();

      if (!await file.exists()) {
        return [];
      }

      final String contents = await file.readAsString();
      final List<dynamic> historyJson = jsonDecode(contents);

      return historyJson
          .map((e) => VideoAnalysisResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting analysis history: $e');
      return [];
    }
  }

  /// Clear analysis history
  Future<bool> clearAnalysisHistory() async {
    try {
      final file = await _getHistoryFile();

      if (await file.exists()) {
        await file.delete();
      }

      return true;
    } catch (e) {
      debugPrint('Error clearing analysis history: $e');
      return false;
    }
  }

  /// Delete a specific analysis result
  Future<bool> deleteAnalysisResult(int index) async {
    try {
      final List<VideoAnalysisResult> history = await getAnalysisHistory();

      if (index < 0 || index >= history.length) {
        return false;
      }

      history.removeAt(index);

      final List<Map<String, dynamic>> historyJson =
          history.map((e) => e.toJson()).toList();

      final file = await _getHistoryFile();
      await file.writeAsString(jsonEncode(historyJson));

      return true;
    } catch (e) {
      debugPrint('Error deleting analysis result: $e');
      return false;
    }
  }

  /// Export analysis result to CSV
  Future<String> exportToCSV(VideoAnalysisResult result) async {
    try {
      // Prepare CSV data
      final List<List<dynamic>> csvData = [];

      // Header row
      final emotions = result.overallEmotions.keys.toList();
      csvData.add(['Timestamp', ...emotions]);

      // Data rows - sorted by timestamp
      final timestamps = result.timelineData.keys.toList()..sort();

      for (final timestamp in timestamps) {
        final emotionValues =
            emotions
                .map((e) => result.timelineData[timestamp]?[e] ?? 0.0)
                .toList();

        final formattedTime = _formatMilliseconds(timestamp);
        csvData.add([formattedTime, ...emotionValues]);
      }

      // Convert to CSV string
      final csv = const ListToCsvConverter().convert(csvData);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final filename =
          'emotion_analysis_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$filename');

      await file.writeAsString(csv);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting to CSV: $e');
      rethrow;
    }
  }

  /// Export analysis result to JSON
  Future<String> exportToJSON(VideoAnalysisResult result) async {
    try {
      // Convert to JSON string
      final jsonStr = jsonEncode(result.toJson());

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final filename =
          'emotion_analysis_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$filename');

      await file.writeAsString(jsonStr);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting to JSON: $e');
      rethrow;
    }
  }

  /// Share analysis result
  Future<void> shareAnalysisResult(
    VideoAnalysisResult result, {
    bool asCSV = true,
  }) async {
    try {
      String filePath;

      if (asCSV) {
        filePath = await exportToCSV(result);
      } else {
        filePath = await exportToJSON(result);
      }

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'EmoSense Video Analysis Results',
        text:
            'Emotion analysis results for ${result.source} (${result.sourceType})',
      );
    } catch (e) {
      debugPrint('Error sharing analysis result: $e');
      rethrow;
    }
  }

  /// Generate a summary report for an analysis result
  String generateSummaryReport(VideoAnalysisResult result) {
    final StringBuffer buffer = StringBuffer();

    // Basic information
    buffer.writeln('EmoSense Video Analysis Report');
    buffer.writeln('-------------------------------');
    buffer.writeln(
      'Source: ${_formatSource(result.source, result.sourceType)}',
    );
    buffer.writeln('Analyzed on: ${_formatDateTime(result.timestamp)}');
    buffer.writeln(
      'Duration: ${_formatDuration(Duration(milliseconds: result.duration))}',
    );
    buffer.writeln('');

    // Overall emotions
    buffer.writeln('Overall Emotions:');
    result.overallEmotions.forEach((emotion, value) {
      buffer.writeln('  $emotion: ${(value * 100).toStringAsFixed(1)}%');
    });
    buffer.writeln('');

    // Most frequent emotion
    buffer.writeln('Most Frequent Emotion: ${result.getMostFrequentEmotion()}');
    buffer.writeln('');

    // Emotion changes
    buffer.writeln('Significant Emotion Changes:');
    _findSignificantChanges(result).forEach((entry) {
      buffer.writeln(
        '  ${_formatMilliseconds(entry["timestamp"] as int)}: ${entry["from"]} → ${entry["to"]}',
      );
    });

    return buffer.toString();
  }

  /// Find significant emotion changes in the timeline
  List<Map<String, dynamic>> _findSignificantChanges(
    VideoAnalysisResult result,
  ) {
    final List<Map<String, dynamic>> changes = [];
    final timestamps = result.timelineData.keys.toList()..sort();

    String previousEmotion = '';
    for (int i = 0; i < timestamps.length; i++) {
      final currentEmotion = result.getDominantEmotionAt(timestamps[i]);

      if (previousEmotion != '' && previousEmotion != currentEmotion) {
        changes.add({
          'timestamp': timestamps[i],
          'from': previousEmotion,
          'to': currentEmotion,
        });
      }

      previousEmotion = currentEmotion;
    }

    return changes;
  }

  /// Format source for display
  String _formatSource(String source, String sourceType) {
    if (sourceType == 'file') {
      // Extract just the filename
      return 'Local File: ${source.split('/').last}';
    } else {
      // Truncate long URLs
      if (source.length > 50) {
        return '$sourceType: ${source.substring(0, 47)}...';
      }
      return '$sourceType: $source';
    }
  }

  /// Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  /// Format milliseconds to MM:SS format
  String _formatMilliseconds(int milliseconds) {
    final Duration duration = Duration(milliseconds: milliseconds);
    return '${_twoDigits(duration.inMinutes.remainder(60))}:${_twoDigits(duration.inSeconds.remainder(60))}';
  }

  /// Format Duration to MM:SS format
  String _formatDuration(Duration duration) {
    return '${_twoDigits(duration.inMinutes.remainder(60))}:${_twoDigits(duration.inSeconds.remainder(60))}';
  }

  /// Format integer as two digits
  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  /// Get the file for storing analysis history
  Future<File> _getHistoryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/emosense_analysis_history.json');
  }
}
