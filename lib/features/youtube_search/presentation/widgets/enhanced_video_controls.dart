import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Widget for enhanced video playback controls
class EnhancedVideoControls extends StatefulWidget {
  final YoutubePlayerController controller;
  final Function()? onTogglePictureInPicture;

  const EnhancedVideoControls({
    super.key,
    required this.controller,
    this.onTogglePictureInPicture,
  });

  @override
  State<EnhancedVideoControls> createState() => _EnhancedVideoControlsState();
}

class _EnhancedVideoControlsState extends State<EnhancedVideoControls> {
  final RxBool _isSettingsOpen = false.obs;
  final RxDouble _playbackSpeed = 1.0.obs;
  final RxString _selectedQuality = 'auto'.obs;
  final RxBool _captionsEnabled = false.obs;

  final List<double> _playbackSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  final List<String> _qualities = ['auto', '144p', '240p', '360p', '480p', '720p', '1080p'];

  @override
  void initState() {
    super.initState();
    // Initialize with current controller values
    _playbackSpeed.value = widget.controller.value.playbackRate;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _isSettingsOpen.value
        ? _buildSettingsPanel()
        : _buildControlsButton());
  }

  Widget _buildControlsButton() {
    return IconButton(
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
      onPressed: () => _isSettingsOpen.value = true,
      tooltip: 'Playback Settings',
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      width: double.infinity,
      color: Colors.black87,
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => _isSettingsOpen.value = false,
              ),
              const Expanded(
                child: Text(
                  'Playback Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white30),
          _buildSettingsItem(
            title: 'Playback Speed',
            value: '${_playbackSpeed.value}x',
            onTap: _showPlaybackSpeedOptions,
          ),
          _buildSettingsItem(
            title: 'Quality',
            value: _selectedQuality.value,
            onTap: _showQualityOptions,
          ),
          _buildSettingsItem(
            title: 'Captions',
            value: _captionsEnabled.value ? 'On' : 'Off',
            onTap: _toggleCaptions,
          ),
          if (widget.onTogglePictureInPicture != null)
            _buildSettingsItem(
              title: 'Picture-in-Picture',
              value: '',
              trailing: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
              onTap: () {
                _isSettingsOpen.value = false;
                // Add a small delay to allow the settings panel to close
                Future.delayed(const Duration(milliseconds: 300), () {
                  widget.onTogglePictureInPicture!();
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String value,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: trailing ??
          Text(
            value,
            style: const TextStyle(color: Colors.white70),
          ),
      onTap: onTap,
    );
  }

  void _showPlaybackSpeedOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: _playbackSpeeds.map((speed) {
          return ListTile(
            title: Text(
              '${speed}x',
              style: TextStyle(
                color: Colors.white,
                fontWeight: _playbackSpeed.value == speed
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: _playbackSpeed.value == speed
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              widget.controller.setPlaybackRate(speed);
              _playbackSpeed.value = speed;
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showQualityOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: _qualities.map((quality) {
          return ListTile(
            title: Text(
              quality,
              style: TextStyle(
                color: Colors.white,
                fontWeight: _selectedQuality.value == quality
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: _selectedQuality.value == quality
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              // YouTube Player Flutter doesn't directly support quality selection
              // This would require custom implementation with the YouTube API
              _selectedQuality.value = quality;
              Navigator.pop(context);

              // Show a message that this is a mock implementation
              Get.snackbar(
                'Quality Selection',
                'Changed quality to $quality (mock implementation)',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black54,
                colorText: Colors.white,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void _toggleCaptions() {
    _captionsEnabled.value = !_captionsEnabled.value;

    // YouTube Player Flutter doesn't directly support captions control
    // This would require custom implementation with the YouTube API
    Get.snackbar(
      'Captions',
      'Captions ${_captionsEnabled.value ? 'enabled' : 'disabled'} (mock implementation)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }
}
