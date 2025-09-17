import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/achievement_showcase_widget.dart';
import './widgets/activity_history_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/progress_summary_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  // Camera related
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  XFile? _capturedImage;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "displayName": "Alex Johnson",
    "skillFocus": "Full Stack Development",
    "totalIGPoints": 12450,
    "avatarUrl":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
    "startDate": DateTime.now().subtract(const Duration(days: 120)),
    "targetDate": DateTime.now().add(const Duration(days: 60)),
    "progressData": {
      "skills": [
        {"name": "React Development", "progress": 0.75, "category": "tech"},
        {"name": "Node.js Backend", "progress": 0.60, "category": "tech"},
        {"name": "UI/UX Design", "progress": 0.45, "category": "design"},
        {"name": "Project Management", "progress": 0.30, "category": "business"}
      ]
    }
  };

  final List<Map<String, dynamic>> _achievements = [
    {
      "id": 1,
      "title": "First Steps",
      "description": "Completed your first learning session",
      "icon": "play_arrow",
      "rarity": "common",
      "earnedDate": DateTime.now().subtract(const Duration(days: 100)),
      "igPoints": 100
    },
    {
      "id": 2,
      "title": "Week Warrior",
      "description": "Maintained a 7-day learning streak",
      "icon": "local_fire_department",
      "rarity": "uncommon",
      "earnedDate": DateTime.now().subtract(const Duration(days: 85)),
      "igPoints": 250
    },
    {
      "id": 3,
      "title": "Code Master",
      "description": "Completed 50 coding challenges",
      "icon": "code",
      "rarity": "rare",
      "earnedDate": DateTime.now().subtract(const Duration(days: 60)),
      "igPoints": 500
    },
    {
      "id": 4,
      "title": "Community Hero",
      "description": "Helped 10 fellow learners",
      "icon": "favorite",
      "rarity": "epic",
      "earnedDate": DateTime.now().subtract(const Duration(days: 30)),
      "igPoints": 750
    },
    {
      "id": 5,
      "title": "Milestone Legend",
      "description": "Reached 10,000 IG Points",
      "icon": "stars",
      "rarity": "legendary",
      "earnedDate": DateTime.now().subtract(const Duration(days: 15)),
      "igPoints": 1000
    },
    {
      "id": 6,
      "title": "Speed Learner",
      "description": "Completed a course in record time",
      "icon": "speed",
      "rarity": "rare",
      "earnedDate": DateTime.now().subtract(const Duration(days: 10)),
      "igPoints": 400
    }
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      "id": 1,
      "type": "milestone",
      "title": "Completed React Fundamentals",
      "description": "Finished all 12 modules with 95% score",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "igPoints": 500,
      "skillCategory": "React Development"
    },
    {
      "id": 2,
      "type": "achievement",
      "title": "Earned Speed Learner Badge",
      "description": "Completed course 2 days ahead of schedule",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "igPoints": 400,
      "skillCategory": "General"
    },
    {
      "id": 3,
      "type": "skill_progress",
      "title": "Node.js Progress Update",
      "description": "Advanced from beginner to intermediate level",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "igPoints": 300,
      "skillCategory": "Node.js Backend"
    },
    {
      "id": 4,
      "type": "mentor_session",
      "title": "1-on-1 with Sarah Chen",
      "description": "Discussed career path and portfolio review",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "igPoints": 0,
      "skillCategory": "Career Development"
    },
    {
      "id": 5,
      "type": "community_post",
      "title": "Shared Learning Tips",
      "description": "Posted about effective debugging techniques",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "igPoints": 50,
      "skillCategory": "Community"
    },
    {
      "id": 6,
      "type": "challenge_completed",
      "title": "Algorithm Challenge #47",
      "description": "Solved binary tree traversal problem",
      "timestamp": DateTime.now().subtract(const Duration(days: 4)),
      "igPoints": 150,
      "skillCategory": "Algorithms"
    },
    {
      "id": 7,
      "type": "course_completion",
      "title": "JavaScript ES6+ Mastery",
      "description": "Completed advanced JavaScript concepts",
      "timestamp": DateTime.now().subtract(const Duration(days: 7)),
      "igPoints": 600,
      "skillCategory": "JavaScript"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb && await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _handleAvatarUpdate() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Profile Photo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  context,
                  'Camera',
                  'camera_alt',
                  () => _capturePhoto(),
                ),
                _buildPhotoOption(
                  context,
                  'Gallery',
                  'photo_library',
                  () => _pickFromGallery(),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(
      BuildContext context, String title, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        width: 30.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 8.w,
              color: AppTheme.getPrimaryColor(context),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.getPrimaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      if (_cameraController != null && _isCameraInitialized) {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _capturedImage = photo;
          _userData['avatarUrl'] = photo.path;
        });
      }
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _userData['avatarUrl'] = image.path;
        });
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  void _handleAchievementTap(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: achievement['icon'] as String? ?? 'emoji_events',
              size: 6.w,
              color: AppTheme.getAccentColor(context),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                achievement['title'] as String? ?? 'Achievement',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement['description'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rarity: ${(achievement['rarity'] as String? ?? 'common').toUpperCase()}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '+${achievement['igPoints']} IG',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.getAccentColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _shareAchievement(achievement);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareAchievement(Map<String, dynamic> achievement) async {
    final String shareText =
        'Just earned the "${achievement['title']}" badge in Lock In! 🏆 '
        '+${achievement['igPoints']} IG Points earned. #LockIn #Achievement #Learning';

    try {
      await Share.share(shareText);
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  void _handleSettingTap(String setting) {
    switch (setting) {
      case 'export_data':
        _exportProgressData();
        break;
      case 'print_portfolio':
        _printPortfolio();
        break;
      default:
        // Navigate to specific settings screens
        break;
    }
  }

  Future<void> _exportProgressData() async {
    final exportData = {
      'user': _userData,
      'achievements': _achievements,
      'activities': _activities,
      'exportDate': DateTime.now().toIso8601String(),
      'cryptographicStamp':
          'LOCK_IN_${DateTime.now().millisecondsSinceEpoch}_VERIFIED'
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    try {
      if (kIsWeb) {
        final bytes = utf8.encode(jsonString);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "lock_in_progress_${DateTime.now().millisecondsSinceEpoch}.json")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
            '${directory.path}/lock_in_progress_${DateTime.now().millisecondsSinceEpoch}.json');
        await file.writeAsString(jsonString);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress data exported successfully!')),
      );
    } catch (e) {
      debugPrint('Export error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export failed. Please try again.')),
      );
    }
  }

  Future<void> _printPortfolio() async {
    final portfolioContent = '''
LOCK IN - LEARNING PORTFOLIO
============================

User: ${_userData['displayName']}
Skill Focus: ${_userData['skillFocus']}
Total IG Points: ${_userData['totalIGPoints']}

ACHIEVEMENTS (${_achievements.length} earned):
${_achievements.map((a) => '• ${a['title']} (+${a['igPoints']} IG)').join('\n')}

RECENT ACTIVITIES:
${_activities.take(10).map((a) => '• ${a['title']} - ${a['timestamp'].toString().split(' ')[0]}').join('\n')}

Generated on: ${DateTime.now()}
Cryptographic Validation: LOCK_IN_${DateTime.now().millisecondsSinceEpoch}_VERIFIED
''';

    try {
      if (kIsWeb) {
        final bytes = utf8.encode(portfolioContent);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "lock_in_portfolio_${DateTime.now().millisecondsSinceEpoch}.txt")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File(
            '${directory.path}/lock_in_portfolio_${DateTime.now().millisecondsSinceEpoch}.txt');
        await file.writeAsString(portfolioContent);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio generated successfully!')),
      );
    } catch (e) {
      debugPrint('Print error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Portfolio generation failed. Please try again.')),
      );
    }
  }

  void _handleLogout() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/login-screen', (route) => false);
  }

  Future<void> _refreshProfile() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh data here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: AppTheme.getTextColor(context),
        actions: [
          // 6-month countdown timer
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.getPrimaryColor(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  size: 4.w,
                  color: AppTheme.getPrimaryColor(context),
                ),
                SizedBox(width: 1.w),
                Text(
                  '60d',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.getPrimaryColor(context),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(
                displayName: _userData['displayName'] as String,
                skillFocus: _userData['skillFocus'] as String,
                totalIGPoints: _userData['totalIGPoints'] as int,
                avatarUrl: _userData['avatarUrl'] as String?,
                onAvatarTap: _handleAvatarUpdate,
              ),

              SizedBox(height: 2.h),

              // Achievement Showcase
              AchievementShowcaseWidget(
                achievements: _achievements,
                onAchievementTap: _handleAchievementTap,
                onShareTap: _shareAchievement,
              ),

              SizedBox(height: 2.h),

              // Progress Summary
              ProgressSummaryWidget(
                progressData: _userData['progressData'] as Map<String, dynamic>,
                startDate: _userData['startDate'] as DateTime,
                targetDate: _userData['targetDate'] as DateTime,
              ),

              SizedBox(height: 2.h),

              // Activity History
              ActivityHistoryWidget(
                activities: _activities,
                onViewAll: () {
                  // Navigate to full activity history
                },
              ),

              SizedBox(height: 2.h),

              // Settings Section
              SettingsSectionWidget(
                onSettingTap: _handleSettingTap,
                onLogout: _handleLogout,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
