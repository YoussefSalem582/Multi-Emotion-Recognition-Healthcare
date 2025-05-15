import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../utils/video_url_analyzer.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A widget that displays a preview of a video from a social media platform
class SocialMediaVideoPreview extends StatefulWidget {
  /// The URL of the video
  final String? url;

  /// The local file path to the video if using a local file
  final File? file;

  /// The platform the video is from
  final String platform;

  /// Whether to autoplay the video
  final bool autoPlay;

  /// Video aspect ratio (width / height)
  final double aspectRatio;

  /// Creates a video preview widget
  const SocialMediaVideoPreview({
    Key? key,
    this.url,
    this.file,
    required this.platform,
    this.autoPlay = false,
    this.aspectRatio = 16 / 9,
  }) : assert(
         url != null || file != null,
         'Either url or file must be provided',
       ),
       super(key: key);

  @override
  State<SocialMediaVideoPreview> createState() =>
      _SocialMediaVideoPreviewState();
}

class _SocialMediaVideoPreviewState extends State<SocialMediaVideoPreview> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  String? _embedUrl;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(SocialMediaVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.file != widget.file) {
      _disposePlayer();
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    if (widget.file != null) {
      _videoController = VideoPlayerController.file(widget.file!);
      await _videoController!.initialize();
      if (widget.autoPlay) {
        await _videoController!.play();
      }
      setState(() {
        _isInitialized = true;
      });
    } else if (widget.url != null) {
      // For social media URLs, we need to use the appropriate approach
      if (_isDirectVideoUrl(widget.url!)) {
        // Direct video URL - use VideoPlayer
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.url!),
        );
        await _videoController!.initialize();
        if (widget.autoPlay) {
          await _videoController!.play();
        }
        setState(() {
          _isInitialized = true;
        });
      } else {
        // Use embed for social media
        _embedUrl = VideoUrlAnalyzer.getEmbedUrl(widget.url!);

        if (_embedUrl != null) {
          // Initialize WebView controller
          _webViewController =
              WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse(_embedUrl!));

          setState(() {
            _isInitialized = true;
          });
        }
      }
    }
  }

  bool _isDirectVideoUrl(String url) {
    // Check if the URL points directly to a video file
    final extension = url.split('.').last.toLowerCase();
    return ['mp4', 'webm', 'ogg', 'mov'].contains(extension);
  }

  void _disposePlayer() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
    _webViewController = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(
              color: VideoUrlAnalyzer.getColorForPlatform(widget.platform),
            ),
          ),
        ),
      );
    }

    if (_videoController != null) {
      // Video player for direct video files
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoController!),
            _VideoPlayerControls(controller: _videoController!),
          ],
        ),
      );
    } else if (_embedUrl != null) {
      // Embedded content for social media
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child:
            _webViewController != null
                ? WebViewWidget(controller: _webViewController!)
                : _buildUnsupportedPlatformView(),
      );
    } else {
      // Fallback for unsupported platforms
      return _buildUnsupportedPlatformView();
    }
  }

  Widget _buildUnsupportedPlatformView() {
    final Color platformColor = VideoUrlAnalyzer.getColorForPlatform(
      widget.platform,
    );
    final String platformName =
        widget.platform.substring(0, 1).toUpperCase() +
        widget.platform.substring(1);

    return GestureDetector(
      onTap: () => _launchUrl(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                VideoUrlAnalyzer.getIconForPlatform(widget.platform),
                color: platformColor,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Open in $platformName',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _launchUrl(),
                icon: Icon(Icons.open_in_new),
                label: Text('View Original'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: platformColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (widget.url != null) {
      final uri = Uri.parse(widget.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}

/// Custom video controls overlay
class _VideoPlayerControls extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoPlayerControls({required this.controller});

  @override
  _VideoPlayerControlsState createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<_VideoPlayerControls> {
  bool _showControls = true;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    // Add listener to update when playback state changes
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = widget.controller.value.isPlaying;
        });
      }
    });

    // Hide controls after a delay
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _isPlaying = !_isPlaying;
      _showControls = true;
      _hideControlsAfterDelay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
          if (_showControls) {
            _hideControlsAfterDelay();
          }
        });
      },
      child: Container(
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: _showControls ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Play/Pause button in center
                Center(
                  child: IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 64,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),

                // Progress bar at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildProgressBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, VideoPlayerValue value, child) {
        final position = value.position;
        final duration = value.duration;

        // Format time display
        final positionText = _formatDuration(position);
        final durationText = _formatDuration(duration);

        // Calculate progress
        final progress =
            duration.inMilliseconds > 0
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: progress,
                  onChanged: (value) {
                    final newPosition = Duration(
                      milliseconds: (value * duration.inMilliseconds).round(),
                    );
                    widget.controller.seekTo(newPosition);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      positionText,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      durationText,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
