import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/channel.dart';

/// Widget to display a row of channel avatars
class ChannelAvatarRow extends StatelessWidget {
  final List<Channel> channels;
  final Function(Channel) onChannelTap;

  const ChannelAvatarRow({
    super.key,
    required this.channels,
    required this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: channels.length,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemBuilder: (context, index) {
          final channel = channels[index];
          return _buildChannelAvatar(channel);
        },
      ),
    );
  }

  Widget _buildChannelAvatar(Channel channel) {
    return GestureDetector(
      onTap: () => onChannelTap(channel),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            // Avatar with new content indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: AssetImage(channel.image),
                ),
                if (channel.hasNewContent)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),

            // Channel name
            Text(
              channel.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
