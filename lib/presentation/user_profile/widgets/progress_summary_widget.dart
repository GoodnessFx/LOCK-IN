import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> progressData;
  final DateTime startDate;
  final DateTime targetDate;

  const ProgressSummaryWidget({
    super.key,
    required this.progressData,
    required this.startDate,
    required this.targetDate,
  });

  @override
  Widget build(BuildContext context) {
    final daysTotal = targetDate.difference(startDate).inDays;
    final daysRemaining = targetDate.difference(DateTime.now()).inDays;
    final daysCompleted = daysTotal - daysRemaining;
    final overallProgress = daysCompleted / daysTotal;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '6-Month Journey',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.getTextColor(context),
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: daysRemaining > 0
                      ? AppTheme.getPrimaryColor(context).withValues(alpha: 0.1)
                      : AppTheme.getSecondaryColor(context)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysRemaining > 0 ? '$daysRemaining days left' : 'Completed!',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: daysRemaining > 0
                            ? AppTheme.getPrimaryColor(context)
                            : AppTheme.getSecondaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Overall progress battery
          _buildBatteryProgress(
            context,
            'Overall Progress',
            overallProgress,
            AppTheme.getPrimaryColor(context),
          ),
          SizedBox(height: 2.h),

          // Individual skill progress
          ...((progressData['skills'] as List<Map<String, dynamic>>?) ?? [])
              .map((skill) => Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: _buildBatteryProgress(
                      context,
                      skill['name'] as String? ?? 'Skill',
                      (skill['progress'] as double?) ?? 0.0,
                      _getSkillColor(
                          context, skill['category'] as String? ?? 'general'),
                    ),
                  )),

          // Timeline visualization
          SizedBox(height: 2.h),
          _buildTimelineVisualization(context, daysCompleted, daysTotal),
        ],
      ),
    );
  }

  Widget _buildBatteryProgress(
      BuildContext context, String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextColor(context),
                  ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),

        // Battery-style progress indicator
        Container(
          height: 3.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

              // Progress fill with animation
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.8),
                        color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              // Battery tip
              Positioned(
                right: -1,
                top: 0.8.h,
                child: Container(
                  width: 1.w,
                  height: 0.4.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.6),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineVisualization(
      BuildContext context, int daysCompleted, int daysTotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Journey Timeline',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextColor(context),
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 6.h,
          child: Row(
            children: List.generate(6, (monthIndex) {
              final monthProgress =
                  (daysCompleted / daysTotal * 6) - monthIndex;
              final isCompleted = monthProgress >= 1.0;
              final isInProgress = monthProgress > 0 && monthProgress < 1.0;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: monthIndex < 5 ? 1.w : 0),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.getSecondaryColor(context)
                        : isInProgress
                            ? AppTheme.getPrimaryColor(context)
                                .withValues(alpha: 0.6)
                            : AppTheme.getTextColor(context, secondary: true)
                                .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'M${monthIndex + 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isCompleted || isInProgress
                                  ? Colors.white
                                  : AppTheme.getTextColor(context,
                                      secondary: true),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (isInProgress) ...[
                        SizedBox(height: 0.5.h),
                        Container(
                          width: 8.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: monthProgress.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Color _getSkillColor(BuildContext context, String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return const Color(0xFF3B82F6); // Blue
      case 'design':
        return const Color(0xFF8B5CF6); // Purple
      case 'business':
        return const Color(0xFF10B981); // Green
      case 'creative':
        return const Color(0xFFF59E0B); // Amber
      case 'fitness':
        return const Color(0xFFEF4444); // Red
      default:
        return AppTheme.getPrimaryColor(context);
    }
  }
}
