import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContentFilterChips extends StatefulWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String>? onFilterChanged;

  const ContentFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    this.onFilterChanged,
  });

  @override
  State<ContentFilterChips> createState() => _ContentFilterChipsState();
}

class _ContentFilterChipsState extends State<ContentFilterChips> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          final filter = widget.filters[index];
          final isSelected = filter == widget.selectedFilter;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: GestureDetector(
              onTap: () => widget.onFilterChanged?.call(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                                .withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getFilterIcon(filter),
                      color: isSelected
                          ? Colors.white
                          : AppTheme.getTextColor(context, secondary: true),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      filter,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.getTextColor(context),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFilterIcon(String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        return 'apps';
      case 'progress':
        return 'trending_up';
      case 'milestones':
        return 'emoji_events';
      case 'mentors':
        return 'school';
      case 'discussions':
        return 'chat_bubble_outline';
      case 'achievements':
        return 'star';
      default:
        return 'category';
    }
  }
}
