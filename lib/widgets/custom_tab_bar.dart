import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom Tab Bar implementing Contemporary Gamified Minimalism
/// Provides contextual navigation with progress visualization
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<CustomTab> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final TabBarVariant variant;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final double? indicatorWeight;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.variant = TabBarVariant.standard,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.indicatorWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    switch (variant) {
      case TabBarVariant.standard:
        return _buildStandardTabBar(context, brightness);
      case TabBarVariant.pills:
        return _buildPillTabBar(context, brightness);
      case TabBarVariant.segmented:
        return _buildSegmentedTabBar(context, brightness);
      case TabBarVariant.progress:
        return _buildProgressTabBar(context, brightness);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, Brightness brightness) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textPrimaryLight
        : AppTheme.textPrimaryDark;
    final secondaryTextColor = brightness == Brightness.light
        ? AppTheme.textSecondaryLight
        : AppTheme.textSecondaryDark;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: brightness == Brightness.light
                ? AppTheme.borderSubtleLight
                : AppTheme.borderSubtleDark,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        labelColor: primaryColor,
        unselectedLabelColor: secondaryTextColor,
        indicatorColor: indicatorColor ?? primaryColor,
        indicatorWeight: indicatorWeight ?? 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
        tabs: tabs
            .map((tab) => Tab(
                  text: tab.label,
                  icon: tab.icon != null ? Icon(tab.icon, size: 20) : null,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPillTabBar(BuildContext context, Brightness brightness) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = controller?.index == index;

            return _buildPillTab(context, tab, isSelected, index, brightness);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, Brightness brightness) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final backgroundColor = brightness == Brightness.light
        ? AppTheme.borderSubtleLight
        : AppTheme.borderSubtleDark;

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = controller?.index == index;

            return Expanded(
              child: _buildSegmentedTab(
                  context, tab, isSelected, index, brightness),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProgressTabBar(BuildContext context, Brightness brightness) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(context, brightness),
          const SizedBox(height: 16),
          // Tab content
          Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = controller?.index == index;
              final isCompleted = (controller?.index ?? 0) > index;

              return Expanded(
                child: _buildProgressTab(
                  context,
                  tab,
                  isSelected,
                  isCompleted,
                  index,
                  brightness,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab(
    BuildContext context,
    CustomTab tab,
    bool isSelected,
    int index,
    Brightness brightness,
  ) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textPrimaryLight
        : AppTheme.textPrimaryDark;
    final secondaryTextColor = brightness == Brightness.light
        ? AppTheme.textSecondaryLight
        : AppTheme.textSecondaryDark;

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (brightness == Brightness.light
                    ? AppTheme.borderSubtleLight
                    : AppTheme.borderSubtleDark),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: 16,
                color: isSelected ? Colors.white : secondaryTextColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              tab.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? Colors.white : textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTab(
    BuildContext context,
    CustomTab tab,
    bool isSelected,
    int index,
    Brightness brightness,
  ) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textPrimaryLight
        : AppTheme.textPrimaryDark;
    final surfaceColor = brightness == Brightness.light
        ? AppTheme.surfaceLight
        : AppTheme.surfaceDark;

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? surfaceColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brightness == Brightness.light
                        ? AppTheme.shadowLight
                        : AppTheme.shadowDark,
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: 16,
                color: isSelected ? primaryColor : textColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              tab.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? primaryColor : textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab(
    BuildContext context,
    CustomTab tab,
    bool isSelected,
    bool isCompleted,
    int index,
    Brightness brightness,
  ) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final secondaryColor = AppTheme.getSecondaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textPrimaryLight
        : AppTheme.textPrimaryDark;
    final secondaryTextColor = brightness == Brightness.light
        ? AppTheme.textSecondaryLight
        : AppTheme.textSecondaryDark;

    Color stepColor;
    if (isCompleted) {
      stepColor = secondaryColor;
    } else if (isSelected) {
      stepColor = primaryColor;
    } else {
      stepColor = secondaryTextColor;
    }

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Column(
        children: [
          // Step indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted || isSelected ? stepColor : Colors.transparent,
              border: Border.all(color: stepColor, width: 2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : tab.icon != null
                      ? Icon(
                          tab.icon,
                          size: 16,
                          color: isSelected ? Colors.white : stepColor,
                        )
                      : Text(
                          '${index + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isSelected ? Colors.white : stepColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
            ),
          ),
          const SizedBox(height: 8),
          // Step label
          Text(
            tab.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected ? textColor : secondaryTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, Brightness brightness) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final backgroundColor = brightness == Brightness.light
        ? AppTheme.borderSubtleLight
        : AppTheme.borderSubtleDark;

    final currentIndex = controller?.index ?? 0;
    final progress = tabs.isNotEmpty ? (currentIndex + 1) / tabs.length : 0.0;

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (onTap != null) {
      onTap!(index);
    } else if (controller != null) {
      controller!.animateTo(index);
    }
  }

  @override
  Size get preferredSize {
    switch (variant) {
      case TabBarVariant.standard:
        return const Size.fromHeight(48);
      case TabBarVariant.pills:
        return const Size.fromHeight(56);
      case TabBarVariant.segmented:
        return const Size.fromHeight(64);
      case TabBarVariant.progress:
        return const Size.fromHeight(96);
    }
  }
}

/// Tab bar variants for different contexts
enum TabBarVariant {
  /// Standard underlined tabs
  standard,

  /// Pill-shaped tabs with background
  pills,

  /// Segmented control style
  segmented,

  /// Progress indicator with steps
  progress,
}

/// Custom tab data class
class CustomTab {
  final String label;
  final IconData? icon;
  final String? route;
  final VoidCallback? onTap;

  const CustomTab({
    required this.label,
    this.icon,
    this.route,
    this.onTap,
  });
}

/// Specialized tab bar for content categories
class CustomContentTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final bool showIcons;

  const CustomContentTabBar({
    super.key,
    this.controller,
    this.onTap,
    this.showIcons = true,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      CustomTab(
        label: 'All',
        icon: showIcons ? Icons.apps_rounded : null,
      ),
      CustomTab(
        label: 'Courses',
        icon: showIcons ? Icons.school_outlined : null,
      ),
      CustomTab(
        label: 'Skills',
        icon: showIcons ? Icons.psychology_outlined : null,
      ),
      CustomTab(
        label: 'Mentors',
        icon: showIcons ? Icons.people_outline : null,
      ),
    ];

    return CustomTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      variant: TabBarVariant.pills,
      isScrollable: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// Specialized tab bar for progress tracking
class CustomProgressTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController? controller;
  final ValueChanged<int>? onTap;

  const CustomProgressTabBar({
    super.key,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      CustomTab(
        label: 'Overview',
        icon: Icons.dashboard_outlined,
      ),
      CustomTab(
        label: 'Skills',
        icon: Icons.trending_up_outlined,
      ),
      CustomTab(
        label: 'Achievements',
        icon: Icons.emoji_events_outlined,
      ),
      CustomTab(
        label: 'Goals',
        icon: Icons.flag_outlined,
      ),
    ];

    return CustomTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      variant: TabBarVariant.progress,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(96);
}
