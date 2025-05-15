import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/core.dart';
import '../core/utils/video_url_analyzer.dart';
import '../core/widgets/video/social_media_video_input.dart';
import '../core/widgets/video/social_media_video_preview.dart';
import '../core/widgets/common/overflow_warning_fixer.dart';

/// An enhanced video analysis page that supports URLs from all social media platforms
class EnhancedVideoAnalysisPage extends StatefulWidget {
  const EnhancedVideoAnalysisPage({Key? key}) : super(key: key);

  @override
  State<EnhancedVideoAnalysisPage> createState() =>
      _EnhancedVideoAnalysisPageState();
}

class _EnhancedVideoAnalysisPageState extends State<EnhancedVideoAnalysisPage>
    with SingleTickerProviderStateMixin {
  // Video source variables
  File? _videoFile;
  String? _videoUrl;
  String _videoSource = 'upload';
  String _videoPlatform = 'youtube';

  // Analysis state
  bool _isVideoLoaded = false;
  bool _isAnalyzing = false;
  bool _isAnalysisComplete = false;

  // Tab controller
  late TabController _tabController;

  // Simulated analysis data
  final Map<String, double> _emotionData = {
    'Happy': 0.45,
    'Neutral': 0.25,
    'Confused': 0.15,
    'Frustrated': 0.10,
    'Angry': 0.05,
  };

  final List<Map<String, dynamic>> _emotionTimestamps = [
    {
      'time': '00:12',
      'emotion': 'Happy',
      'intensity': 0.85,
      'color': Colors.green,
    },
    {
      'time': '00:47',
      'emotion': 'Confused',
      'intensity': 0.70,
      'color': Colors.blue,
    },
    {
      'time': '01:23',
      'emotion': 'Frustrated',
      'intensity': 0.60,
      'color': Colors.orange,
    },
    {
      'time': '02:05',
      'emotion': 'Happy',
      'intensity': 0.75,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1, // Start on Social Media tab
    );

    // Force show content immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _videoUrl = "https://www.youtube.com/watch?v=sample-video";
          _videoPlatform = "youtube";
          _videoSource = "url";
          _isVideoLoaded = true;
          _isAnalysisComplete = true;
        });
      }
    });

    // Disable tab reset for now to ensure content stays visible
    /*
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

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
    */
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    });

    // Automatically start analysis
    _runAnalysis();
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
        setState(() {
          _isAnalyzing = false;
          _isAnalysisComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Analysis'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.file_upload), text: 'Upload Video'),
            Tab(icon: Icon(Icons.link), text: 'Social Media'),
          ],
        ),
      ),
      body: SafeAreaContainer(
        enableVerticalScroll: true,
        child: TabBarView(
          controller: _tabController,
          children: [_buildUploadTab(), _buildSocialMediaTab()],
        ),
      ),
    );
  }

  Widget _buildUploadTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: OverflowWarningFixer(
        axis: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Upload Video for Analysis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Upload a video from your device to analyze emotions throughout the recording.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Upload button
            if (!_isVideoLoaded) ...[
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickVideo,
                  icon: Icon(Icons.upload_file),
                  label: Text('Select Video'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],

            // Video preview
            if (_isVideoLoaded && _videoFile != null) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Selected Video',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SocialMediaVideoPreview(
                          file: _videoFile,
                          platform: 'local',
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: !_isAnalyzing ? _runAnalysis : null,
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
                          _isAnalyzing ? 'Analyzing...' : 'Analyze Video',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Analysis results
            if (_isAnalysisComplete) ...[
              SizedBox(height: 24),
              _buildSimpleAnalysisResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaTab() {
    // Always show content by using a simpler approach
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Analyze Social Media Videos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Enter a URL from any social media platform to analyze emotions.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),

          // Fixed video preview card
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
                    'Analyzing YouTube Video',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'https://youtube.com/watch?v=sample-video',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16),

                  // Video preview placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 180,
                      color: Colors.purple.withOpacity(0.1),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_fill,
                              color: Colors.purple,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Video Preview',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _runAnalysis,
                        icon: Icon(Icons.psychology),
                        label: Text('Analyze Video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.refresh),
                        label: Text('Try Another URL'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),
          _buildSimpleAnalysisResults(),
        ],
      ),
    );
  }

  // Simplified analysis results for more reliable display
  Widget _buildSimpleAnalysisResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Text(
          'Emotion Analysis Results',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 16),

        // Emotion summary card - simplified display
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
                  'Dominant Emotions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Simplified emotion display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEmotionIndicator('Happy', 0.45, Colors.green),
                    _buildEmotionIndicator('Neutral', 0.25, Colors.grey),
                    _buildEmotionIndicator('Confused', 0.15, Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Timeline card
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

                // Simplified timeline list
                Column(
                  children: [
                    _buildTimelineItem('00:12', 'Happy', 0.85, Colors.green),
                    Divider(),
                    _buildTimelineItem('00:47', 'Confused', 0.70, Colors.blue),
                    Divider(),
                    _buildTimelineItem(
                      '01:23',
                      'Frustrated',
                      0.60,
                      Colors.orange,
                    ),
                  ],
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Report saved to your device'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(Icons.download),
              label: Text('Save Report'),
            ),
            SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.refresh),
              label: Text('New Analysis'),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for emotion indicators
  Widget _buildEmotionIndicator(String emotion, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(emotion, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Helper for timeline items
  Widget _buildTimelineItem(
    String time,
    String emotion,
    double intensity,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(Icons.face, color: Colors.white),
      ),
      title: Text(emotion),
      subtitle: Text('Intensity: ${(intensity * 100).toInt()}%'),
      trailing: Text(
        time,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
