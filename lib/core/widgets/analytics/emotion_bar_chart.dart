import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/overflow_helper.dart';
import '../../utils/responsive_helper.dart';
import '../common/safe_area_container.dart';

/// A bar chart widget for displaying emotion data
class EmotionBarChart extends StatelessWidget {
  final Map<String, double> emotionData;
  final Map<String, Color>? colors;

  const EmotionBarChart({Key? key, required this.emotionData, this.colors})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort emotions by value (descending)
    final sortedEmotions =
        emotionData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Determine if we're on a small screen
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    // Create safe container that prevents overflow
    return SafeAreaContainer(
      minHeight: 120,
      maxHeight: 200,
      enableVerticalScroll: true,
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isSmallScreen ? 4.0 : 8.0,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: sortedEmotions.length,
        itemBuilder: (context, index) {
          final emotion = sortedEmotions[index];
          final emotionName = emotion.key;
          final emotionValue = emotion.value;
          final emotionColor = _getEmotionColor(emotionName);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildEmotionBar(
              context,
              emotionName,
              emotionValue,
              emotionColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmotionBar(
    BuildContext context,
    String emotionName,
    double value,
    Color color,
  ) {
    // Scale font sizes based on screen size
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final fontSize = isSmallScreen ? 11.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emotion name and percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Use overflow helper for text
            Expanded(
              flex: 3,
              child: OverflowHelper.handleLongText(
                text: emotionName,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
            ),
            // Percentage value
            Expanded(
              flex: 1,
              child: Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),

        // Add a small space
        SizedBox(height: 4.0),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.0,
          ),
        ),
      ],
    );
  }

  /// Get a color for an emotion
  Color _getEmotionColor(String emotion) {
    if (colors != null && colors!.containsKey(emotion)) {
      return colors![emotion]!;
    }

    // Default colors if not provided
    switch (emotion.toLowerCase()) {
      case 'happy':
        return AppColors.emotionHappy;
      case 'sad':
        return AppColors.emotionSad;
      case 'angry':
        return AppColors.emotionAngry;
      case 'fearful':
      case 'fear':
        return AppColors.emotionFearful;
      case 'surprised':
      case 'surprise':
        return AppColors.emotionSurprised;
      case 'disgusted':
      case 'disgust':
        return AppColors.emotionDisgusted;
      case 'neutral':
        return AppColors.emotionNeutral;
      case 'frustrated':
        return AppColors.orange;
      case 'confused':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }
}
