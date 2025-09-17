import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetDate;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CountdownTimerWidget({
    super.key,
    required this.targetDate,
    this.textStyle,
    this.backgroundColor,
    this.padding,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _updateTimeRemaining();
    _pulseController.repeat(reverse: true);
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    final difference = widget.targetDate.difference(now);

    setState(() {
      _timeRemaining = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: widget.padding ??
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  (brightness == Brightness.light
                      ? AppTheme.accentLight.withValues(alpha: 0.1)
                      : AppTheme.accentDark.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: brightness == Brightness.light
                    ? AppTheme.accentLight
                    : AppTheme.accentDark,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  color: brightness == Brightness.light
                      ? AppTheme.accentLight
                      : AppTheme.accentDark,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(_timeRemaining),
                  style: widget.textStyle ??
                      theme.textTheme.labelMedium?.copyWith(
                        color: brightness == Brightness.light
                            ? AppTheme.accentLight
                            : AppTheme.accentDark,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
