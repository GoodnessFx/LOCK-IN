import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final Function(String)? onSettingTap;
  final VoidCallback? onLogout;

  const SettingsSectionWidget({
    super.key,
    this.onSettingTap,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.getTextColor(context),
                ),
          ),
          SizedBox(height: 2.h),

          // Account preferences
          _buildSettingsGroup(
            context,
            'Account',
            [
              _SettingItem(
                icon: 'person',
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => onSettingTap?.call('edit_profile'),
              ),
              _SettingItem(
                icon: 'notifications',
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () => onSettingTap?.call('notifications'),
              ),
              _SettingItem(
                icon: 'security',
                title: 'Privacy & Security',
                subtitle: 'Control your privacy settings',
                onTap: () => onSettingTap?.call('privacy'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Social media integration
          _buildSettingsGroup(
            context,
            'Social Media',
            [
              _SettingItem(
                icon: 'link',
                title: 'Connected Accounts',
                subtitle: 'Manage X and LinkedIn connections',
                onTap: () => onSettingTap?.call('social_accounts'),
              ),
              _SettingItem(
                icon: 'share',
                title: 'Sharing Preferences',
                subtitle: 'Control automatic sharing settings',
                onTap: () => onSettingTap?.call('sharing'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Data and export
          _buildSettingsGroup(
            context,
            'Data & Export',
            [
              _SettingItem(
                icon: 'download',
                title: 'Export Progress',
                subtitle: 'Download your learning data',
                onTap: () => onSettingTap?.call('export_data'),
              ),
              _SettingItem(
                icon: 'print',
                title: 'Print Portfolio',
                subtitle: 'Generate printable progress report',
                onTap: () => onSettingTap?.call('print_portfolio'),
              ),
              _SettingItem(
                icon: 'verified',
                title: 'Verification Stamps',
                subtitle: 'View cryptographic validations',
                onTap: () => onSettingTap?.call('verification'),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Support and about
          _buildSettingsGroup(
            context,
            'Support',
            [
              _SettingItem(
                icon: 'help',
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () => onSettingTap?.call('help'),
              ),
              _SettingItem(
                icon: 'info',
                title: 'About Lock In',
                subtitle: 'App version and information',
                onTap: () => onSettingTap?.call('about'),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Logout button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                foregroundColor: Colors.red,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'logout',
                    size: 5.w,
                    color: Colors.red,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Sign Out',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    String title,
    List<_SettingItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextColor(context),
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.getTextColor(context, secondary: true)
                  .withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  _buildSettingItem(context, item),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: AppTheme.getTextColor(context, secondary: true)
                          .withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, _SettingItem item) {
    return ListTile(
      onTap: item.onTap,
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: CustomIconWidget(
          iconName: item.icon,
          size: 5.w,
          color: AppTheme.getPrimaryColor(context),
        ),
      ),
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextColor(context),
            ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextColor(context, secondary: true),
                  ),
            )
          : null,
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        size: 5.w,
        color: AppTheme.getTextColor(context, secondary: true),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Sign Out',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.getTextColor(context),
                ),
          ),
          content: Text(
            'Are you sure you want to sign out? Your progress will be safely backed up.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.getTextColor(context, secondary: true),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onLogout?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Sign Out',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SettingItem {
  final String icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}
