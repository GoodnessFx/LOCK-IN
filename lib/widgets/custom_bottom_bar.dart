import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom Bottom Navigation Bar implementing Contemporary Gamified Minimalism
/// Provides mobile-first navigation with contextual feedback
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomBarVariant variant;
  final bool showLabels;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = BottomBarVariant.standard,
    this.showLabels = true,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Navigation items with hardcoded routes
    final items = _getNavigationItems(context);

    switch (variant) {
      case BottomBarVariant.standard:
        return _buildStandardBottomBar(context, items, brightness);
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, items, brightness);
      case BottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, items, brightness);
    }
  }

  List<BottomNavigationItem> _getNavigationItems(BuildContext context) {
    return [
      BottomNavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
        route: '/dashboard-home',
      ),
      BottomNavigationItem(
        icon: Icons.trending_up_outlined,
        activeIcon: Icons.trending_up_rounded,
        label: 'Progress',
        route: '/progress-tracking',
      ),
      BottomNavigationItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people_rounded,
        label: 'Community',
        route: '/community-feed',
      ),
      BottomNavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
        route: '/user-profile',
      ),
    ];
  }

  Widget _buildStandardBottomBar(
    BuildContext context,
    List<BottomNavigationItem> items,
    Brightness brightness,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        boxShadow: [
          BoxShadow(
            color: brightness == Brightness.light
                ? AppTheme.shadowMediumLight
                : AppTheme.shadowMediumDark,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavigationItem(
                context,
                item,
                isSelected,
                index,
                brightness,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
    BuildContext context,
    List<BottomNavigationItem> items,
    Brightness brightness,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? AppTheme.surfaceLight
              : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: brightness == Brightness.light
                  ? AppTheme.shadowStrongLight
                  : AppTheme.shadowStrongDark,
              offset: const Offset(0, 4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == currentIndex;

                return _buildNavigationItem(
                  context,
                  item,
                  isSelected,
                  index,
                  brightness,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(
    BuildContext context,
    List<BottomNavigationItem> items,
    Brightness brightness,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(
            color: brightness == Brightness.light
                ? AppTheme.borderSubtleLight
                : AppTheme.borderSubtleDark,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildMinimalNavigationItem(
                context,
                item,
                isSelected,
                index,
                brightness,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    BottomNavigationItem item,
    bool isSelected,
    int index,
    Brightness brightness,
  ) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textSecondaryLight
        : AppTheme.textSecondaryDark;

    return GestureDetector(
      onTap: () => _handleTap(context, index, item.route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? primaryColor : textColor,
                size: 24,
              ),
            ),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? primaryColor : textColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalNavigationItem(
    BuildContext context,
    BottomNavigationItem item,
    bool isSelected,
    int index,
    Brightness brightness,
  ) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textSecondaryLight
        : AppTheme.textSecondaryDark;

    return GestureDetector(
      onTap: () => _handleTap(context, index, item.route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 2,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            isSelected ? item.activeIcon : item.icon,
            color: isSelected ? primaryColor : textColor,
            size: 24,
          ),
          if (showLabels) ...[
            const SizedBox(height: 4),
            Text(
              item.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? primaryColor : textColor,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    if (onTap != null) {
      onTap!(index);
    } else {
      // Default navigation behavior
      Navigator.pushNamed(context, route);
    }
  }
}

/// Bottom navigation bar variants
enum BottomBarVariant {
  /// Standard bottom bar with subtle shadow
  standard,

  /// Floating bottom bar with rounded corners
  floating,

  /// Minimal bottom bar with top indicator
  minimal,
}

/// Navigation item data class
class BottomNavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const BottomNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Specialized bottom bar with floating action button
class CustomBottomBarWithFAB extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final VoidCallback? onFABPressed;
  final IconData fabIcon;
  final String fabTooltip;
  final bool showLabels;

  const CustomBottomBarWithFAB({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.onFABPressed,
    this.fabIcon = Icons.add_rounded,
    this.fabTooltip = 'Add',
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final items = _getNavigationItems();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? AppTheme.surfaceLight
                : AppTheme.surfaceDark,
            boxShadow: [
              BoxShadow(
                color: brightness == Brightness.light
                    ? AppTheme.shadowMediumLight
                    : AppTheme.shadowMediumDark,
                offset: const Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // First two items
                  ...items.take(2).toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == currentIndex;

                    return _buildNavigationItem(
                      context,
                      item,
                      isSelected,
                      index,
                      brightness,
                    );
                  }),

                  // Spacer for FAB
                  const SizedBox(width: 56),

                  // Last two items
                  ...items.skip(2).toList().asMap().entries.map((entry) {
                    final index = entry.key + 2;
                    final item = entry.value;
                    final isSelected = index == currentIndex;

                    return _buildNavigationItem(
                      context,
                      item,
                      isSelected,
                      index,
                      brightness,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        // Floating Action Button
        Positioned(
          top: -28,
          child: FloatingActionButton(
            onPressed: onFABPressed,
            tooltip: fabTooltip,
            child: Icon(fabIcon),
          ),
        ),
      ],
    );
  }

  List<BottomNavigationItem> _getNavigationItems() {
    return [
      BottomNavigationItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
        route: '/dashboard-home',
      ),
      BottomNavigationItem(
        icon: Icons.trending_up_outlined,
        activeIcon: Icons.trending_up_rounded,
        label: 'Progress',
        route: '/progress-tracking',
      ),
      BottomNavigationItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people_rounded,
        label: 'Community',
        route: '/community-feed',
      ),
      BottomNavigationItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
        route: '/user-profile',
      ),
    ];
  }

  Widget _buildNavigationItem(
    BuildContext context,
    BottomNavigationItem item,
    bool isSelected,
    int index,
    Brightness brightness,
  ) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor = brightness == Brightness.light
        ? AppTheme.textSecondaryLight
        : AppTheme.textSecondaryDark;

    return GestureDetector(
      onTap: () => _handleTap(context, index, item.route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? primaryColor : textColor,
              size: 24,
            ),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? primaryColor : textColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    if (onTap != null) {
      onTap!(index);
    } else {
      Navigator.pushNamed(context, route);
    }
  }
}