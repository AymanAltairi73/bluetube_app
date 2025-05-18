import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/short.dart';

/// Widget to display actions for a short video (like, comment, share, etc.)
class ShortActions extends StatelessWidget {
  final Short short;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSubscribe;

  const ShortActions({
    super.key,
    required this.short,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Like button
          _buildActionButton(
            icon: Icons.thumb_up,
            label: NumberFormatter.formatCompact(short.likes),
            onTap: onLike,
          ),
          SizedBox(height: 20.h),
          
          // Comment button
          _buildActionButton(
            icon: Icons.comment,
            label: NumberFormatter.formatCompact(short.comments),
            onTap: onComment,
          ),
          SizedBox(height: 20.h),
          
          // Share button
          _buildActionButton(
            icon: Icons.reply,
            label: NumberFormatter.formatCompact(short.shares),
            onTap: onShare,
          ),
          SizedBox(height: 20.h),
          
          // Subscribe button
          _buildSubscribeButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30.r,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return GestureDetector(
      onTap: onSubscribe,
      child: Column(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
              image: DecorationImage(
                image: AssetImage(short.authorAvatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: short.isSubscribed ? Colors.grey : Colors.red,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              short.isSubscribed ? 'SUBSCRIBED' : 'SUBSCRIBE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
