import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilestoneBadgeWidget extends StatefulWidget {
  final Map<String, dynamic> milestone;
  final VoidCallback? onTap;
  final VoidCallback? onShare;

  const MilestoneBadgeWidget({
    super.key,
    required this.milestone,
    this.onTap,
    this.onShare,
  });

  @override
  State<MilestoneBadgeWidget> createState() => _MilestoneBadgeWidgetState();
}

class _MilestoneBadgeWidgetState extends State<MilestoneBadgeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final title = widget.milestone['title'] as String? ?? '';
    final description = widget.milestone['description'] as String? ?? '';
    final iconName = widget.milestone['icon'] as String? ?? 'emoji_events';
    final isEarned = widget.milestone['isEarned'] as bool? ?? false;
    final earnedDate = widget.milestone['earnedDate'] as DateTime?;
    final rarity = widget.milestone['rarity'] as String? ?? 'common';

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () => _showMilestoneDetails(context),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: 25.w,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: brightness == Brightness.light
                      ? AppTheme.surfaceLight
                      : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getRarityColor(rarity),
                    width: 2,
                  ),
                  boxShadow: isEarned
                      ? [
                          BoxShadow(
                            color:
                                _getRarityColor(rarity).withValues(alpha: 0.3),
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
                    // Badge icon with glow effect
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: isEarned
                            ? _getRarityColor(rarity).withValues(alpha: 0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isEarned
                            ? null
                            : Border.all(
                                color: brightness == Brightness.light
                                    ? AppTheme.borderSubtleLight
                                    : AppTheme.borderSubtleDark,
                                width: 1,
                              ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: isEarned
                              ? _getRarityColor(rarity)
                              : AppTheme.getTextColor(context, secondary: true),
                          size: 8.w,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Badge title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isEarned
                                ? AppTheme.getTextColor(context)
                                : AppTheme.getTextColor(context,
                                    secondary: true),
                            fontWeight:
                                isEarned ? FontWeight.w600 : FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (isEarned && earnedDate != null) ...[
                      SizedBox(height: 1.h),
                      Text(
                        _formatEarnedDate(earnedDate),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getRarityColor(rarity),
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    // Rarity indicator
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getRarityColor(rarity).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rarity.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getRarityColor(rarity),
                              fontWeight: FontWeight.w600,
                              fontSize: 8.sp,
                            ),
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

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'legendary':
        return const Color(0xFFFFD700); // Gold
      case 'epic':
        return const Color(0xFF9C27B0); // Purple
      case 'rare':
        return const Color(0xFF2196F3); // Blue
      case 'uncommon':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF757575); // Gray
    }
  }

  String _formatEarnedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 30) {
      return '$difference days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  void _showMilestoneDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: widget.milestone['icon'] as String? ?? 'emoji_events',
              color: _getRarityColor(
                  widget.milestone['rarity'] as String? ?? 'common'),
              size: 24,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                widget.milestone['title'] as String? ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.milestone['description'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            if (widget.milestone['isEarned'] as bool? ?? false) ...[
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.getSecondaryColor(context),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Earned on ${_formatEarnedDate(widget.milestone['earnedDate'] as DateTime? ?? DateTime.now())}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSecondaryColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ],
        ),
        actions: [
          if (widget.milestone['isEarned'] as bool? ?? false)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onShare?.call();
              },
              icon: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.getPrimaryColor(context),
                size: 16,
              ),
              label: Text('Share'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
