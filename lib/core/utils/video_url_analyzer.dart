import 'package:flutter/material.dart';

/// A utility class to analyze and validate video URLs from various social media platforms
class VideoUrlAnalyzer {
  /// Map of supported platforms and their regex patterns
  static final Map<String, RegExp> _platformPatterns = {
    'youtube': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$',
      caseSensitive: false,
    ),
    'tiktok': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m|vm)\.)?((?:tiktok\.com))(\/(?:@[\w\.-]+\/video\/)?)([\w\-]+)(\S+)?$',
      caseSensitive: false,
    ),
    'facebook': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m|web|business)\.)?((?:facebook\.com|fb\.watch))(\/(?:watch|reel|video|story|)(?:\?v=|\/)?)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'instagram': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:instagram\.com))(\/(?:p|reel|tv)\/)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'twitter': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:twitter\.com|x\.com))(\/[\w\-\.]+\/status\/)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'vimeo': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|player)\.)?((?:vimeo\.com))(\/(?:video\/)?)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'twitch': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|go|m|clips)\.)?((?:twitch\.tv))(\/(?:[\w\-\.]+\/clip\/|clips\/)?)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'linkedin': RegExp(
      r'^((?:https?:)?\/\/)?((?:www)\.)?((?:linkedin\.com))(\/posts\/|\/feed\/update\/urn:li:activity:)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'reddit': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|old|new)\.)?((?:reddit\.com))(\/r\/[\w\-\.]+\/comments\/)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'pinterest': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|pin)\.)?((?:pinterest\.com))(\/pin\/)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
    'snapchat': RegExp(
      r'^((?:https?:)?\/\/)?((?:www|stories)\.)?((?:snapchat\.com))(\/(?:add|discover|story)\/)([\w\-\.]+)(\S+)?$',
      caseSensitive: false,
    ),
  };

  /// Validates if a URL is a valid video URL for the given platform
  static bool isValidUrl(String url, String platform) {
    // If platform is specifically provided, check against that pattern
    if (_platformPatterns.containsKey(platform.toLowerCase())) {
      return _platformPatterns[platform.toLowerCase()]!.hasMatch(url);
    }

    // For 'other' or unknown platforms, do general URL validation
    return Uri.tryParse(url)?.hasScheme ?? false;
  }

  /// Detects the platform from a given URL
  static String detectPlatform(String url) {
    for (var entry in _platformPatterns.entries) {
      if (entry.value.hasMatch(url)) {
        return entry.key;
      }
    }
    return 'other';
  }

  /// Extracts the video ID from a URL based on its platform
  static String? extractVideoId(String url) {
    String platform = detectPlatform(url);
    RegExp? pattern = _platformPatterns[platform];

    if (pattern == null) return null;

    var match = pattern.firstMatch(url);
    if (match != null && match.groupCount >= 6) {
      return match.group(6);
    }

    return null;
  }

  /// Returns a formatted URL that can be used for embedding
  static String? getEmbedUrl(String url) {
    String platform = detectPlatform(url);
    String? videoId = extractVideoId(url);

    if (videoId == null) return null;

    switch (platform) {
      case 'youtube':
        return 'https://www.youtube.com/embed/$videoId';
      case 'vimeo':
        return 'https://player.vimeo.com/video/$videoId';
      case 'facebook':
        return 'https://www.facebook.com/plugins/video.php?href=$url';
      default:
        return url;
    }
  }

  /// Returns an appropriate icon for the detected platform
  static IconData getIconForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'youtube':
        return Icons.play_circle_outline;
      case 'tiktok':
        return Icons.music_note;
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.chat;
      case 'vimeo':
        return Icons.video_library;
      case 'twitch':
        return Icons.videogame_asset;
      case 'linkedin':
        return Icons.work;
      case 'reddit':
        return Icons.forum;
      case 'pinterest':
        return Icons.push_pin;
      case 'snapchat':
        return Icons.camera;
      default:
        return Icons.link;
    }
  }

  /// Returns color associated with the platform
  static Color getColorForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'youtube':
        return Colors.red;
      case 'tiktok':
        return Colors.teal.shade400;
      case 'facebook':
        return Colors.blue.shade800;
      case 'instagram':
        return Colors.purple.shade400;
      case 'twitter':
        return Colors.blue.shade400;
      case 'vimeo':
        return Colors.blue.shade300;
      case 'twitch':
        return Colors.purple.shade800;
      case 'linkedin':
        return Colors.blue.shade900;
      case 'reddit':
        return Colors.orange.shade800;
      case 'pinterest':
        return Colors.red.shade800;
      case 'snapchat':
        return Colors.yellow.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
