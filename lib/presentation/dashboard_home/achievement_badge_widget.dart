import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color badgeColor;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const AchievementBadgeWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.badgeColor = const Color(0xFFF59E0B),
    this.isUnlocked = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isUnlocked
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isUnlocked
                ? badgeColor.withValues(alpha: 0.3)
                : AppTheme.borderSubtleLight,
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? badgeColor
                    : AppTheme.textSecondaryLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: badgeColor.withValues(alpha: 0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: CustomIconWidget(
                iconName: _getIconName(icon),
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? AppTheme.textPrimaryLight
                        : AppTheme.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isUnlocked
                        ? AppTheme.textSecondaryLight
                        : AppTheme.textSecondaryLight.withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData iconData) {
    // Map common achievement icons to their string names
    if (iconData == Icons.emoji_events) return 'emoji_events';
    if (iconData == Icons.star) return 'star';
    if (iconData == Icons.trending_up) return 'trending_up';
    if (iconData == Icons.flash_on) return 'flash_on';
    if (iconData == Icons.favorite) return 'favorite';
    if (iconData == Icons.school) return 'school';
    if (iconData == Icons.workspace_premium) return 'workspace_premium';
    return 'emoji_events'; // Default fallback
  }
}
