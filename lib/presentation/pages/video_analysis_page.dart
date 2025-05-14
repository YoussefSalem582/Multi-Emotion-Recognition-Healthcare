import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';

class VideoAnalysisPage extends StatefulWidget {
  const VideoAnalysisPage({super.key});

  @override
  State<VideoAnalysisPage> createState() => _VideoAnalysisPageState();
}

class _VideoAnalysisPageState extends State<VideoAnalysisPage> {
  bool _isAnalyzing = false;
  bool _hasVideo = false;
  String? _videoPath;

  @override
  Widget build(BuildContext context) {
    final emotionProvider = Provider.of<EmotionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Video Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Analyze Emotions in Video',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a video to detect emotions throughout the recording.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Video upload area
            Center(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child:
                    _hasVideo
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam,
                                size: 48,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Video ready for analysis',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _hasVideo = false;
                                    _videoPath = null;
                                  });
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Remove'),
                              ),
                            ],
                          ),
                        )
                        : InkWell(
                          onTap: _pickVideo,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tap to upload video',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'or drag and drop file here',
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),

            // Analysis button
            Center(
              child: ElevatedButton.icon(
                onPressed:
                    _hasVideo && !_isAnalyzing
                        ? () {
                          _analyzeVideo();
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon:
                    _isAnalyzing
                        ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                        : const Icon(Icons.psychology),
                label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Video'),
              ),
            ),
            const SizedBox(height: 24),

            // Results section (placeholder)
            if (emotionProvider.detectedEmotions.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Results',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: emotionProvider.detectedEmotions.length,
                        itemBuilder: (context, index) {
                          final emotion =
                              emotionProvider.detectedEmotions[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: emotion.color.withOpacity(0.2),
                              child: Icon(emotion.icon, color: emotion.color),
                            ),
                            title: Text(emotion.name),
                            subtitle: Text(
                              'Confidence: ${(emotion.intensity * 100).toStringAsFixed(1)}%',
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _pickVideo() async {
    // In a real app, you would use image_picker to select a video
    // For this example, we'll just simulate selecting a video
    setState(() {
      _hasVideo = true;
      _videoPath = 'simulated_video_path.mp4';
    });
  }

  void _analyzeVideo() async {
    if (_videoPath == null) return;

    final emotionProvider = Provider.of<EmotionProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // In a real app, this would analyze the actual video
      await emotionProvider.detectFromVideo(_videoPath!);
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
}
