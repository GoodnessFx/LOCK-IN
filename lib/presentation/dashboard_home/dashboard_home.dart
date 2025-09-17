import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/battery_progress_widget.dart';
import './widgets/community_highlight_widget.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/progress_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/today_focus_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Alex Chen",
    "igPoints": 2847,
    "streak": 12,
    "primarySkill": "Flutter Development",
    "skillProgress": 68.5,
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
  };

  // Mock achievements data
  final List<Map<String, dynamic>> achievements = [
    {
      "title": "First Steps",
      "description": "Complete first task",
      "icon": Icons.emoji_events,
      "isUnlocked": true,
      "color": Color(0xFFF59E0B),
    },
    {
      "title": "Streak Master",
      "description": "7 day streak",
      "icon": Icons.flash_on,
      "isUnlocked": true,
      "color": Color(0xFF10B981),
    },
    {
      "title": "Code Warrior",
      "description": "100 commits",
      "icon": Icons.star,
      "isUnlocked": false,
      "color": Color(0xFF8B5CF6),
    },
  ];

  // Mock progress cards data
  final List<Map<String, dynamic>> progressCards = [
    {
      "title": "Flutter Widget Mastery",
      "description":
          "Built 15 custom widgets this week, focusing on state management and performance optimization.",
      "imageUrl":
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=300&fit=crop",
      "progressText": "Week 3/6",
      "progressValue": 0.75,
      "tags": ["Flutter", "Widgets", "State Management"],
    },
    {
      "title": "API Integration Challenge",
      "description":
          "Successfully integrated 5 REST APIs with proper error handling and caching mechanisms.",
      "imageUrl":
          "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&h=300&fit=crop",
      "progressText": "Day 4/7",
      "progressValue": 0.57,
      "tags": ["API", "REST", "Networking"],
    },
  ];

  // Mock community highlights
  final List<Map<String, dynamic>> communityHighlights = [
    {
      "userName": "Sarah Kim",
      "userAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "content":
          "Just deployed my first Flutter app to the Play Store! The journey from zero to published app took exactly 4 months. Thanks to the Lock In community for all the support! 🚀",
      "timeAgo": "2h ago",
      "likes": 24,
      "comments": 8,
      "isLiked": false,
    },
    {
      "userName": "Mike Rodriguez",
      "userAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "content":
          "Completed my 30-day coding challenge today! Built 30 different Flutter widgets from scratch. The progress tracking in Lock In kept me motivated throughout. 💪",
      "timeAgo": "4h ago",
      "likes": 31,
      "comments": 12,
      "isLiked": true,
    },
  ];

  // Mock today's focus tasks
  final List<Map<String, dynamic>> todayTasks = [
    {
      "title": "Complete State Management Tutorial",
      "description": "Learn Provider pattern implementation",
      "igPoints": 150,
      "difficulty": "Medium",
      "isCompleted": false,
      "estimatedTime": "45 min",
    },
    {
      "title": "Build Custom Animation Widget",
      "description": "Create reusable animation component",
      "igPoints": 200,
      "difficulty": "Hard",
      "isCompleted": false,
      "estimatedTime": "1.5 hours",
    },
    {
      "title": "Review Code with Mentor",
      "description": "Get feedback on recent projects",
      "igPoints": 100,
      "difficulty": "Easy",
      "isCompleted": true,
      "estimatedTime": "30 min",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle scroll events for animations or loading more content
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data refreshed successfully!'),
          backgroundColor: AppTheme.secondaryLight,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetDate =
        DateTime.now().add(const Duration(days: 180)); // 6 months from now

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.primaryLight,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Custom App Bar with countdown timer
              SliverAppBar(
                floating: true,
                backgroundColor: AppTheme.backgroundLight,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Greeting and user info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Good ${_getGreeting()}, ${userData['name']}!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryLight,
                                  ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'stars',
                                  color: AppTheme.accentLight,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${userData['igPoints']} IG Points',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.accentLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(width: 3.w),
                                CustomIconWidget(
                                  iconName: 'local_fire_department',
                                  color: AppTheme.warningLight,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${userData['streak']} day streak',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.warningLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Countdown timer
                      CountdownTimerWidget(targetDate: targetDate),
                    ],
                  ),
                ),
              ),

              // Main content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Hero progress card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: BatteryProgressWidget(
                        skillName: userData['primarySkill'] as String,
                        progressPercentage: userData['skillProgress'] as double,
                        batteryColor: AppTheme.secondaryLight,
                        width: 30.w,
                        height: 15.w,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Recent achievements section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Recent Achievements',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimaryLight,
                                ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    SizedBox(
                      height: 20.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: achievements.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 3.w),
                        itemBuilder: (context, index) {
                          final achievement = achievements[index];
                          return AchievementBadgeWidget(
                            title: achievement['title'] as String,
                            description: achievement['description'] as String,
                            icon: achievement['icon'] as IconData,
                            badgeColor: achievement['color'] as Color,
                            isUnlocked: achievement['isUnlocked'] as bool,
                            onTap: () => _showAchievementDetails(achievement),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Quick actions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          QuickActionButtonWidget(
                            label: 'Document Progress',
                            icon: Icons.camera_alt,
                            backgroundColor: AppTheme.primaryLight,
                            onTap: _openCamera,
                          ),
                          QuickActionButtonWidget(
                            label: 'Find Mentors',
                            icon: Icons.chat,
                            backgroundColor: AppTheme.secondaryLight,
                            onTap: _openMentors,
                            showBadge: true,
                            badgeText: '3',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Today's Focus
                    TodayFocusWidget(
                      tasks: todayTasks,
                      onViewAll: () =>
                          Navigator.pushNamed(context, '/progress-tracking'),
                    ),

                    SizedBox(height: 4.h),

                    // AI-generated progress cards
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Share Your Progress',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimaryLight,
                                ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    ...progressCards
                        .map((card) => ProgressCardWidget(
                              title: card['title'] as String,
                              description: card['description'] as String,
                              imageUrl: card['imageUrl'] as String,
                              progressText: card['progressText'] as String,
                              progressValue: card['progressValue'] as double,
                              tags: (card['tags'] as List).cast<String>(),
                              onShare: () => _shareProgress(card),
                              onTap: () => _viewProgressDetails(card),
                            ))
                        .toList(),

                    SizedBox(height: 4.h),

                    // Community highlights
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Community Highlights',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimaryLight,
                                ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/community-feed'),
                            child: Text(
                              'View All',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: AppTheme.primaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    ...communityHighlights
                        .map((highlight) => CommunityHighlightWidget(
                              userName: highlight['userName'] as String,
                              userAvatar: highlight['userAvatar'] as String,
                              content: highlight['content'] as String,
                              timeAgo: highlight['timeAgo'] as String,
                              likes: highlight['likes'] as int,
                              comments: highlight['comments'] as int,
                              isLiked: highlight['isLiked'] as bool,
                              onLike: () => _toggleLike(highlight),
                              onComment: () => _openComments(highlight),
                              onTap: () => _viewPost(highlight),
                            ))
                        .toList(),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button for quick progress logging
      floatingActionButton: FloatingActionButton(
        onPressed: _quickProgressLog,
        tooltip: 'Quick Progress Log',
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0, // Home tab active
        onTap: _onBottomNavTap,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
        title: Text(
          achievement['title'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
        ),
        content: Text(
          achievement['description'] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openCamera() {
    HapticFeedback.lightImpact();
    // Navigate to camera screen or show camera options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening camera for progress documentation...'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _openMentors() {
    HapticFeedback.lightImpact();
    // Navigate to mentors screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening mentor marketplace...'),
        backgroundColor: AppTheme.secondaryLight,
      ),
    );
  }

  void _shareProgress(Map<String, dynamic> card) {
    HapticFeedback.mediumImpact();
    // Handle progress sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing progress: ${card['title']}'),
        backgroundColor: AppTheme.accentLight,
      ),
    );
  }

  void _viewProgressDetails(Map<String, dynamic> card) {
    // Navigate to detailed progress view
    Navigator.pushNamed(context, '/progress-tracking');
  }

  void _toggleLike(Map<String, dynamic> highlight) {
    HapticFeedback.lightImpact();
    setState(() {
      highlight['isLiked'] = !(highlight['isLiked'] as bool);
      if (highlight['isLiked'] as bool) {
        highlight['likes'] = (highlight['likes'] as int) + 1;
      } else {
        highlight['likes'] = (highlight['likes'] as int) - 1;
      }
    });
  }

  void _openComments(Map<String, dynamic> highlight) {
    // Navigate to comments screen
    Navigator.pushNamed(context, '/community-feed');
  }

  void _viewPost(Map<String, dynamic> highlight) {
    // Navigate to full post view
    Navigator.pushNamed(context, '/community-feed');
  }

  void _quickProgressLog() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtleLight,
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Progress Log',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickLogOption(
                    'Photo', 'camera_alt', () => _openCamera()),
                _buildQuickLogOption('Note', 'edit', () {}),
                _buildQuickLogOption('Achievement', 'emoji_events', () {}),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLogOption(
      String label, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/progress-tracking');
        break;
      case 2:
        Navigator.pushNamed(context, '/community-feed');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }
}
