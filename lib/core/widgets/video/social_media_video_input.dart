import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/video_url_analyzer.dart';
import '../common/overflow_warning_fixer.dart';

/// A widget that allows users to input videos from various social media platforms
class SocialMediaVideoInput extends StatefulWidget {
  /// Callback when a valid URL is entered and submitted
  final Function(String url, String platform) onUrlSubmitted;

  /// Whether to automatically detect platform from URL
  final bool autoPlatformDetection;

  /// Creates a video input widget for social media URLs
  const SocialMediaVideoInput({
    Key? key,
    required this.onUrlSubmitted,
    this.autoPlatformDetection = true,
  }) : super(key: key);

  @override
  State<SocialMediaVideoInput> createState() => _SocialMediaVideoInputState();
}

class _SocialMediaVideoInputState extends State<SocialMediaVideoInput>
    with SingleTickerProviderStateMixin {
  // Controllers for the URL input fields
  final Map<String, TextEditingController> _controllers = {};

  // Tab controller
  late TabController _tabController;

  // Keep track of the current platform
  String _currentPlatform = 'youtube';

  // Platforms to include in the tabs
  final List<String> _platforms = [
    'youtube',
    'tiktok',
    'facebook',
    'instagram',
    'twitter',
    'vimeo',
    'twitch',
    'other',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize tab controller
    _tabController = TabController(length: _platforms.length, vsync: this);

    // Initialize controllers for each platform
    for (final platform in _platforms) {
      _controllers[platform] = TextEditingController();
    }

    // Add listener to tab controller to update current platform
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _currentPlatform = _platforms[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    // Dispose all text controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  /// Validates and submits the URL
  void _submitUrl() {
    final url = _controllers[_currentPlatform]!.text.trim();

    if (url.isEmpty) {
      _showError('Please enter a URL');
      return;
    }

    // If auto-detection is enabled, detect platform
    final platform =
        widget.autoPlatformDetection
            ? VideoUrlAnalyzer.detectPlatform(url)
            : _currentPlatform;

    // Validate URL for the detected or selected platform
    final isValid = VideoUrlAnalyzer.isValidUrl(url, platform);

    if (isValid) {
      widget.onUrlSubmitted(url, platform);
    } else {
      _showError('Invalid $platform URL format');
    }
  }

  /// Shows an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  /// Builds a tab for a specific platform
  Widget _buildPlatformTab(String platform) {
    final IconData iconData = VideoUrlAnalyzer.getIconForPlatform(platform);
    final Color platformColor = VideoUrlAnalyzer.getColorForPlatform(platform);
    final String displayName =
        platform.substring(0, 1).toUpperCase() + platform.substring(1);

    String hintText;
    switch (platform) {
      case 'youtube':
        hintText = 'https://www.youtube.com/watch?v=...';
        break;
      case 'tiktok':
        hintText = 'https://www.tiktok.com/@username/video/...';
        break;
      case 'facebook':
        hintText = 'https://www.facebook.com/watch/?v=...';
        break;
      case 'instagram':
        hintText = 'https://www.instagram.com/p/...';
        break;
      case 'twitter':
        hintText = 'https://twitter.com/username/status/...';
        break;
      case 'vimeo':
        hintText = 'https://vimeo.com/...';
        break;
      case 'twitch':
        hintText = 'https://www.twitch.tv/videos/...';
        break;
      default:
        hintText = 'https://...';
        break;
    }

    return Tab(icon: Icon(iconData), text: displayName);
  }

  /// Builds the input field for the current platform
  Widget _buildInputField(String platform) {
    final Color platformColor = VideoUrlAnalyzer.getColorForPlatform(platform);
    final String displayName =
        platform.substring(0, 1).toUpperCase() + platform.substring(1);
    final controller = _controllers[platform]!;

    String hintText;
    String description;

    switch (platform) {
      case 'youtube':
        hintText = 'https://www.youtube.com/watch?v=...';
        description =
            'Paste a YouTube video link to analyze emotions throughout the video.';
        break;
      case 'tiktok':
        hintText = 'https://www.tiktok.com/@username/video/...';
        description = 'Paste a TikTok video link to analyze emotions.';
        break;
      case 'facebook':
        hintText = 'https://www.facebook.com/watch/?v=...';
        description = 'Paste a Facebook video link to analyze emotions.';
        break;
      case 'instagram':
        hintText = 'https://www.instagram.com/p/...';
        description =
            'Paste an Instagram video or reel link to analyze emotions.';
        break;
      case 'twitter':
        hintText = 'https://twitter.com/username/status/...';
        description = 'Paste a Twitter/X video link to analyze emotions.';
        break;
      case 'vimeo':
        hintText = 'https://vimeo.com/...';
        description = 'Paste a Vimeo video link to analyze emotions.';
        break;
      case 'twitch':
        hintText = 'https://www.twitch.tv/videos/...';
        description = 'Paste a Twitch video or clip link to analyze emotions.';
        break;
      default:
        hintText = 'https://...';
        description =
            'Paste a link from any other platform to analyze emotions.';
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze $displayName Video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: '$displayName URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(VideoUrlAnalyzer.getIconForPlatform(platform)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: platformColor, width: 2),
                ),
              ),
              onChanged: (value) {
                // If auto-detection is enabled, detect platform from URL and switch tabs
                if (widget.autoPlatformDetection && value.isNotEmpty) {
                  final detectedPlatform = VideoUrlAnalyzer.detectPlatform(
                    value,
                  );

                  if (detectedPlatform != 'other' &&
                      detectedPlatform != platform) {
                    final index = _platforms.indexOf(detectedPlatform);
                    if (index >= 0) {
                      _tabController.animateTo(index);

                      // Copy the URL to the correct controller
                      _controllers[detectedPlatform]!.text = value;

                      // Clear this controller
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.clear();
                      });
                    }
                  }
                }
              },
              inputFormatters: [
                // Filter to ensure valid URL characters
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9:/?=&._-]'),
                ),
              ],
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              onSubmitted: (_) => _submitUrl(),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitUrl,
                icon: Icon(Icons.psychology),
                label: Text('Analyze $displayName Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: platformColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverflowWarningFixer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs:
                _platforms
                    .map((platform) => _buildPlatformTab(platform))
                    .toList(),
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 280, // Fixed height for the content area
            child: TabBarView(
              controller: _tabController,
              children:
                  _platforms
                      .map((platform) => _buildInputField(platform))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
