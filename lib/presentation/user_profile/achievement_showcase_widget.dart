import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementShowcaseWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  final Function(Map<String, dynamic>)? onAchievementTap;
  final Function(Map<String, dynamic>)? onShareTap;

  const AchievementShowcaseWidget({
    super.key,
    required this.achievements,
    this.onAchievementTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.getTextColor(context),
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getSecondaryColor(context)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${achievements.length} Earned',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.getSecondaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          achievements.isEmpty
              ? _buildEmptyState(context)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return _buildAchievementBadge(context, achievement);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.getTextColor(context, secondary: true)
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getTextColor(context, secondary: true)
              .withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'emoji_events',
            size: 12.w,
            color: AppTheme.getTextColor(context, secondary: true),
          ),
          SizedBox(height: 2.h),
          Text(
            'No achievements yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete challenges and milestones to earn your first badge!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
      BuildContext context, Map<String, dynamic> achievement) {
    final String title = achievement['title'] as String? ?? 'Achievement';
    final String description = achievement['description'] as String? ?? '';
    final String iconName = achievement['icon'] as String? ?? 'emoji_events';
    final String rarity = achievement['rarity'] as String? ?? 'common';
    final DateTime earnedDate =
        achievement['earnedDate'] as DateTime? ?? DateTime.now();
    final int igPoints = achievement['igPoints'] as int? ?? 0;

    Color rarityColor = _getRarityColor(context, rarity);

    return GestureDetector(
      onTap: () => onAchievementTap?.call(achievement),
      onLongPress: () => onShareTap?.call(achievement),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: rarityColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: rarityColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon with glow effect
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: rarityColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                size: 6.w,
                color: rarityColor,
              ),
            ),
            SizedBox(height: 1.h),

            // Achievement title
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextColor(context),
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),

            // IG Points earned
            if (igPoints > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.getAccentColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$igPoints IG',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.getAccentColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(BuildContext context, String rarity) {
    switch (rarity.toLowerCase()) {
      case 'legendary':
        return const Color(0xFFFF6B35); // Orange
      case 'epic':
        return const Color(0xFF8B5CF6); // Purple
      case 'rare':
        return const Color(0xFF3B82F6); // Blue
      case 'uncommon':
        return AppTheme.getSecondaryColor(context); // Green
      default:
        return AppTheme.getTextColor(context, secondary: true); // Gray
    }
  }
}
