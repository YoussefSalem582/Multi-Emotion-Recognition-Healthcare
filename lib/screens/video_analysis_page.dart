import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/emotion_detection_service.dart';
import '../models/emotion_data.dart';

class VideoAnalysisPage extends StatefulWidget {
  @override
  _VideoAnalysisPageState createState() => _VideoAnalysisPageState();
}

class _VideoAnalysisPageState extends State<VideoAnalysisPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _youtubeUrlController = TextEditingController();
  final TextEditingController _tiktokUrlController = TextEditingController();
  final TextEditingController _facebookUrlController = TextEditingController();
  final TextEditingController _instagramUrlController = TextEditingController();
  final TextEditingController _otherUrlController = TextEditingController();

  late TabController _tabController;
  VideoPlayerController? _videoController;
  bool _isVideoLoaded = false;
  bool _isAnalyzing = false;
  bool _isAnalysisComplete = false;
  File? _videoFile;
  String? _videoUrl;
  String _videoSource = 'upload';

  // Emotion detection service
  final EmotionDetectionService _emotionService = EmotionDetectionService();

  // Real analysis data
  Map<String, double> _emotionData = {
    'neutral': 0.0,
    'anger': 0.0,
    'disgust': 0.0,
    'fear': 0.0,
    'joy': 0.0,
    'sadness': 0.0,
    'surprise': 0.0,
  };

  List<Map<String, dynamic>> _emotionTimestamps = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Listen for tab changes
    _tabController.addListener(() {
      // Reset analysis state when changing tabs
      if (_isVideoLoaded || _isAnalyzing || _isAnalysisComplete) {
        setState(() {
          _isVideoLoaded = false;
          _isAnalyzing = false;
          _isAnalysisComplete = false;
          _videoFile = null;
          _videoUrl = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _youtubeUrlController.dispose();
    _tiktokUrlController.dispose();
    _facebookUrlController.dispose();
    _instagramUrlController.dispose();
    _otherUrlController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 10),
    );

    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
        _isVideoLoaded = true;
        _isAnalysisComplete = false;
        _videoUrl = null;
        _videoSource = 'upload';
      });

      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoFile != null) {
      _videoController = VideoPlayerController.file(_videoFile!);
      await _videoController!.initialize();
      setState(() {});
    }
  }

  void _analyzeUrl(String platform) {
    String url = '';
    switch (platform) {
      case 'youtube':
        url = _youtubeUrlController.text.trim();
        break;
      case 'tiktok':
        url = _tiktokUrlController.text.trim();
        break;
      case 'facebook':
        url = _facebookUrlController.text.trim();
        break;
      case 'instagram':
        url = _instagramUrlController.text.trim();
        break;
      case 'other':
        url = _otherUrlController.text.trim();
        break;
    }

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid URL'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    bool isValid = _validateUrl(url, platform);

    if (isValid) {
      setState(() {
        _videoUrl = url;
        _isVideoLoaded = true;
        _videoFile = null;
        _isAnalysisComplete = false;
        _videoSource = platform;
      });
      _runAnalysis();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid $platform URL'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _validateUrl(String url, String platform) {
    // Basic URL validation based on platform
    switch (platform) {
      case 'youtube':
        return url.contains('youtube.com') || url.contains('youtu.be');
      case 'tiktok':
        return url.contains('tiktok.com');
      case 'facebook':
        return url.contains('facebook.com') || url.contains('fb.watch');
      case 'instagram':
        return url.contains('instagram.com');
      default:
        return Uri.tryParse(url)?.hasScheme ?? false;
    }
  }

  void _runAnalysis() async {
    // Check if the API is available
    bool isApiAvailable = await _emotionService.checkHealth();
    if (!isApiAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Emotion detection service is not available. Please try again later.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _isAnalysisComplete = false;
    });

    try {
      if (_videoFile != null) {
        // Use the real emotion detection service
        final result = await _emotionService.analyzeVideo(_videoFile!);

        // Convert API response to our data format
        final emotionDistribution = _emotionService.getEmotionDistribution(
          result,
        );
        final List<EmotionData> emotionDataList = _emotionService
            .convertResponseToEmotionData(result);

        // Update the UI with real data
        setState(() {
          _emotionData = emotionDistribution;

          // Convert EmotionData to the format expected by the UI
          _emotionTimestamps =
              emotionDataList.map((data) {
                // Format timestamp as MM:SS
                int minutes = (data.timestamp / 60).floor();
                int seconds = data.timestamp % 60;
                String formattedTime =
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                return {
                  'time': formattedTime,
                  'emotion': data.emotion,
                  'intensity': data.confidence,
                  'color': _getEmotionColor(data.emotion),
                };
              }).toList();

          _isAnalyzing = false;
          _isAnalysisComplete = true;
        });
      } else if (_videoUrl != null) {
        // For now, just simulate analysis for URLs
        // In a real implementation, you would download the video or use a different API endpoint
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isAnalyzing = false;
              _isAnalysisComplete = true;
            });
          }
        });
      }
    } catch (e) {
      print('Error analyzing video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze video: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Analysis'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(icon: Icon(Icons.file_upload_outlined), text: 'Upload'),
            Tab(icon: Icon(Icons.play_circle_outline), text: 'YouTube'),
            Tab(icon: Icon(Icons.music_note), text: 'TikTok'),
            Tab(icon: Icon(Icons.facebook), text: 'Facebook'),
            Tab(icon: Icon(Icons.camera_alt), text: 'Instagram'),
            Tab(icon: Icon(Icons.more_horiz), text: 'More'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUploadTab(),
          _buildSocialMediaTab('youtube'),
          _buildSocialMediaTab('tiktok'),
          _buildSocialMediaTab('facebook'),
          _buildSocialMediaTab('instagram'),
          _buildSocialMediaTab('other'),
        ],
      ),
    );
  }

  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upload card
          if (!_isVideoLoaded) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: _pickVideo,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 220,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cloud_upload,
                          size: 48,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tap to upload a video',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Supported formats: MP4, MOV, AVI (Max: 10 minutes)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // Video preview and analysis
            _buildVideoPreview(),
            SizedBox(height: 20),

            if (_isAnalyzing) ...[
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing emotions in video...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ] else if (!_isAnalysisComplete) ...[
              ElevatedButton.icon(
                onPressed: _runAnalysis,
                icon: Icon(Icons.psychology),
                label: Text('Analyze Emotions'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ] else ...[
              _buildAnalysisResults(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSocialMediaTab(String platform) {
    // Configure platform-specific elements
    String hintText = '';
    String labelText = '';
    String buttonText = '';
    IconData iconData = Icons.link;
    TextEditingController controller;
    String description = '';
    Color platformColor;

    switch (platform) {
      case 'youtube':
        hintText = 'https://www.youtube.com/watch?v=...';
        labelText = 'YouTube URL';
        buttonText = 'Analyze YouTube Video';
        iconData = Icons.play_circle_outline;
        controller = _youtubeUrlController;
        description =
            'Paste a YouTube video link to analyze emotions throughout the video.';
        platformColor = Colors.red;
        break;
      case 'tiktok':
        hintText = 'https://www.tiktok.com/@username/video/...';
        labelText = 'TikTok URL';
        buttonText = 'Analyze TikTok Video';
        iconData = Icons.music_note;
        controller = _tiktokUrlController;
        description = 'Paste a TikTok video link to analyze emotions.';
        platformColor = Colors.teal;
        break;
      case 'facebook':
        hintText = 'https://www.facebook.com/watch/?v=...';
        labelText = 'Facebook Video URL';
        buttonText = 'Analyze Facebook Video';
        iconData = Icons.facebook;
        controller = _facebookUrlController;
        description = 'Paste a Facebook video link to analyze emotions.';
        platformColor = Colors.blue;
        break;
      case 'instagram':
        hintText = 'https://www.instagram.com/p/...';
        labelText = 'Instagram Post URL';
        buttonText = 'Analyze Instagram Video';
        iconData = Icons.camera_alt;
        controller = _instagramUrlController;
        description =
            'Paste an Instagram video or reel link to analyze emotions.';
        platformColor = Colors.purple;
        break;
      case 'other':
      default:
        hintText = 'https://...';
        labelText = 'Video URL';
        buttonText = 'Analyze Video';
        iconData = Icons.link;
        controller = _otherUrlController;
        description =
            'Paste a link from Vimeo, Twitch, or other platforms to analyze emotions.';
        platformColor = Colors.orange;
        break;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(iconData, color: platformColor),
                      SizedBox(width: 8),
                      Text(
                        '${platform.substring(0, 1).toUpperCase()}${platform.substring(1)} Video Analysis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: labelText,
                      hintText: hintText,
                      prefixIcon: Icon(iconData),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _analyzeUrl(platform),
                    icon: Icon(Icons.search),
                    label: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: platformColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          if (_videoUrl != null && _videoSource == platform) ...[
            if (_isAnalyzing) ...[
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(platformColor),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing emotions from $platform video...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ] else if (_isAnalysisComplete) ...[
              _buildVideoSourceCard(platform, platformColor),
              SizedBox(height: 20),
              _buildAnalysisResults(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildVideoSourceCard(String platform, Color platformColor) {
    String platformName =
        platform.substring(0, 1).toUpperCase() + platform.substring(1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: platformColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getPlatformIcon(platform),
                    size: 64,
                    color: platformColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '$platformName Video',
                    style: TextStyle(
                      color: platformColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$platformName URL',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  _videoUrl!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(_videoUrl!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: Icon(Icons.open_in_new),
                  label: Text('Open in $platformName'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: platformColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'youtube':
        return Icons.play_circle_outline;
      case 'tiktok':
        return Icons.music_note;
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      default:
        return Icons.link;
    }
  }

  Widget _buildVideoPreview() {
    if (_videoFile != null &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoController!),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child:
                        _videoController!.value.isPlaying
                            ? Container()
                            : Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                  ),
                ),
              ),
            ),
            // Add video progress indicator at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                _videoController!,
                allowScrubbing: true,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                colors: VideoProgressColors(
                  playedColor: Theme.of(context).colorScheme.primary,
                  bufferedColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.3),
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 8),
              Text(
                _videoFile != null ? 'Preparing video...' : 'Video Preview',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildAnalysisResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emotion Analysis Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Overall Emotion Breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                ..._emotionData.entries.map((entry) {
                  final color = _getEmotionColor(entry.key);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text('${(entry.value * 100).toInt()}%'),
                          ],
                        ),
                        SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: entry.value,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Key Emotional Moments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ..._emotionTimestamps.map((moment) {
          return Card(
            elevation: 1,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: moment['color'].withOpacity(0.2),
                child: Text(
                  moment['time'],
                  style: TextStyle(
                    color: moment['color'],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                moment['emotion'],
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: LinearProgressIndicator(
                value: moment['intensity'],
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(moment['color']),
                borderRadius: BorderRadius.circular(10),
              ),
              trailing: IconButton(
                icon: Icon(Icons.play_circle_outline),
                onPressed: () {
                  // Jump to this timestamp in the video
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Jumping to timestamp ${moment['time']}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),

        // Add export options
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saving analysis results...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(Icons.download),
              label: Text('Save Results'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sharing analysis results...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(Icons.share),
              label: Text('Share Analysis'),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
        return Colors.green;
      case 'neutral':
        return Colors.grey;
      case 'surprise':
        return Colors.blue;
      case 'fear':
        return Colors.purple;
      case 'anger':
        return Colors.red;
      case 'sadness':
        return Colors.indigo;
      case 'disgust':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }
}
