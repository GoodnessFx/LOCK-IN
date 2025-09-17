import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BatteryProgressIndicator extends StatefulWidget {
  final double progress;
  final Color? batteryColor;
  final Color? backgroundColor;
  final double width;
  final double height;

  const BatteryProgressIndicator({
    super.key,
    required this.progress,
    this.batteryColor,
    this.backgroundColor,
    this.width = 80,
    this.height = 40,
  });

  @override
  State<BatteryProgressIndicator> createState() =>
      _BatteryProgressIndicatorState();
}

class _BatteryProgressIndicatorState extends State<BatteryProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(BatteryProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final batteryColor = widget.batteryColor ??
        (brightness == Brightness.light
            ? AppTheme.secondaryLight
            : AppTheme.secondaryDark);
    final backgroundColor = widget.backgroundColor ??
        (brightness == Brightness.light
            ? AppTheme.borderSubtleLight
            : AppTheme.borderSubtleDark);

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: BatteryPainter(
            progress: _progressAnimation.value,
            batteryColor: batteryColor,
            backgroundColor: backgroundColor,
          ),
        );
      },
    );
  }
}

class BatteryPainter extends CustomPainter {
  final double progress;
  final Color batteryColor;
  final Color backgroundColor;

  BatteryPainter({
    required this.progress,
    required this.batteryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Battery body dimensions
    final bodyWidth = size.width * 0.85;
    final bodyHeight = size.height * 0.8;
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, (size.height - bodyHeight) / 2, bodyWidth, bodyHeight),
      const Radius.circular(4),
    );

    // Battery tip dimensions
    final tipWidth = size.width * 0.08;
    final tipHeight = size.height * 0.4;
    final tipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        bodyWidth + 2,
        (size.height - tipHeight) / 2,
        tipWidth,
        tipHeight,
      ),
      const Radius.circular(2),
    );

    // Draw battery outline
    paint.color = backgroundColor;
    canvas.drawRRect(bodyRect, paint);
    canvas.drawRRect(tipRect, paint);

    // Draw battery border
    paint.style = PaintingStyle.stroke;
    paint.color = batteryColor.withValues(alpha: 0.3);
    canvas.drawRRect(bodyRect, paint);
    canvas.drawRRect(tipRect, paint);

    // Draw battery fill
    if (progress > 0) {
      paint.style = PaintingStyle.fill;

      // Determine fill color based on progress
      Color fillColor;
      if (progress < 0.2) {
        fillColor = AppTheme.warningLight;
      } else if (progress < 0.5) {
        fillColor = AppTheme.accentLight;
      } else {
        fillColor = batteryColor;
      }

      paint.color = fillColor;

      final fillWidth = (bodyWidth - 8) * progress;
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          4,
          (size.height - bodyHeight) / 2 + 4,
          fillWidth,
          bodyHeight - 8,
        ),
        const Radius.circular(2),
      );

      canvas.drawRRect(fillRect, paint);

      // Add shine effect
      if (progress > 0.1) {
        paint.color = fillColor.withValues(alpha: 0.3);
        final shineRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            4,
            (size.height - bodyHeight) / 2 + 4,
            fillWidth * 0.3,
            bodyHeight - 8,
          ),
          const Radius.circular(2),
        );
        canvas.drawRRect(shineRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BatteryPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.batteryColor != batteryColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
