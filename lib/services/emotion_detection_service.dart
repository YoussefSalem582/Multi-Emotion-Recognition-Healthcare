import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import '../models/emotion_data.dart';

class EmotionDetectionService {
  // Change this URL to your deployed Flask API
  final String baseUrl = 'http://localhost:5000';

  // Check if the API is running
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'healthy' && data['model_loaded'] == true;
      }
      return false;
    } catch (e) {
      print('Error checking API health: $e');
      return false;
    }
  }

  // Analyze a video file
  Future<Map<String, dynamic>> analyzeVideo(File videoFile) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/analyze'),
      );

      // Add the video file to the request
      var videoStream = http.ByteStream(videoFile.openRead());
      var videoLength = await videoFile.length();

      var multipartFile = http.MultipartFile(
        'video',
        videoStream,
        videoLength,
        filename: basename(videoFile.path),
        contentType: MediaType('video', 'mp4'),
      );

      request.files.add(multipartFile);

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze video: ${response.body}');
      }
    } catch (e) {
      print('Error analyzing video: $e');
      rethrow;
    }
  }

  // Convert API response to EmotionData list
  List<EmotionData> convertResponseToEmotionData(
    Map<String, dynamic> response,
  ) {
    List<dynamic> timestamps = response['emotion_timestamps'];
    return timestamps.map((item) {
      return EmotionData(
        timestamp: item['timestamp'],
        emotion: item['emotion'],
        confidence: item['confidence'].toDouble(),
      );
    }).toList();
  }

  // Get emotion distribution from response
  Map<String, double> getEmotionDistribution(Map<String, dynamic> response) {
    Map<String, dynamic> distribution = response['emotion_distribution'];
    Map<String, double> result = {};

    distribution.forEach((key, value) {
      result[key] = value.toDouble();
    });

    return result;
  }
}
