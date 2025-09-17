import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayFocusWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final VoidCallback? onViewAll;

  const TodayFocusWidget({
    super.key,
    required this.tasks,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowMediumLight,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Focus',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          ...tasks
              .take(3)
              .map((task) => _buildTaskItem(context, task))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    final title = task['title'] as String? ?? '';
    final description = task['description'] as String? ?? '';
    final igPoints = task['igPoints'] as int? ?? 0;
    final difficulty = task['difficulty'] as String? ?? 'Easy';
    final isCompleted = task['isCompleted'] as bool? ?? false;
    final estimatedTime = task['estimatedTime'] as String? ?? '30 min';

    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'hard':
        difficultyColor = AppTheme.warningLight;
        break;
      case 'medium':
        difficultyColor = AppTheme.accentLight;
        break;
      default:
        difficultyColor = AppTheme.secondaryLight;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.secondaryLight.withValues(alpha: 0.1)
            : AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: isCompleted
              ? AppTheme.secondaryLight.withValues(alpha: 0.3)
              : AppTheme.borderSubtleLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Completion checkbox
          GestureDetector(
            onTap: () {
              // Handle task completion toggle
            },
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color:
                    isCompleted ? AppTheme.secondaryLight : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.secondaryLight
                      : AppTheme.borderSubtleLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: isCompleted
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 4.w,
                    )
                  : null,
            ),
          ),

          SizedBox(width: 3.w),

          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? AppTheme.textSecondaryLight
                                  : AppTheme.textPrimaryLight,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: difficultyColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        difficulty,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: difficultyColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.textSecondaryLight,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      estimatedTime,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'stars',
                      color: AppTheme.accentLight,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '+$igPoints IG',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.accentLight,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
