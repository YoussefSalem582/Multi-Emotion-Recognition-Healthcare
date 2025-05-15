import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../core/core.dart';
import '../core/utils/video_url_analyzer.dart';
import '../core/widgets/video/social_media_video_input.dart';
import '../core/widgets/video/social_media_video_preview.dart';
import '../core/widgets/video/video_analysis_controls.dart';
import '../core/widgets/analytics/emotion_timeline_chart.dart';
import '../core/services/video_analysis_service.dart';

/// A fully featured advanced video analysis page with clip selection, real-time analysis,
/// emotion customization, and comprehensive results visualization
class AdvancedVideoAnalysisPage extends StatefulWidget {
  const AdvancedVideoAnalysisPage({Key? key}) : super(key: key);

  @override
  State<AdvancedVideoAnalysisPage> createState() =>
      _AdvancedVideoAnalysisPageState();
}

class _AdvancedVideoAnalysisPageState extends State<AdvancedVideoAnalysisPage>
    with SingleTickerProviderStateMixin {
  // Video source variables
  File? _videoFile;
  String? _videoUrl;
  String _videoSource = 'upload';
  String _videoPlatform = 'youtube';

  // Video playback
  VideoPlayerController? _videoController;
  Timer? _positionUpdateTimer;

  // Analysis state
  bool _isVideoLoaded = false;
  bool _isAnalyzing = false;
  bool _isAnalysisComplete = false;
  bool _isRealTimeAnalysis = false;

  // Clip selection
  Duration _clipStart = Duration.zero;
  Duration _clipEnd = Duration.zero;

  // Selected emotions to analyze
  Map<String, bool> _selectedEmotions = {};

  // Tab controller
  late TabController _tabController;

  // Analysis service
  final VideoAnalysisService _analysisService = VideoAnalysisService();

  // Analysis result
  VideoAnalysisResult? _analysisResult;

  // Mock emotion data
  final List<String> _availableEmotions = [
    'Happy',
    'Sad',
    'Angry',
    'Surprised',
    'Neutral',
    'Disgusted',
    'Fearful',
  ];

  // Timeline data for real-time analysis
  final Map<int, Map<String, double>> _timelineData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen for tab changes to reset state
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      // Reset analysis state when changing tabs
      if (_isVideoLoaded || _isAnalyzing || _isAnalysisComplete) {
        _resetState();
      }
    });

    // Initialize selected emotions
    _initializeEmotions();

    // Start position update timer for real-time analysis
    _startPositionUpdateTimer();
  }

  void _initializeEmotions() {
    _selectedEmotions = {for (var emotion in _availableEmotions) emotion: true};
  }

  void _startPositionUpdateTimer() {
    _positionUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      if (_videoController != null &&
          _videoController!.value.isInitialized &&
          _videoController!.value.isPlaying &&
          _isRealTimeAnalysis &&
          !_isAnalyzing) {
        // Perform real-time analysis at current position
        _performRealTimeAnalysis();
      }
    });
  }

  void _performRealTimeAnalysis() {
    if (_videoController == null) return;

    // Get current position in milliseconds
    final position = _videoController!.value.position.inMilliseconds;

    // Skip if we already have analysis for this position
    if (_timelineData.containsKey(position)) return;

    // Generate mock emotion data
    final Map<String, double> emotions = {};
    double total = 0.0;

    // Generate random values based on current position
    for (final emotion in _availableEmotions) {
      if (_selectedEmotions[emotion] ?? false) {
        // Generate a semi-random value that changes smoothly over time
        final double value =
            0.1 +
            0.4 * ((position / 5000) % 1.0) * (emotion.length % 3 + 1) / 4;
        emotions[emotion] = value;
        total += value;
      }
    }

    // Normalize values
    if (total > 0) {
      emotions.forEach((key, value) {
        emotions[key] = value / total;
      });
    }

    // Add to timeline data
    setState(() {
      _timelineData[position] = emotions;
    });
  }

  @override
  void dispose() {
    _positionUpdateTimer?.cancel();
    _videoController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _resetState() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;

    setState(() {
      _isVideoLoaded = false;
      _isAnalyzing = false;
      _isAnalysisComplete = false;
      _videoFile = null;
      _videoUrl = null;
      _timelineData.clear();
    });
  }

  /// Pick a video from the device
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
        _videoPlatform = 'local';

        // Clear existing timeline data
        _timelineData.clear();
      });

      await _initializeVideoController();
    }
  }

  /// Initialize video player controller
  Future<void> _initializeVideoController() async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }

    if (_videoFile != null) {
      _videoController = VideoPlayerController.file(_videoFile!);
      await _videoController!.initialize();

      setState(() {
        // Set clip end to video duration
        _clipEnd = _videoController!.value.duration;
      });
    } else if (_videoUrl != null &&
        VideoUrlAnalyzer.detectPlatform(_videoUrl!) != 'other') {
      // For demo purposes, we'll use a direct video URL for initialization
      // In a real implementation, you'd use a service to extract direct video URLs from platform URLs
      final directUrl =
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      _videoController = VideoPlayerController.networkUrl(Uri.parse(directUrl));
      await _videoController!.initialize();

      setState(() {
        // Set clip end to video duration
        _clipEnd = _videoController!.value.duration;
      });
    }
  }

  /// Handle URL submission from SocialMediaVideoInput
  void _handleUrlSubmitted(String url, String platform) {
    setState(() {
      _videoUrl = url;
      _videoPlatform = platform;
      _videoSource = 'url';
      _isVideoLoaded = true;
      _isAnalysisComplete = false;
      _videoFile = null;

      // Clear existing timeline data
      _timelineData.clear();
    });

    _initializeVideoController();
  }

  /// Handle clip selection change
  void _handleClipSelected(Duration start, Duration end) {
    setState(() {
      _clipStart = start;
      _clipEnd = end;
    });

    // Seek to start position
    _videoController?.seekTo(_clipStart);
  }

  /// Handle analysis settings change
  void _handleAnalysisSettingsChanged(
    Map<String, bool> emotions,
    bool realTimeMode,
  ) {
    setState(() {
      _selectedEmotions = emotions;
      _isRealTimeAnalysis = realTimeMode;

      // Clear timeline data if changes to emotions
      _timelineData.clear();
    });
  }

  /// Handle position tapped on timeline
  void _handlePositionTapped(int position) {
    if (_videoController != null) {
      _videoController!.seekTo(Duration(milliseconds: position));
    }
  }

  /// Run the emotion analysis process
  void _runAnalysis() {
    setState(() {
      _isAnalyzing = true;
      _isAnalysisComplete = false;
    });

    // Simulate analysis process with a delay
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        // Create full emotion timeline data
        _generateFullAnalysisData();

        // Create analysis result
        final result = VideoAnalysisResult(
          source: _videoFile?.path ?? _videoUrl ?? 'unknown',
          sourceType: _videoSource == 'upload' ? 'file' : _videoPlatform,
          timestamp: DateTime.now(),
          overallEmotions: _calculateOverallEmotions(),
          timelineData: Map.from(_timelineData),
          duration: _videoController?.value.duration.inMilliseconds ?? 30000,
        );

        // Save result
        _analysisService.saveAnalysisResult(result);

        setState(() {
          _isAnalyzing = false;
          _isAnalysisComplete = true;
          _analysisResult = result;
        });
      }
    });
  }

  /// Generate full analysis data
  void _generateFullAnalysisData() {
    // Clear existing timeline data if we're doing a full analysis
    if (!_isRealTimeAnalysis) {
      _timelineData.clear();
    }

    final int startMs = _clipStart.inMilliseconds;
    final int endMs = _clipEnd.inMilliseconds;

    // Generate data points at regular intervals
    final int stepMs = 1000; // 1 second intervals

    for (int timeMs = startMs; timeMs <= endMs; timeMs += stepMs) {
      // Skip if we already have data for this timestamp (from real-time)
      if (_timelineData.containsKey(timeMs)) continue;

      // Generate random emotion values
      Map<String, double> emotions = {};
      double total = 0.0;

      // Generate semi-random values that change smoothly over time
      for (var emotion in _availableEmotions) {
        if (_selectedEmotions[emotion] ?? false) {
          // Create a wave-like pattern for each emotion
          final phase = timeMs / 5000.0 * (emotion.length % 3 + 1);
          final value = 0.2 + 0.3 * ((sin(phase) + 1) / 2);
          emotions[emotion] = value;
          total += value;
        }
      }

      // Normalize values
      if (total > 0) {
        emotions.forEach((key, value) {
          emotions[key] = value / total;
        });
      }

      // Add to timeline data
      _timelineData[timeMs] = emotions;
    }
  }

  /// Calculate overall emotions from timeline data
  Map<String, double> _calculateOverallEmotions() {
    Map<String, double> result = {};

    // Initialize with zeros
    for (var emotion in _availableEmotions) {
      if (_selectedEmotions[emotion] ?? false) {
        result[emotion] = 0.0;
      }
    }

    // Sum up values
    _timelineData.forEach((_, emotions) {
      emotions.forEach((emotion, value) {
        if (result.containsKey(emotion)) {
          result[emotion] = (result[emotion] ?? 0) + value;
        }
      });
    });

    // Calculate average
    if (_timelineData.isNotEmpty) {
      result.forEach((emotion, value) {
        result[emotion] = value / _timelineData.length;
      });
    }

    return result;
  }

  // Helper function for sin calculation
  double sin(double value) {
    return 0.5 * (value - value.floor()) + 0.25;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Video Analysis'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.file_upload), text: 'Upload Video'),
            Tab(icon: Icon(Icons.link), text: 'From URL'),
          ],
        ),
      ),
      body: SafeAreaContainer(
        enableVerticalScroll: true,
        child: TabBarView(
          controller: _tabController,
          children: [_buildUploadTab(), _buildUrlTab()],
        ),
      ),
    );
  }

  Widget _buildUploadTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Advanced Video Analysis',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Upload a video and customize analysis options for detailed insights.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),

          // Upload button/video preview
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
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Select Video File',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to upload a video from your device',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Video preview and controls
          if (_isVideoLoaded &&
              _videoController != null &&
              _videoController!.value.isInitialized) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Video title
                    Text(
                      'Video Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Video player
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),

                          // Play/pause button
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
                              child: Center(
                                child: Icon(
                                  _videoController!.value.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),

                          // Video progress
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: VideoProgressIndicator(
                              _videoController!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor:
                                    Theme.of(context).colorScheme.primary,
                                bufferedColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Video analysis controls
                    VideoAnalysisControls(
                      controller: _videoController,
                      availableEmotions: _availableEmotions,
                      onClipSelected: _handleClipSelected,
                      onAnalysisSettingsChanged: _handleAnalysisSettingsChanged,
                      isAnalyzing: _isAnalyzing,
                    ),

                    SizedBox(height: 16),

                    // Analysis button
                    ElevatedButton.icon(
                      onPressed: !_isAnalyzing ? _runAnalysis : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon:
                          _isAnalyzing
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(Icons.psychology),
                      label: Text(
                        _isAnalyzing ? 'Analyzing...' : 'Start Analysis',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Analysis results
          if (_isAnalysisComplete && _analysisResult != null) ...[
            SizedBox(height: 24),
            _buildAnalysisResults(),
          ],
        ],
      ),
    );
  }

  Widget _buildUrlTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Analyze Video from URL',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Enter a URL from any social media platform for detailed emotion analysis.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),

          // URL input
          if (!_isVideoLoaded || _videoSource != 'url') ...[
            SocialMediaVideoInput(
              onUrlSubmitted: _handleUrlSubmitted,
              autoPlatformDetection: true,
            ),
          ],

          // Video preview and controls
          if (_isVideoLoaded && _videoUrl != null) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Video title
                    Text(
                      '${_videoPlatform.substring(0, 1).toUpperCase() + _videoPlatform.substring(1)} Video',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    // URL display
                    Text(
                      _videoUrl!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 16),

                    // Video preview
                    if (_isAnalyzing) ...[
                      Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                VideoUrlAnalyzer.getColorForPlatform(
                                  _videoPlatform,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Analyzing emotions from $_videoPlatform video...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_videoController != null &&
                        _videoController!.value.isInitialized) ...[
                      // Video player
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_videoController!),

                            // Play/pause button
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
                                child: Center(
                                  child: Icon(
                                    _videoController!.value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),

                            // Video progress
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: VideoProgressIndicator(
                                _videoController!,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor:
                                      Theme.of(context).colorScheme.primary,
                                  bufferedColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Fallback preview
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SocialMediaVideoPreview(
                          url: _videoUrl,
                          platform: _videoPlatform,
                        ),
                      ),
                    ],

                    SizedBox(height: 16),

                    // Video analysis controls (if video controller is initialized)
                    if (_videoController != null &&
                        _videoController!.value.isInitialized) ...[
                      VideoAnalysisControls(
                        controller: _videoController,
                        availableEmotions: _availableEmotions,
                        onClipSelected: _handleClipSelected,
                        onAnalysisSettingsChanged:
                            _handleAnalysisSettingsChanged,
                        isAnalyzing: _isAnalyzing,
                      ),

                      SizedBox(height: 16),
                    ],

                    // Analysis button
                    ElevatedButton.icon(
                      onPressed: !_isAnalyzing ? _runAnalysis : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: VideoUrlAnalyzer.getColorForPlatform(
                          _videoPlatform,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon:
                          _isAnalyzing
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(Icons.psychology),
                      label: Text(
                        _isAnalyzing ? 'Analyzing...' : 'Start Analysis',
                      ),
                    ),

                    SizedBox(height: 16),

                    // Change URL button
                    if (!_isAnalyzing) ...[
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isVideoLoaded = false;
                            _videoUrl = null;
                            _isAnalysisComplete = false;
                          });
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Try Another URL'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          // Analysis results
          if (_isAnalysisComplete && _analysisResult != null) ...[
            SizedBox(height: 24),
            _buildAnalysisResults(),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    if (_analysisResult == null) return SizedBox();

    // Prepare data for charts
    final emotionColors = _analysisResult!.getEmotionColors();
    final emotionNames = _analysisResult!.overallEmotions.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Text(
          'Analysis Results',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),

        // Emotion pie chart
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
                  'Overall Emotions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: EmotionChart(
                    emotions: _analysisResult!.overallEmotions,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Emotion timeline
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
                  'Emotion Timeline',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                EmotionTimelineChart(
                  timelineData: _analysisResult!.timelineData,
                  currentPosition:
                      _videoController?.value.position.inMilliseconds ?? 0,
                  totalDuration:
                      _videoController?.value.duration.inMilliseconds ?? 60000,
                  emotionNames: emotionNames,
                  emotionColors: emotionColors,
                  onPositionTapped: _handlePositionTapped,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Significant emotion changes
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
                  'Analysis Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Most Frequent Emotion: ${_analysisResult!.getMostFrequentEmotion()}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Analysis Duration: ${_formatDuration(Duration(milliseconds: _analysisResult!.duration))}',
                ),
                SizedBox(height: 16),
                Text(
                  'Summary Report:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _analysisService.generateSummaryReport(_analysisResult!),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _analysisService.shareAnalysisResult(
                    _analysisResult!,
                    asCSV: true,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Analysis results shared as CSV'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error sharing results: $e'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: Icon(Icons.share),
              label: Text('Share Results'),
            ),
            SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isAnalysisComplete = false;
                  _timelineData.clear();
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('New Analysis'),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
