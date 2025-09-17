import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Custom AppBar widget implementing Contemporary Gamified Minimalism
/// Provides clean, purposeful interface with contextual actions
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = AppBarVariant.primary,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Determine colors based on variant and theme
    Color appBarBackground;
    Color appBarForeground;
    SystemUiOverlayStyle overlayStyle;

    switch (variant) {
      case AppBarVariant.primary:
        appBarBackground = backgroundColor ??
            (brightness == Brightness.light
                ? AppTheme.surfaceLight
                : AppTheme.surfaceDark);
        appBarForeground = foregroundColor ??
            (brightness == Brightness.light
                ? AppTheme.textPrimaryLight
                : AppTheme.textPrimaryDark);
        overlayStyle = brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light;
        break;
      case AppBarVariant.transparent:
        appBarBackground = Colors.transparent;
        appBarForeground = foregroundColor ??
            (brightness == Brightness.light
                ? AppTheme.textPrimaryLight
                : AppTheme.textPrimaryDark);
        overlayStyle = brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light;
        break;
      case AppBarVariant.accent:
        appBarBackground = backgroundColor ?? AppTheme.getPrimaryColor(context);
        appBarForeground = foregroundColor ?? Colors.white;
        overlayStyle = SystemUiOverlayStyle.light;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: appBarForeground,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
      ),
      backgroundColor: appBarBackground,
      foregroundColor: appBarForeground,
      elevation: elevation ?? (variant == AppBarVariant.transparent ? 0 : 0),
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      systemOverlayStyle: overlayStyle,
      leading: _buildLeading(context, appBarForeground),
      actions: _buildActions(context, appBarForeground),
      bottom: bottom,
      automaticallyImplyLeading: false,
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: foregroundColor,
          size: 20,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
        splashRadius: 20,
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: action.onPressed,
          color: foregroundColor,
          tooltip: action.tooltip,
          splashRadius: 20,
        );
      }
      return action;
    }).toList();
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// AppBar variants for different contexts
enum AppBarVariant {
  /// Standard app bar with surface background
  primary,

  /// Transparent background for overlay contexts
  transparent,

  /// Accent color background for emphasis
  accent,
}

/// Specialized AppBar for dashboard/home screens
class CustomDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? avatar;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  const CustomDashboardAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.avatar,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return AppBar(
      backgroundColor: brightness == Brightness.light
          ? AppTheme.surfaceLight
          : AppTheme.surfaceDark,
      foregroundColor: brightness == Brightness.light
          ? AppTheme.textPrimaryLight
          : AppTheme.textPrimaryDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.02,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getTextColor(context, secondary: true),
              ),
            ),
        ],
      ),
      actions: [
        // Notification button
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 24),
              onPressed: onNotificationTap,
              tooltip: 'Notifications',
              splashRadius: 20,
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 99
                        ? '99+'
                        : notificationCount.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
        // Profile avatar
        GestureDetector(
          onTap: onProfileTap ??
              () => Navigator.pushNamed(context, '/user-profile'),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: avatar ??
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      AppTheme.getPrimaryColor(context).withAlpha(26),
                  child: Icon(
                    Icons.person_outline,
                    size: 20,
                    color: AppTheme.getPrimaryColor(context),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Search AppBar for discovery screens
class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final TextEditingController? controller;
  final bool autofocus;

  const CustomSearchAppBar({
    super.key,
    this.hintText = 'Search...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.controller,
    this.autofocus = false,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return AppBar(
      backgroundColor: brightness == Brightness.light
          ? AppTheme.surfaceLight
          : AppTheme.surfaceDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: brightness == Brightness.light
              ? AppTheme.textPrimaryLight
              : AppTheme.textPrimaryDark,
        ),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
        splashRadius: 20,
      ),
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onSearchChanged,
        onSubmitted: (_) => widget.onSearchSubmitted?.call(),
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.getTextColor(context, secondary: true),
          ),
        ),
      ),
      actions: [
        if (_controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear_rounded, size: 20),
            onPressed: () {
              _controller.clear();
              widget.onSearchChanged?.call('');
            },
            tooltip: 'Clear',
            splashRadius: 20,
          ),
        IconButton(
          icon: const Icon(Icons.search_rounded, size: 24),
          onPressed: widget.onSearchSubmitted,
          tooltip: 'Search',
          splashRadius: 20,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
