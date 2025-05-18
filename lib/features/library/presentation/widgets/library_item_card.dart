import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/video_thumbnail.dart';
import '../../domain/entities/library_item.dart';

/// Widget to display a library item
class LibraryItemCard extends StatelessWidget {
  final LibraryItem item;
  final VoidCallback? onTap;

  const LibraryItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.sm,
          horizontal: AppDimensions.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              width: 120,
              child: VideoThumbnail(
                thumbnailUrl: item.thumbnailUrl,
                height: 80,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXs),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeMd,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    item.channelName,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeSm,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    DateFormatter.formatRelativeTime(item.createdAt),
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeSm,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show options menu
              },
            ),
          ],
        ),
      ),
    );
  }
}
