import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final VoidCallback? onViewAll;

  const ActivityHistoryWidget({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final recentActivities = activities.take(5).toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.getTextColor(context),
                    ),
              ),
              if (activities.length > 5)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.getPrimaryColor(context),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          recentActivities.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentActivities.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final activity = recentActivities[index];
                    return _buildActivityItem(context, activity);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.getTextColor(context, secondary: true)
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'history',
            size: 12.w,
            color: AppTheme.getTextColor(context, secondary: true),
          ),
          SizedBox(height: 2.h),
          Text(
            'No activity yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your learning journey to see your progress here!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      BuildContext context, Map<String, dynamic> activity) {
    final String type = activity['type'] as String? ?? 'activity';
    final String title = activity['title'] as String? ?? 'Activity';
    final String description = activity['description'] as String? ?? '';
    final DateTime timestamp =
        activity['timestamp'] as DateTime? ?? DateTime.now();
    final int? igPoints = activity['igPoints'] as int?;
    final String? skillCategory = activity['skillCategory'] as String?;

    final activityIcon = _getActivityIcon(type);
    final activityColor = _getActivityColor(context, type);
    final timeAgo = _getTimeAgo(timestamp);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: activityColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Activity icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: activityColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: activityIcon,
              size: 6.w,
              color: activityColor,
            ),
          ),
          SizedBox(width: 3.w),

          // Activity details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getTextColor(context),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.getTextColor(context, secondary: true),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                          ),
                    ),
                    if (skillCategory != null) ...[
                      Text(
                        ' • ',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.getTextColor(context,
                                  secondary: true),
                            ),
                      ),
                      Text(
                        skillCategory,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.getPrimaryColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // IG Points earned
          if (igPoints != null && igPoints > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.getAccentColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$igPoints IG',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.getAccentColor(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'milestone':
        return 'flag';
      case 'achievement':
        return 'emoji_events';
      case 'skill_progress':
        return 'trending_up';
      case 'course_completion':
        return 'school';
      case 'mentor_session':
        return 'people';
      case 'community_post':
        return 'forum';
      case 'challenge_completed':
        return 'check_circle';
      default:
        return 'activity';
    }
  }

  Color _getActivityColor(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'milestone':
        return AppTheme.getAccentColor(context);
      case 'achievement':
        return const Color(0xFFFF6B35); // Orange
      case 'skill_progress':
        return AppTheme.getSecondaryColor(context);
      case 'course_completion':
        return AppTheme.getPrimaryColor(context);
      case 'mentor_session':
        return const Color(0xFF8B5CF6); // Purple
      case 'community_post':
        return const Color(0xFF10B981); // Green
      case 'challenge_completed':
        return AppTheme.getSecondaryColor(context);
      default:
        return AppTheme.getTextColor(context, secondary: true);
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
