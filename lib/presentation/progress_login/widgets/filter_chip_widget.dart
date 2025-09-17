import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final int? count;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.icon,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.getPrimaryColor(context)
              : (brightness == Brightness.light
                  ? AppTheme.surfaceLight
                  : AppTheme.surfaceDark),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.getPrimaryColor(context)
                : (brightness == Brightness.light
                    ? AppTheme.borderSubtleLight
                    : AppTheme.borderSubtleDark),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.getPrimaryColor(context)
                        .withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              CustomIconWidget(
                iconName: _getIconName(icon!),
                color: isSelected
                    ? Colors.white
                    : AppTheme.getTextColor(context, secondary: true),
                size: 16,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.getTextColor(context),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
            if (count != null && count! > 0) ...[
              SizedBox(width: 1.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppTheme.getPrimaryColor(context)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.getPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData iconData) {
    // Map common IconData to string names for CustomIconWidget
    if (iconData == Icons.calendar_today) return 'calendar_today';
    if (iconData == Icons.category) return 'category';
    if (iconData == Icons.emoji_events) return 'emoji_events';
    if (iconData == Icons.trending_up) return 'trending_up';
    if (iconData == Icons.photo_camera) return 'photo_camera';
    if (iconData == Icons.videocam) return 'videocam';
    if (iconData == Icons.description) return 'description';
    return 'filter_list';
  }
}
