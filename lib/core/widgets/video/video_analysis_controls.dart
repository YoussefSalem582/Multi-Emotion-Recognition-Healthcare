import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../utils/responsive_helper.dart';

/// Advanced controls for video analysis that allows clip selection and analysis options
class VideoAnalysisControls extends StatefulWidget {
  /// Video controller to control playback
  final VideoPlayerController? controller;

  /// Available emotion categories to detect
  final List<String> availableEmotions;

  /// Callback when a clip selection changes
  final Function(Duration start, Duration end)? onClipSelected;

  /// Callback when analysis settings change
  final Function(Map<String, bool> emotions, bool realTimeMode)?
  onAnalysisSettingsChanged;

  /// Whether analysis is in progress
  final bool isAnalyzing;

  /// Creates advanced video analysis controls
  const VideoAnalysisControls({
    Key? key,
    this.controller,
    this.availableEmotions = const [
      'Happy',
      'Sad',
      'Angry',
      'Surprised',
      'Neutral',
      'Disgusted',
      'Fearful',
    ],
    this.onClipSelected,
    this.onAnalysisSettingsChanged,
    this.isAnalyzing = false,
  }) : super(key: key);

  @override
  State<VideoAnalysisControls> createState() => _VideoAnalysisControlsState();
}

class _VideoAnalysisControlsState extends State<VideoAnalysisControls> {
  // Clip selection values (in milliseconds)
  RangeValues _clipSelection = const RangeValues(0, 0);

  // Start/end values in readable format
  String _startValue = '00:00';
  String _endValue = '00:00';

  // Track video duration
  Duration _videoDuration = Duration.zero;

  // Selected emotions to analyze
  Map<String, bool> _selectedEmotions = {};

  // Whether to analyze in real-time as video plays
  bool _realTimeAnalysis = false;

  // Whether the advanced settings panel is expanded
  bool _showAdvancedSettings = false;

  @override
  void initState() {
    super.initState();

    // Initialize selected emotions (all true by default)
    _initializeEmotions();

    // Set up video controller listener
    if (widget.controller != null) {
      _initializeController();
    }
  }

  @override
  void didUpdateWidget(VideoAnalysisControls oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        oldWidget.controller!.removeListener(_updateVideoInfo);
      }

      if (widget.controller != null) {
        _initializeController();
      }
    }

    // Reinitialize emotions if they changed
    if (widget.availableEmotions != oldWidget.availableEmotions) {
      _initializeEmotions();
    }
  }

  void _initializeEmotions() {
    _selectedEmotions = {
      for (var emotion in widget.availableEmotions) emotion: true,
    };
  }

  void _initializeController() {
    final controller = widget.controller;
    if (controller == null) return;

    controller.addListener(_updateVideoInfo);

    if (controller.value.isInitialized) {
      _updateVideoDuration();
    }
  }

  void _updateVideoInfo() {
    if (!mounted || widget.controller == null) return;

    if (widget.controller!.value.isInitialized &&
        _videoDuration != widget.controller!.value.duration) {
      _updateVideoDuration();
    }
  }

  void _updateVideoDuration() {
    setState(() {
      _videoDuration = widget.controller!.value.duration;

      // Update clip selection to cover full video
      _clipSelection = RangeValues(0, _videoDuration.inMilliseconds.toDouble());

      // Update display values
      _endValue = _formatDuration(_videoDuration);
    });
  }

  /// Format duration to MM:SS format
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Called when the clip selection slider is changed
  void _onClipSelectionChanged(RangeValues values) {
    setState(() {
      _clipSelection = values;

      // Update display strings
      final startDuration = Duration(milliseconds: values.start.round());
      final endDuration = Duration(milliseconds: values.end.round());

      _startValue = _formatDuration(startDuration);
      _endValue = _formatDuration(endDuration);

      // Call the callback if provided
      if (widget.onClipSelected != null) {
        widget.onClipSelected!(startDuration, endDuration);
      }
    });
  }

  /// Called when an emotion checkbox is toggled
  void _toggleEmotion(String emotion, bool? isSelected) {
    if (isSelected == null) return;

    setState(() {
      _selectedEmotions[emotion] = isSelected;

      // Notify about settings changes
      _notifySettingsChanged();
    });
  }

  /// Called when real-time analysis mode is toggled
  void _toggleRealTimeAnalysis(bool? value) {
    if (value == null) return;

    setState(() {
      _realTimeAnalysis = value;

      // Notify about settings changes
      _notifySettingsChanged();
    });
  }

  /// Notify parent about analysis settings changes
  void _notifySettingsChanged() {
    if (widget.onAnalysisSettingsChanged != null) {
      widget.onAnalysisSettingsChanged!(_selectedEmotions, _realTimeAnalysis);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and expand toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analysis Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    _showAdvancedSettings
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _showAdvancedSettings = !_showAdvancedSettings;
                    });
                  },
                ),
              ],
            ),

            // Clip selection title
            Row(
              children: [
                Icon(Icons.content_cut, size: 20),
                SizedBox(width: 8),
                Text(
                  'Clip Selection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Time display
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start: $_startValue',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'End: $_endValue',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Clip selection slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor:
                    Theme.of(context).colorScheme.primaryContainer,
                thumbColor: Theme.of(context).colorScheme.primary,
                overlayColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.2),
                valueIndicatorColor: Theme.of(context).colorScheme.primary,
                valueIndicatorTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: RangeSlider(
                values: _clipSelection,
                min: 0,
                max: _videoDuration.inMilliseconds.toDouble(),
                divisions:
                    _videoDuration.inSeconds > 0 ? _videoDuration.inSeconds : 1,
                labels: RangeLabels(_startValue, _endValue),
                onChanged: widget.isAnalyzing ? null : _onClipSelectionChanged,
              ),
            ),

            // Advanced analysis options (expandable)
            if (_showAdvancedSettings) ...[
              Divider(height: 32),

              // Real-time analysis toggle
              SwitchListTile(
                title: Row(
                  children: [
                    Icon(Icons.av_timer, size: 20),
                    SizedBox(width: 8),
                    Text('Real-time Analysis'),
                  ],
                ),
                subtitle: Text('Analyze emotions as the video plays'),
                value: _realTimeAnalysis,
                onChanged: widget.isAnalyzing ? null : _toggleRealTimeAnalysis,
                dense: true,
              ),

              SizedBox(height: 8),

              // Emotions selection
              Row(
                children: [
                  Icon(Icons.face, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Emotions to Detect',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // Emotion checkboxes in a wrap
              Wrap(
                spacing: isSmallScreen ? 4 : 8,
                runSpacing: 0,
                children:
                    widget.availableEmotions.map((emotion) {
                      return SizedBox(
                        width: isSmallScreen ? 120 : 150,
                        child: CheckboxListTile(
                          title: Text(
                            emotion,
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                          value: _selectedEmotions[emotion] ?? true,
                          onChanged:
                              widget.isAnalyzing
                                  ? null
                                  : (value) => _toggleEmotion(emotion, value),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
