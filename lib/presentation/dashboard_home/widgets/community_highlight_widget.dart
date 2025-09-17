import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunityHighlightWidget extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String content;
  final String timeAgo;
  final int likes;
  final int comments;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onTap;

  const CommunityHighlightWidget({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.onLike,
    this.onComment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: AppTheme.borderSubtleLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 5.w,
                  backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
                  child: userAvatar.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: userAvatar,
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        )
                      : CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryLight,
                            ),
                      ),
                      Text(
                        timeAgo,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Content
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    height: 1.4,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2.h),

            // Actions
            Row(
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: isLiked ? 'favorite' : 'favorite_border',
                        color: isLiked
                            ? AppTheme.warningLight
                            : AppTheme.textSecondaryLight,
                        size: 20,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        likes.toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isLiked
                                  ? AppTheme.warningLight
                                  : AppTheme.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: onComment,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'chat_bubble_outline',
                        color: AppTheme.textSecondaryLight,
                        size: 20,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        comments.toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
