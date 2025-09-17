import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BatteryProgressWidget extends StatefulWidget {
  final double progress;
  final String skillName;
  final int igPoints;
  final bool isAnimated;
-
  const BatteryProgressWidget({
    super.key,
    required this.progress,
    required this.skillName,
    required this.igPoints,
    this.isAnimated = true,
  });

  @override
  State<BatteryProgressWidget> createState() => _BatteryProgressWidgetState();
}

class _BatteryProgressWidgetState extends State<BatteryProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isAnimated) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: brightness == Brightness.light
                ? AppTheme.shadowMediumLight
                : AppTheme.shadowMediumDark,
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
              Expanded(
                child: Text(
                  widget.skillName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getTextColor(context),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getSecondaryColor(context)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'bolt',
                      color: AppTheme.getSecondaryColor(context),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${widget.igPoints} IG',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.getSecondaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Battery Progress Indicator
          widget.isAnimated
              ? AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return _buildBatteryIndicator(
                        context, _progressAnimation.value);
                  },
                )
              : _buildBatteryIndicator(context, widget.progress),

          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(widget.progress * 100).toInt()}% Complete',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getTextColor(context, secondary: true),
                    ),
              ),
              Text(
                '6 months remaining',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextColor(context, secondary: true),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIndicator(BuildContext context, double progress) {
    final brightness = Theme.of(context).brightness;

    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: brightness == Brightness.light
              ? AppTheme.borderSubtleLight
              : AppTheme.borderSubtleDark,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Battery background
          Container(
            decoration: BoxDecoration(
              color: brightness == Brightness.light
                  ? AppTheme.borderSubtleLight.withValues(alpha: 0.3)
                  : AppTheme.borderSubtleDark.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          // Battery fill with gradient
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.getSecondaryColor(context),
                    AppTheme.getPrimaryColor(context),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          // Battery tip
          Positioned(
            right: -6,
            top: 25,
            child: Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: brightness == Brightness.light
                    ? AppTheme.borderSubtleLight
                    : AppTheme.borderSubtleDark,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
