import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/battery_progress_widget.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/milestone_badge_widget.dart';
import './widgets/progress_entry_card.dart';
import './widgets/quick_log_fab.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  String _selectedFilter = 'All';
  bool _isRefreshing = false;

  // Mock data for progress tracking
  final List<Map<String, dynamic>> _progressEntries = [
    {
      'id': 1,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'activity':
          'Completed React.js tutorial on component lifecycle methods and state management',
      'igPoints': 150,
      'mediaUrl':
          'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800&h=600&fit=crop',
      'hasValidation': true,
    },
    {
      'id': 2,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'activity': 'Built a responsive landing page using CSS Grid and Flexbox',
      'igPoints': 200,
      'mediaUrl':
          'https://images.unsplash.com/photo-1547658719-da2b51169166?w=800&h=600&fit=crop',
      'hasValidation': true,
    },
    {
      'id': 3,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'activity':
          'Practiced JavaScript algorithms - solved 5 coding challenges',
      'igPoints': 100,
      'mediaUrl': null,
      'hasValidation': false,
    },
    {
      'id': 4,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'activity':
          'Attended online workshop on modern web development best practices',
      'igPoints': 120,
      'mediaUrl':
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&h=600&fit=crop',
      'hasValidation': true,
    },
    {
      'id': 5,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'activity': 'Created a Node.js API with Express and MongoDB integration',
      'igPoints': 300,
      'mediaUrl':
          'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=600&fit=crop',
      'hasValidation': true,
    },
  ];

  final List<Map<String, dynamic>> _milestones = [
    {
      'id': 1,
      'title': 'First Steps',
      'description': 'Complete your first progress entry',
      'icon': 'flag',
      'isEarned': true,
      'earnedDate': DateTime.now().subtract(const Duration(days: 10)),
      'rarity': 'common',
    },
    {
      'id': 2,
      'title': 'Consistency King',
      'description': 'Log progress for 7 consecutive days',
      'icon': 'local_fire_department',
      'isEarned': true,
      'earnedDate': DateTime.now().subtract(const Duration(days: 3)),
      'rarity': 'rare',
    },
    {
      'id': 3,
      'title': 'Knowledge Seeker',
      'description': 'Earn 1000 IG points',
      'icon': 'school',
      'isEarned': true,
      'earnedDate': DateTime.now().subtract(const Duration(days: 1)),
      'rarity': 'epic',
    },
    {
      'id': 4,
      'title': 'Master Builder',
      'description': 'Complete 10 projects',
      'icon': 'construction',
      'isEarned': false,
      'earnedDate': null,
      'rarity': 'legendary',
    },
    {
      'id': 5,
      'title': 'Social Butterfly',
      'description': 'Share 5 milestones on social media',
      'icon': 'share',
      'isEarned': false,
      'earnedDate': null,
      'rarity': 'uncommon',
    },
  ];

  final List<String> _filterOptions = [
    'All',
    'This Week',
    'This Month',
    'Milestones',
    'Media',
    'Validated',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? AppTheme.backgroundLight
          : AppTheme.backgroundDark,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.getPrimaryColor(context),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header with countdown and progress
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: _buildFilterSection(context),
            ),

            // Tab bar
            SliverToBoxAdapter(
              child: _buildTabBar(context),
            ),

            // Tab content
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProgressTab(context),
                  _buildMilestonesTab(context),
                  _buildAnalyticsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: QuickLogFAB(
        onProgressLogged: _handleProgressLogged,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Progress tab
        onTap: (index) => _handleBottomNavigation(context, index),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Progress Tracking'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: Theme.of(context).brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      actions: [
        // Countdown timer in top-right corner
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: CountdownTimerWidget(
            targetDate: DateTime.now().add(const Duration(days: 180)),
            label: '6-Month Goal',
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final totalIgPoints = _progressEntries.fold<int>(
      0,
      (sum, entry) => sum + (entry['igPoints'] as int? ?? 0),
    );

    return Container(
      padding: EdgeInsets.all(4.w),
      child: BatteryProgressWidget(
        progress: 0.65, // 65% progress
        skillName: 'Full-Stack Web Development',
        igPoints: totalIgPoints,
        isAnimated: true,
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final count = _getFilterCount(filter);

          return FilterChipWidget(
            label: filter,
            isSelected: _selectedFilter == filter,
            count: count,
            icon: _getFilterIcon(filter),
            onTap: () => setState(() => _selectedFilter = filter),
          );
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.getPrimaryColor(context),
        unselectedLabelColor: AppTheme.getTextColor(context, secondary: true),
        indicatorColor: AppTheme.getPrimaryColor(context),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
        tabs: const [
          Tab(text: 'Timeline'),
          Tab(text: 'Milestones'),
          Tab(text: 'Analytics'),
        ],
      ),
    );
  }

  Widget _buildProgressTab(BuildContext context) {
    final filteredEntries = _getFilteredEntries();

    return ListView.builder(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      itemCount: filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = filteredEntries[index];

        return ProgressEntryCard(
          entry: entry,
          onEdit: () => _handleEditEntry(entry),
          onShare: () => _handleShareEntry(entry),
          onDelete: () => _handleDeleteEntry(entry),
          onTap: () => _handleEntryTap(entry),
        );
      },
    );
  }

  Widget _buildMilestonesTab(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.8,
      ),
      itemCount: _milestones.length,
      itemBuilder: (context, index) {
        final milestone = _milestones[index];

        return MilestoneBadgeWidget(
          milestone: milestone,
          onTap: () => _handleMilestoneTap(milestone),
          onShare: () => _handleShareMilestone(milestone),
        );
      },
    );
  }

  Widget _buildAnalyticsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 3.h),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total IG Points',
                  _progressEntries
                      .fold<int>(
                          0,
                          (sum, entry) =>
                              sum + (entry['igPoints'] as int? ?? 0))
                      .toString(),
                  Icons.bolt,
                  AppTheme.getAccentColor(context),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Entries',
                  _progressEntries.length.toString(),
                  Icons.timeline,
                  AppTheme.getPrimaryColor(context),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Milestones',
                  _milestones
                      .where((m) => m['isEarned'] as bool? ?? false)
                      .length
                      .toString(),
                  Icons.emoji_events,
                  AppTheme.getSecondaryColor(context),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Streak',
                  '7 days',
                  Icons.local_fire_department,
                  const Color(0xFFFF5722),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Export options
          Text(
            'Export Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _handleExportPDF,
                  icon: CustomIconWidget(
                    iconName: 'picture_as_pdf',
                    color: AppTheme.getPrimaryColor(context),
                    size: 20,
                  ),
                  label: Text('Export PDF'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _handleExportCSV,
                  icon: CustomIconWidget(
                    iconName: 'table_chart',
                    color: AppTheme.getPrimaryColor(context),
                    size: 20,
                  ),
                  label: Text('Export CSV'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: _getIconName(icon),
                color: color,
                size: 24,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextColor(context, secondary: true),
                ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<Map<String, dynamic>> _getFilteredEntries() {
    switch (_selectedFilter) {
      case 'This Week':
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        return _progressEntries.where((entry) {
          final date = entry['date'] as DateTime? ?? DateTime.now();
          return date.isAfter(weekAgo);
        }).toList();
      case 'This Month':
        final monthAgo = DateTime.now().subtract(const Duration(days: 30));
        return _progressEntries.where((entry) {
          final date = entry['date'] as DateTime? ?? DateTime.now();
          return date.isAfter(monthAgo);
        }).toList();
      case 'Media':
        return _progressEntries
            .where((entry) => entry['mediaUrl'] != null)
            .toList();
      case 'Validated':
        return _progressEntries
            .where((entry) => entry['hasValidation'] as bool? ?? false)
            .toList();
      default:
        return _progressEntries;
    }
  }

  int _getFilterCount(String filter) {
    switch (filter) {
      case 'Media':
        return _progressEntries
            .where((entry) => entry['mediaUrl'] != null)
            .length;
      case 'Validated':
        return _progressEntries
            .where((entry) => entry['hasValidation'] as bool? ?? false)
            .length;
      case 'Milestones':
        return _milestones.where((m) => m['isEarned'] as bool? ?? false).length;
      default:
        return 0;
    }
  }

  IconData? _getFilterIcon(String filter) {
    switch (filter) {
      case 'This Week':
      case 'This Month':
        return Icons.calendar_today;
      case 'Milestones':
        return Icons.emoji_events;
      case 'Media':
        return Icons.photo_camera;
      case 'Validated':
        return Icons.verified;
      default:
        return null;
    }
  }

  String _getIconName(IconData iconData) {
    if (iconData == Icons.bolt) return 'bolt';
    if (iconData == Icons.timeline) return 'timeline';
    if (iconData == Icons.emoji_events) return 'emoji_events';
    if (iconData == Icons.local_fire_department) return 'local_fire_department';
    return 'help';
  }

  // Event handlers
  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isRefreshing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Progress data refreshed'),
        backgroundColor: AppTheme.getSecondaryColor(context),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleProgressLogged() {
    // Simulate adding new progress entry
    setState(() {
      _progressEntries.insert(0, {
        'id': _progressEntries.length + 1,
        'date': DateTime.now(),
        'activity': 'New progress entry logged with camera',
        'igPoints': 50,
        'mediaUrl':
            'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=800&h=600&fit=crop',
        'hasValidation': false,
      });
    });
  }

  void _handleEditEntry(Map<String, dynamic> entry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit entry: ${entry['activity']}'),
        action: SnackBarAction(
          label: 'Edit',
          onPressed: () {
            // Navigate to edit screen
          },
        ),
      ),
    );
  }

  void _handleShareEntry(Map<String, dynamic> entry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing progress entry...'),
        backgroundColor: AppTheme.getSecondaryColor(context),
      ),
    );
  }

  void _handleDeleteEntry(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Entry'),
        content: Text('Are you sure you want to delete this progress entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _progressEntries.removeWhere((e) => e['id'] == entry['id']);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Entry deleted'),
                  backgroundColor: AppTheme.warningLight,
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleEntryTap(Map<String, dynamic> entry) {
    // Navigate to detailed view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening detailed view...'),
      ),
    );
  }

  void _handleMilestoneTap(Map<String, dynamic> milestone) {
    // Milestone tap handled in widget
  }

  void _handleShareMilestone(Map<String, dynamic> milestone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing milestone to social media...'),
        backgroundColor: AppTheme.getSecondaryColor(context),
      ),
    );
  }

  void _handleExportPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting progress report as PDF...'),
        backgroundColor: AppTheme.getPrimaryColor(context),
      ),
    );
  }

  void _handleExportCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting progress data as CSV...'),
        backgroundColor: AppTheme.getPrimaryColor(context),
      ),
    );
  }

  void _handleBottomNavigation(BuildContext context, int index) {
    final routes = [
      '/dashboard-home',
      '/progress-tracking',
      '/community-feed',
      '/user-profile',
    ];

    if (index < routes.length && routes[index] != '/progress-tracking') {
      Navigator.pushNamed(context, routes[index]);
    }
  }
}
