import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String displayName;
  final String skillFocus;
  final int totalIGPoints;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const ProfileHeaderWidget({
    super.key,
    required this.displayName,
    required this.skillFocus,
    required this.totalIGPoints,
    this.avatarUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
            AppTheme.getSecondaryColor(context).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Avatar with camera overlay
          Stack(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.getPrimaryColor(context),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.getPrimaryColor(context)
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? CustomImageWidget(
                            imageUrl: avatarUrl!,
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme.getPrimaryColor(context)
                                .withValues(alpha: 0.1),
                            child: CustomIconWidget(
                              iconName: 'person',
                              size: 12.w,
                              color: AppTheme.getPrimaryColor(context),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.getPrimaryColor(context),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      size: 4.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Display name
          Text(
            displayName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.getTextColor(context),
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),

          // Skill focus badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.getSecondaryColor(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    AppTheme.getSecondaryColor(context).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'psychology',
                  size: 4.w,
                  color: AppTheme.getSecondaryColor(context),
                ),
                SizedBox(width: 2.w),
                Text(
                  skillFocus,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.getSecondaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // IG Points with animated counter
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.getAccentColor(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.getAccentColor(context).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Total IG Points',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.getTextColor(context, secondary: true),
                      ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'stars',
                      size: 6.w,
                      color: AppTheme.getAccentColor(context),
                    ),
                    SizedBox(width: 2.w),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: totalIGPoints),
                      duration: const Duration(milliseconds: 1500),
                      builder: (context, value, child) {
                        return Text(
                          value.toString().replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]},',
                              ),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppTheme.getAccentColor(context),
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
