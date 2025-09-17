import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/community_post_card.dart';
import './widgets/community_search_bar.dart';
import './widgets/content_filter_chips.dart';
import './widgets/create_post_fab.dart';
import './widgets/skill_community_channels.dart';

class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  bool _isRefreshing = false;
  int _currentBottomNavIndex = 2; // Community tab active

  final List<String> _contentFilters = [
    'All',
    'Progress',
    'Milestones',
    'Mentors',
    'Discussions',
    'Achievements',
  ];

  final List<Map<String, dynamic>> _communityPosts = [
    {
      "id": 1,
      "user": {
        "id": 101,
        "name": "Sarah Chen",
        "avatar":
            "https://images.unsplash.com/photo-1494790108755-2616b612b5bc?w=150&h=150&fit=crop&crop=face",
        "isVerified": true,
      },
      "skill": {"id": 1, "name": "Flutter Development", "color": "#2196F3"},
      "content":
          "Just completed my first Flutter app with state management! The journey from beginner to building a functional app has been incredible. Thanks to this amazing community for all the support! 🚀",
      "imageUrl":
          "https://images.unsplash.com/photo-1551650975-87deedd944c3?w=800&h=600&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "likes": 127,
      "comments": 23,
      "shares": 8,
      "isLiked": false,
      "type": "progress"
    },
    {
      "id": 2,
      "user": {
        "id": 102,
        "name": "Marcus Johnson",
        "avatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "isVerified": false,
      },
      "skill": {"id": 2, "name": "UI/UX Design", "color": "#9C27B0"},
      "content":
          "🎉 Milestone achieved! Just landed my first freelance design project after 3 months of intensive learning. The client loved the user research approach we discussed in the mentorship sessions.",
      "imageUrl":
          "https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800&h=600&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "likes": 89,
      "comments": 15,
      "shares": 12,
      "isLiked": true,
      "type": "milestone"
    },
    {
      "id": 3,
      "user": {
        "id": 103,
        "name": "Elena Rodriguez",
        "avatar":
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
        "isVerified": true,
      },
      "skill": {"id": 3, "name": "Data Science", "color": "#FF5722"},
      "content":
          "Question for the community: What's your favorite Python library for data visualization? I've been using matplotlib but wondering if there are better alternatives for interactive charts.",
      "imageUrl": "",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "likes": 45,
      "comments": 31,
      "shares": 5,
      "isLiked": false,
      "type": "discussion"
    },
    {
      "id": 4,
      "user": {
        "id": 104,
        "name": "David Kim",
        "avatar":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
        "isVerified": false,
      },
      "skill": {"id": 4, "name": "Digital Marketing", "color": "#4CAF50"},
      "content":
          "Achievement unlocked! 🏆 My latest SEO campaign increased organic traffic by 150% in just 6 weeks. The strategies I learned from our mentor sessions really paid off. Happy to share insights!",
      "imageUrl":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&h=600&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "likes": 203,
      "comments": 42,
      "shares": 28,
      "isLiked": true,
      "type": "achievement"
    },
    {
      "id": 5,
      "user": {
        "id": 105,
        "name": "Aisha Patel",
        "avatar":
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face",
        "isVerified": true,
      },
      "skill": {"id": 5, "name": "Photography", "color": "#FF9800"},
      "content":
          "Golden hour magic from today's portrait session! Still learning about natural lighting techniques. The Lock In photography community has been incredibly supportive in my journey.",
      "imageUrl":
          "https://images.unsplash.com/photo-1554080353-a576cf803bda?w=800&h=600&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      "likes": 156,
      "comments": 19,
      "shares": 11,
      "isLiked": false,
      "type": "progress"
    },
    {
      "id": 6,
      "user": {
        "id": 106,
        "name": "James Wilson",
        "avatar":
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
        "isVerified": false,
      },
      "skill": {"id": 6, "name": "Cooking", "color": "#E91E63"},
      "content":
          "Week 12 of my culinary journey! Today I mastered the perfect risotto technique. The key is patience and constant stirring. Thanks to Chef Maria for the amazing mentorship sessions! 👨‍🍳",
      "imageUrl":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=800&h=600&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(hours: 12)),
      "likes": 78,
      "comments": 25,
      "shares": 6,
      "isLiked": false,
      "type": "progress"
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
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    // Simulate loading more posts
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation, this would fetch more posts from API
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh with haptic feedback
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    // Implement search functionality
    debugPrint('Search query: $query');
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.getTextColor(context, secondary: true),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Filter Content',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            _buildFilterOptions(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Column(
      children: [
        _buildFilterSection('Content Type', [
          'Progress Updates',
          'Milestones',
          'Discussions',
          'Achievements',
        ]),
        _buildFilterSection('Skills', [
          'Flutter Development',
          'UI/UX Design',
          'Data Science',
          'Digital Marketing',
          'Photography',
          'Cooking',
        ]),
        _buildFilterSection('Time Range', [
          'Today',
          'This Week',
          'This Month',
          'All Time',
        ]),
      ],
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: options
                .map((option) => FilterChip(
                      label: Text(option),
                      selected: false,
                      onSelected: (selected) {},
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showSkillChannels() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SkillCommunityChannels(
        onChannelSelected: () {
          // Handle channel selection
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPosts() {
    if (_selectedFilter == 'All') {
      return _communityPosts;
    }

    return _communityPosts.where((post) {
      final postType = post['type'] as String;
      switch (_selectedFilter.toLowerCase()) {
        case 'progress':
          return postType == 'progress';
        case 'milestones':
          return postType == 'milestone';
        case 'mentors':
          return postType == 'mentor';
        case 'discussions':
          return postType == 'discussion';
        case 'achievements':
          return postType == 'achievement';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final filteredPosts = _getFilteredPosts();

    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? AppTheme.backgroundLight
          : AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'groups',
              color: AppTheme.getPrimaryColor(context),
              size: 28,
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Connect & Share Progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextColor(context, secondary: true),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: _showSkillChannels,
            child: Container(
              padding: EdgeInsets.all(2.w),
              margin: EdgeInsets.only(right: 2.w),
              decoration: BoxDecoration(
                color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.getPrimaryColor(context),
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/user-profile'),
            child: Container(
              margin: EdgeInsets.only(right: 4.w),
              child: CircleAvatar(
                radius: 16,
                backgroundColor:
                    AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.getPrimaryColor(context),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        color: AppTheme.getPrimaryColor(context),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: CommunitySearchBar(
                controller: _searchController,
                onSearchChanged: _onSearchChanged,
                onFilterTap: _showFilterModal,
              ),
            ),

            // Filter Chips
            SliverToBoxAdapter(
              child: ContentFilterChips(
                filters: _contentFilters,
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
            ),

            // Posts Feed
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= filteredPosts.length) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.getPrimaryColor(context),
                        ),
                      ),
                    );
                  }

                  final post = filteredPosts[index];

                  return Slidable(
                    key: ValueKey(post['id']),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            HapticFeedback.lightImpact();
                            // Handle save post
                          },
                          backgroundColor: AppTheme.getSecondaryColor(context),
                          foregroundColor: Colors.white,
                          icon: Icons.bookmark,
                          label: 'Save',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            HapticFeedback.lightImpact();
                            // Handle share post
                          },
                          backgroundColor: AppTheme.getPrimaryColor(context),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            HapticFeedback.mediumImpact();
                            // Handle report post
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.report,
                          label: 'Report',
                        ),
                      ],
                    ),
                    child: CommunityPostCard(
                      post: post,
                      onLike: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          post['isLiked'] = !(post['isLiked'] as bool);
                          if (post['isLiked'] as bool) {
                            post['likes'] = (post['likes'] as int) + 1;
                          } else {
                            post['likes'] = (post['likes'] as int) - 1;
                          }
                        });
                      },
                      onComment: () {
                        _showCommentsModal(post);
                      },
                      onShare: () {
                        HapticFeedback.lightImpact();
                        // Handle share functionality
                      },
                      onSave: () {
                        HapticFeedback.lightImpact();
                        // Handle save functionality
                      },
                      onTap: () {
                        _showPostDetails(post);
                      },
                    ),
                  );
                },
                childCount: filteredPosts.length + 1,
              ),
            ),

            // Bottom padding for FAB
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      floatingActionButton: CreatePostFAB(
        onPostCreated: () {
          HapticFeedback.mediumImpact();
          _refreshFeed();
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });

          // Navigate to different screens based on index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard-home');
              break;
            case 1:
              Navigator.pushNamed(context, '/progress-tracking');
              break;
            case 2:
              // Already on community feed
              break;
            case 3:
              Navigator.pushNamed(context, '/user-profile');
              break;
          }
        },
      ),
    );
  }

  void _showCommentsModal(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.getTextColor(context, secondary: true),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Text(
                      'Comments',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${post['comments']} comments',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: 5, // Mock comments
                  itemBuilder: (context, index) =>
                      _buildCommentItem(context, index),
                ),
              ),
              _buildCommentInput(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, int index) {
    final mockComments = [
      {
        'user': 'Alex Thompson',
        'avatar':
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face',
        'comment': 'Great progress! Keep up the amazing work 👏',
        'time': '2h ago',
        'likes': 5,
      },
      {
        'user': 'Maria Garcia',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b5bc?w=150&h=150&fit=crop&crop=face',
        'comment': 'This is so inspiring! I\'m working on a similar project.',
        'time': '4h ago',
        'likes': 3,
      },
    ];

    if (index >= mockComments.length) return const SizedBox.shrink();

    final comment = mockComments[index];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(comment['avatar'] as String),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['user'] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      comment['time'] as String,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  comment['comment'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'favorite_border',
                            color:
                                AppTheme.getTextColor(context, secondary: true),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${comment['likes']}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppTheme.getTextColor(context,
                                      secondary: true),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Reply',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.getPrimaryColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
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

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? AppTheme.borderSubtleLight
                : AppTheme.borderSubtleDark,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.getPrimaryColor(context),
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.getPrimaryColor(context),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostDetails(Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Post Details'),
            leading: IconButton(
              icon: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: AppTheme.getTextColor(context),
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: CommunityPostCard(
              post: post,
              onLike: () {
                HapticFeedback.lightImpact();
                setState(() {
                  post['isLiked'] = !(post['isLiked'] as bool);
                  if (post['isLiked'] as bool) {
                    post['likes'] = (post['likes'] as int) + 1;
                  } else {
                    post['likes'] = (post['likes'] as int) - 1;
                  }
                });
              },
              onComment: () => _showCommentsModal(post),
              onShare: () {},
              onSave: () {},
            ),
          ),
        ),
      ),
    );
  }
}

