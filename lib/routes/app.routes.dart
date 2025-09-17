import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/progress_tracking/progress_tracking.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/community_feed/community_feed.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String userProfile = '/user-profile';
  static const String login = '/login-screen';
  static const String progressTracking = '/progress-tracking';
  static const String dashboardHome = '/dashboard-home';
  static const String communityFeed = '/community-feed';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    progressTracking: (context) => const ProgressTracking(),
    dashboardHome: (context) => const DashboardHome(),
    communityFeed: (context) => const CommunityFeed(),
    // TODO: Add your other routes here
  };
}
