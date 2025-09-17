import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillCommunityChannels extends StatefulWidget {
  final VoidCallback? onChannelSelected;

  const SkillCommunityChannels({
    super.key,
    this.onChannelSelected,
  });

  @override
  State<SkillCommunityChannels> createState() => _SkillCommunityChannelsState();
}

class _SkillCommunityChannelsState extends State<SkillCommunityChannels> {
  final List<Map<String, dynamic>> _skillChannels = [
    {
      "id": 1,
      "name": "Flutter Development",
      "icon": "code",
      "memberCount": 15420,
      "onlineCount": 234,
      "description": "Mobile app development with Flutter framework",
      "isJoined": true,
      "lastMessage": "Anyone working on state management patterns?",
      "lastMessageTime": DateTime.now().subtract(const Duration(minutes: 5)),
      "category": "Technology"
    },
    {
      "id": 2,
      "name": "UI/UX Design",
      "icon": "palette",
      "memberCount": 8750,
      "onlineCount": 156,
      "description": "User interface and experience design community",
      "isJoined": true,
      "lastMessage": "Check out this new design system I created!",
      "lastMessageTime": DateTime.now().subtract(const Duration(minutes: 12)),
      "category": "Design"
    },
    {
      "id": 3,
      "name": "Data Science",
      "icon": "analytics",
      "memberCount": 12300,
      "onlineCount": 89,
      "description": "Machine learning, AI, and data analysis",
      "isJoined": false,
      "lastMessage": "New Python libraries for data visualization",
      "lastMessageTime": DateTime.now().subtract(const Duration(hours: 1)),
      "category": "Technology"
    },
    {
      "id": 4,
      "name": "Digital Marketing",
      "icon": "campaign",
      "memberCount": 6890,
      "onlineCount": 67,
      "description": "SEO, social media, and online marketing strategies",
      "isJoined": true,
      "lastMessage": "Latest Google algorithm updates discussion",
      "lastMessageTime": DateTime.now().subtract(const Duration(hours: 2)),
      "category": "Business"
    },
    {
      "id": 5,
      "name": "Photography",
      "icon": "camera_alt",
      "memberCount": 9540,
      "onlineCount": 123,
      "description": "Professional and amateur photography community",
      "isJoined": false,
      "lastMessage": "Golden hour shots from today's session",
      "lastMessageTime": DateTime.now().subtract(const Duration(hours: 3)),
      "category": "Creative"
    },
    {
      "id": 6,
      "name": "Cooking & Culinary",
      "icon": "restaurant",
      "memberCount": 11200,
      "onlineCount": 198,
      "description": "Recipes, techniques, and culinary adventures",
      "isJoined": true,
      "lastMessage": "Perfect pasta sauce recipe - must try!",
      "lastMessageTime": DateTime.now().subtract(const Duration(hours: 4)),
      "category": "Lifestyle"
    },
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Technology',
    'Design',
    'Business',
    'Creative',
    'Lifestyle'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildCategoryFilter(context),
          Expanded(
            child: _buildChannelsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? AppTheme.borderSubtleLight
                : AppTheme.borderSubtleDark,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.getTextColor(context, secondary: true),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'groups',
                color: AppTheme.getPrimaryColor(context),
                size: 28,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skill Communities',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Connect with peers in your field',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.getTextColor(context),
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.getPrimaryColor(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.getPrimaryColor(context)
                        : AppTheme.getTextColor(context, secondary: true),
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.getTextColor(context),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChannelsList(BuildContext context) {
    final filteredChannels = _selectedCategory == 'All'
        ? _skillChannels
        : _skillChannels
            .where((channel) =>
                (channel['category'] as String) == _selectedCategory)
            .toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: filteredChannels.length,
      itemBuilder: (context, index) {
        final channel = filteredChannels[index];
        return _buildChannelCard(context, channel);
      },
    );
  }

  Widget _buildChannelCard(BuildContext context, Map<String, dynamic> channel) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isJoined = channel['isJoined'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: isJoined
            ? Border.all(
                color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.3),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: brightness == Brightness.light
                ? AppTheme.shadowLight
                : AppTheme.shadowDark,
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
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: channel['icon'] as String,
                  color: AppTheme.getPrimaryColor(context),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            channel['name'] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isJoined)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.getSecondaryColor(context),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Joined',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'people',
                          color:
                              AppTheme.getTextColor(context, secondary: true),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${_formatNumber(channel['memberCount'] as int)} members',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.getSecondaryColor(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${channel['onlineCount']} online',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.getSecondaryColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            channel['description'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextColor(context, secondary: true),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isJoined) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    AppTheme.getPrimaryColor(context).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Message',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.getTextColor(context, secondary: true),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    channel['lastMessage'] as String,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTimestamp(channel['lastMessageTime'] as DateTime),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.getTextColor(context, secondary: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onChannelSelected?.call();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isJoined
                        ? AppTheme.getPrimaryColor(context)
                        : Colors.transparent,
                    foregroundColor: isJoined
                        ? Colors.white
                        : AppTheme.getPrimaryColor(context),
                    side: isJoined
                        ? null
                        : BorderSide(
                            color: AppTheme.getPrimaryColor(context),
                            width: 1,
                          ),
                  ),
                  child: Text(isJoined ? 'Open Chat' : 'Join Channel'),
                ),
              ),
              SizedBox(width: 3.w),
              IconButton(
                onPressed: () {},
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.getTextColor(context, secondary: true),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
