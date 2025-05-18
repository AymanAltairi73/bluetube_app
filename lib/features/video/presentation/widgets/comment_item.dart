import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/comment.dart';

/// Widget to display a comment item
class CommentItem extends StatelessWidget {
  final Comment comment;
  final Function(String) onLike;
  final Function(String) onReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onLike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(comment.userAvatar),
          ),
          SizedBox(width: 12.w),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and time
                _buildUserInfoRow(),
                SizedBox(height: 4.h),

                // Comment text
                Text(
                  comment.text,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),

                // Actions (like, reply)
                _buildActionsRow(),
              ],
            ),
          ),

          // Options menu
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 16.r,
              color: Colors.grey[600],
            ),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow() {
    return Row(
      children: [
        Text(
          comment.userName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          DateFormatter.formatRelativeTime(comment.createdAt),
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        if (comment.isPinned) ...[
          SizedBox(width: 8.w),
          Icon(
            Icons.push_pin,
            size: 14.r,
            color: Colors.grey[600],
          ),
          SizedBox(width: 4.w),
          Text(
            'Pinned',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (comment.isOwner) ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'Author',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,  // Use minimum space needed
      children: [
        // Like button
        InkWell(
          onTap: () => onLike(comment.id),
          child: Row(
            mainAxisSize: MainAxisSize.min,  // Use minimum space needed
            children: [
              Icon(
                comment.isLiked
                    ? Icons.thumb_up
                    : Icons.thumb_up_outlined,
                size: 16.r,
                color: comment.isLiked ? Colors.blue : Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                NumberFormatter.formatCompact(comment.likes),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: comment.isLiked ? Colors.blue : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),

        // Reply button
        InkWell(
          onTap: () => onReply(comment.id),
          child: Row(
            mainAxisSize: MainAxisSize.min,  // Use minimum space needed
            children: [
              Icon(
                Icons.reply,
                size: 16.r,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                'Reply',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        if (comment.replies > 0) ...[
          SizedBox(width: 16.w),

          // View replies button - Wrap with Flexible to handle overflow
          Flexible(
            child: InkWell(
              onTap: () {
                // Show replies
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,  // Use minimum space needed
                children: [
                  Icon(
                    Icons.expand_more,
                    size: 16.r,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      'View ${comment.replies} ${comment.replies == 1 ? 'reply' : 'replies'}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,  // Add ellipsis if text overflows
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
