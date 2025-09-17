import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BatteryProgressWidget extends StatefulWidget {
  final String skillName;
  final double progressPercentage;
  final Color batteryColor;
  final double width;
  final double height;

  const BatteryProgressWidget({
    super.key,
    required this.skillName,
    required this.progressPercentage,
    this.batteryColor = const Color(0xFF10B981),
    this.width = 120,
    this.height = 60,
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
      end: widget.progressPercentage / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
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
          Text(
            widget.skillName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: BatteryPainter(
                      progress: _progressAnimation.value,
                      batteryColor: widget.batteryColor,
                    ),
                  );
                },
              ),
              SizedBox(width: 4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.progressPercentage.toInt()}%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: widget.batteryColor,
                        ),
                  ),
                  Text(
                    'Complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BatteryPainter extends CustomPainter {
  final double progress;
  final Color batteryColor;

  BatteryPainter({
    required this.progress,
    required this.batteryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Battery outline
    final batteryRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * 0.2, size.width * 0.85, size.height * 0.6),
      Radius.circular(size.height * 0.1),
    );

    // Battery tip
    final tipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.85,
        size.height * 0.35,
        size.width * 0.15,
        size.height * 0.3,
      ),
      Radius.circular(size.height * 0.05),
    );

    // Draw battery outline
    paint.color = AppTheme.borderSubtleLight;
    canvas.drawRRect(batteryRect, paint);
    canvas.drawRRect(tipRect, paint);

    // Draw battery fill
    if (progress > 0) {
      final fillWidth = (size.width * 0.85 - 8) * progress;
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            4, size.height * 0.2 + 4, fillWidth, size.height * 0.6 - 8),
        Radius.circular(size.height * 0.08),
      );

      // Gradient fill based on progress
      Color fillColor;
      if (progress < 0.3) {
        fillColor = const Color(0xFFDC2626); // Red for low progress
      } else if (progress < 0.7) {
        fillColor = const Color(0xFFF59E0B); // Amber for medium progress
      } else {
        fillColor = batteryColor; // Green for high progress
      }

      paint.color = fillColor;
      canvas.drawRRect(fillRect, paint);

      // Add shine effect
      final shineGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          fillColor.withValues(alpha: 0.8),
          fillColor.withValues(alpha: 0.4),
        ],
      );

      paint.shader = shineGradient.createShader(fillRect.outerRect);
      canvas.drawRRect(fillRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BatteryPainter && oldDelegate.progress != progress;
  }
}
