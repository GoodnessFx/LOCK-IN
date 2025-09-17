import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo.dart';
import './widgets/battery_progress_indicator.dart';
import './widgets/countdown_timer_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _contentController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _contentAnimation;

  double _initializationProgress = 0.0;
  String _currentTask = 'Initializing...';
  bool _hasError = false;

  // Mock initialization tasks
  final List<Map<String, dynamic>> _initializationTasks = [
    {'task': 'Checking authentication...', 'duration': 800},
    {'task': 'Loading user preferences...', 'duration': 600},
    {'task': 'Syncing IG points...', 'duration': 700},
    {'task': 'Fetching progress stamps...', 'duration': 500},
    {'task': 'Preparing community data...', 'duration': 400},
    {'task': 'Ready to lock in!', 'duration': 300},
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
    _hideSystemUI();
  }

  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _contentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    ));

    _backgroundController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _contentController.forward();
    });
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _startInitialization() async {
    try {
      double progressStep = 1.0 / _initializationTasks.length;

      for (int i = 0; i < _initializationTasks.length; i++) {
        final task = _initializationTasks[i];

        setState(() {
          _currentTask = task['task'];
          _initializationProgress = (i + 1) * progressStep;
        });

        // Simulate task execution
        await Future.delayed(Duration(milliseconds: task['duration']));

        // Perform actual initialization tasks
        await _performInitializationTask(i);
      }

      // Wait a moment before navigation
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to appropriate screen
      await _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _currentTask = 'Initialization failed. Retrying...';
      });

      // Retry after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      _startInitialization();
    }
  }

  Future<void> _performInitializationTask(int taskIndex) async {
    switch (taskIndex) {
      case 0: // Check authentication
        await _checkAuthenticationStatus();
        break;
      case 1: // Load user preferences
        await _loadUserPreferences();
        break;
      case 2: // Sync IG points
        await _syncIGPoints();
        break;
      case 3: // Fetch progress stamps
        await _fetchProgressStamps();
        break;
      case 4: // Prepare community data
        await _prepareCommunityData();
        break;
      case 5: // Final setup
        await _finalSetup();
        break;
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final hasCompletedOnboarding =
        prefs.getBool('completed_onboarding') ?? false;

    // Store navigation decision for later use
    prefs.setBool(
        'should_show_dashboard', isLoggedIn && hasCompletedOnboarding);
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load mock user preferences
    final selectedSkills =
        prefs.getStringList('selected_skills') ?? ['Technology'];
    final preferredDifficulty =
        prefs.getString('preferred_difficulty') ?? 'Intermediate';
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    // Cache preferences for app use
    prefs.setStringList('cached_skills', selectedSkills);
    prefs.setString('cached_difficulty', preferredDifficulty);
    prefs.setBool('cached_notifications', notificationsEnabled);
  }

  Future<void> _syncIGPoints() async {
    final prefs = await SharedPreferences.getInstance();

    // Mock IG points synchronization
    final currentPoints = prefs.getInt('ig_points') ?? 0;
    final lastSyncTime = prefs.getInt('last_sync_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Simulate earning points while offline
    if (now - lastSyncTime > 86400000) {
      // 24 hours
      final newPoints = currentPoints + 50; // Daily bonus
      prefs.setInt('ig_points', newPoints);
    }

    prefs.setInt('last_sync_time', now);
  }

  Future<void> _fetchProgressStamps() async {
    final prefs = await SharedPreferences.getInstance();

    // Mock cryptographic progress stamps
    final stamps = prefs.getStringList('progress_stamps') ?? [];
    final mockStamp = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'activity': 'app_launch',
      'hash': 'mock_crypto_hash_${DateTime.now().millisecondsSinceEpoch}',
    };

    stamps.add(mockStamp.toString());
    prefs.setStringList('progress_stamps', stamps);
  }

  Future<void> _prepareCommunityData() async {
    final prefs = await SharedPreferences.getInstance();

    // Cache community data for offline access
    final communityData = {
      'active_users': 15420,
      'daily_challenges': 3,
      'trending_skills': ['Flutter', 'AI/ML', 'Cooking', 'Photography'],
      'featured_mentors': 12,
    };

    prefs.setString('cached_community_data', communityData.toString());
  }

  Future<void> _finalSetup() async {
    final prefs = await SharedPreferences.getInstance();

    // Set app launch timestamp
    prefs.setInt('last_launch_time', DateTime.now().millisecondsSinceEpoch);

    // Initialize 6-month countdown if not set
    if (!prefs.containsKey('countdown_target')) {
      final sixMonthsFromNow = DateTime.now().add(const Duration(days: 180));
      prefs.setInt('countdown_target', sixMonthsFromNow.millisecondsSinceEpoch);
    }
  }

  Future<void> _navigateToNextScreen() async {
    _restoreSystemUI();

    final prefs = await SharedPreferences.getInstance();
    final shouldShowDashboard = prefs.getBool('should_show_dashboard') ?? false;
    final hasCompletedOnboarding =
        prefs.getBool('completed_onboarding') ?? false;

    if (!mounted) return;

    String nextRoute;
    if (shouldShowDashboard) {
      nextRoute = '/dashboard-home';
    } else if (!hasCompletedOnboarding) {
      // For now, redirect to login as onboarding is not implemented
      nextRoute = '/login-screen';
    } else {
      nextRoute = '/login-screen';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final size = MediaQuery.of(context).size;

    // Get countdown target date
    final countdownTarget = DateTime.now().add(const Duration(days: 180));

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (brightness == Brightness.light
                          ? AppTheme.primaryLight
                          : AppTheme.primaryDark)
                      .withValues(alpha: _backgroundAnimation.value),
                  (brightness == Brightness.light
                          ? AppTheme.secondaryLight
                          : AppTheme.secondaryDark)
                      .withValues(alpha: _backgroundAnimation.value),
                  (brightness == Brightness.light
                          ? AppTheme.accentLight
                          : AppTheme.accentDark)
                      .withValues(alpha: _backgroundAnimation.value * 0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: AnimatedBuilder(
                animation: _contentAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentAnimation.value,
                    child: Column(
                      children: [
                        // Top section with countdown timer
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CountdownTimerWidget(
                                targetDate: countdownTarget,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                textStyle: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Main content area
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated logo
                              AnimatedLogo(
                                size: 30.w,
                                animationDuration:
                                    const Duration(milliseconds: 1500),
                              ),

                              SizedBox(height: 8.h),

                              // App tagline
                              Text(
                                'Accelerate Your Growth',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 2.h),

                              Text(
                                'Gamified skill development with social proof',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Bottom section with progress
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          child: Column(
                            children: [
                              // Battery progress indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BatteryProgressIndicator(
                                    progress: _initializationProgress,
                                    width: 20.w,
                                    height: 6.h,
                                    batteryColor: Colors.white,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.3),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${(_initializationProgress * 100).toInt()}%',
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h),

                              // Current task
                              Text(
                                _currentTask,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _hasError
                                      ? AppTheme.warningLight
                                      : Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              if (_hasError) ...[
                                SizedBox(height: 2.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'refresh',
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Retrying...',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
