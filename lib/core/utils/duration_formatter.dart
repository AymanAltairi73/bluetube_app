/// Utility class for formatting durations
class DurationFormatter {
  /// Format an ISO 8601 duration string (e.g., PT1H2M3S) to a readable format (e.g., 1:02:03)
  static String formatIsoDuration(String? isoDuration) {
    if (isoDuration == null || isoDuration.isEmpty) {
      return '';
    }
    
    // Parse ISO 8601 duration format (e.g., PT1H2M3S)
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(isoDuration);
    
    if (match == null) {
      return '';
    }
    
    final hours = match.group(1) != null ? int.parse(match.group(1)!) : 0;
    final minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    final seconds = match.group(3) != null ? int.parse(match.group(3)!) : 0;
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// Format a Duration object to a readable string (e.g., 1:02:03)
  static String formatDuration(Duration? duration) {
    if (duration == null) {
      return '';
    }
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// Format seconds to a readable string (e.g., 1:02:03)
  static String formatSeconds(int? seconds) {
    if (seconds == null) {
      return '';
    }
    
    return formatDuration(Duration(seconds: seconds));
  }
}
