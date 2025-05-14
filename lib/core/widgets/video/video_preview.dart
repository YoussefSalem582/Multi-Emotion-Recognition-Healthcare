import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

/// Widget for displaying video preview with playback controls
class VideoPreview extends StatelessWidget {
  final VideoPlayerController? videoController;
  final File? videoFile;
  final VoidCallback? onTap;

  const VideoPreview({
    Key? key,
    this.videoController,
    this.videoFile,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videoFile != null &&
        videoController != null &&
        videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(videoController!),
            Positioned.fill(
              child: GestureDetector(
                onTap:
                    onTap ??
                    () {
                      if (videoController!.value.isPlaying) {
                        videoController!.pause();
                      } else {
                        videoController!.play();
                      }
                    },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child:
                        videoController!.value.isPlaying
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
                videoController!,
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
                videoFile != null ? 'Preparing video...' : 'Video Preview',
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
}
