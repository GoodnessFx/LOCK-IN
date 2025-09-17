import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/battery_loading_widget.dart';
import './widgets/lock_in_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';
import 'widgets/battery_loading_widget.dart';
import 'widgets/lock_in_logo_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  double _loadingProgress = 0.0;
  String _errorMessage = '';

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@lockin.com': 'admin123',
    'user@lockin.com': 'user123',
    'demo@lockin.com': 'demo123',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),

                    // Lock In Logo with gamified styling
                    LockInLogoWidget(),

                    SizedBox(height: 6.h),

                    // Welcome text
                    Text(
                      'Welcome Back',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Continue your skill development journey',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Battery Loading Widget
                    BatteryLoadingWidget(
                      isVisible: _isLoading,
                      progress: _loadingProgress,
                    ),

                    if (_isLoading) SizedBox(height: 3.h),

                    // Error Message
                    if (_errorMessage.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 3.h),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.warningLight.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'error_outline',
                              color: AppTheme.warningLight,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.warningLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Social Login
                    SocialLoginWidget(
                      onSocialLogin: _handleSocialLogin,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New to Lock In? ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, '/register-screen');
                                },
                          child: Text(
                            'Start Journey',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _loadingProgress = 0.0;
    });

    // Simulate authentication process with battery loading
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 80));
      if (mounted) {
        setState(() {
          _loadingProgress = i / 100.0;
        });
      }
    }

    // Check mock credentials
    if (_mockCredentials.containsKey(email.toLowerCase()) &&
        _mockCredentials[email.toLowerCase()] == password) {
      // Success
      HapticFeedback.heavyImpact();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard-home');
      }
    } else {
      // Error
      HapticFeedback.vibrate();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingProgress = 0.0;
          _errorMessage = _getErrorMessage(email, password);
        });
      }
    }
  }

  String _getErrorMessage(String email, String password) {
    if (!_mockCredentials.containsKey(email.toLowerCase())) {
      return 'Account not found. Please check your email or create a new account.';
    } else {
      return 'Incorrect password. Please try again or reset your password.';
    }
  }

  void _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _loadingProgress = 0.0;
    });

    // Simulate social login process
    for (int i = 0; i <= 100; i += 20) {
      await Future.delayed(Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _loadingProgress = i / 100.0;
        });
      }
    }

    // Simulate successful social login
    HapticFeedback.heavyImpact();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard-home');
    }
  }
}