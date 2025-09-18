import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import HapticFeedback from 'react-native-haptic-feedback';

import CustomIcon from '../components/CustomIcon';
import BatteryProgressIndicator from '../components/BatteryProgressIndicator';
import { Colors, Typography, Spacing, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const LoginScreen = () => {
  const navigation = useNavigation();
  const [isLoading, setIsLoading] = useState(false);
  const [loadingProgress, setLoadingProgress] = useState(0);
  const [errorMessage, setErrorMessage] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const mockCredentials = {
    'admin@lockin.com': 'admin123',
    'user@lockin.com': 'user123',
    'demo@lockin.com': 'demo123',
  };

  const handleLogin = async () => {
    if (!email || !password) {
      setErrorMessage('Please fill in all fields');
      return;
    }

    setIsLoading(true);
    setErrorMessage('');
    setLoadingProgress(0);

    // Simulate authentication process with battery loading
    for (let i = 0; i <= 100; i += 10) {
      await new Promise(resolve => setTimeout(resolve, 80));
      setLoadingProgress(i / 100);
    }

    // Check mock credentials
    if (mockCredentials[email.toLowerCase()] === password) {
      HapticFeedback.trigger('impactHeavy');
      
      await AsyncStorage.setItem('is_logged_in', 'true');
      await AsyncStorage.setItem('user_email', email);
      
      setIsLoading(false);
      navigation.replace('MainTabs');
    } else {
      HapticFeedback.trigger('impactMedium');
      
      setIsLoading(false);
      setLoadingProgress(0);
      setErrorMessage(getErrorMessage(email, password));
    }
  };

  const getErrorMessage = (email, password) => {
    if (!mockCredentials[email.toLowerCase()]) {
      return 'Account not found. Please check your email or create a new account.';
    } else {
      return 'Incorrect password. Please try again or reset your password.';
    }
  };

  const handleSocialLogin = async (provider) => {
    setIsLoading(true);
    setErrorMessage('');
    setLoadingProgress(0);

    // Simulate social login process
    for (let i = 0; i <= 100; i += 20) {
      await new Promise(resolve => setTimeout(resolve, 100));
      setLoadingProgress(i / 100);
    }

    HapticFeedback.trigger('impactHeavy');
    
    await AsyncStorage.setItem('is_logged_in', 'true');
    await AsyncStorage.setItem('user_email', `user@${provider}.com`);
    
    setIsLoading(false);
    navigation.replace('MainTabs');
  };

  return (
    <KeyboardAvoidingView 
      style={styles.container} 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView 
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled"
      >
        <View style={styles.content}>
          {/* Lock In Logo */}
          <View style={styles.logoContainer}>
            <CustomIcon name="lock" size={responsiveWidth(20)} color={Colors.primaryLight} />
            <Text style={[styles.logoText, Typography.headlineMedium, { color: Colors.primaryLight }]}>
              Lock In
            </Text>
          </View>

          {/* Welcome text */}
          <Text style={[styles.welcomeText, Typography.headlineMedium, { color: Colors.textPrimaryLight }]}>
            Welcome Back
          </Text>

          <Text style={[styles.subtitle, Typography.bodyLarge, { color: Colors.textSecondaryLight }]}>
            Continue your skill development journey
          </Text>

          {/* Battery Loading Widget */}
          {isLoading && (
            <View style={styles.loadingContainer}>
              <BatteryProgressIndicator
                progress={loadingProgress}
                width={responsiveWidth(30)}
                height={responsiveHeight(8)}
                batteryColor={Colors.primaryLight}
              />
            </View>
          )}

          {/* Error Message */}
          {errorMessage ? (
            <View style={styles.errorContainer}>
              <CustomIcon name="error-outline" size={20} color={Colors.warningLight} />
              <Text style={[styles.errorText, Typography.bodyMedium, { color: Colors.warningLight }]}>
                {errorMessage}
              </Text>
            </View>
          ) : null}

          {/* Login Form */}
          <View style={styles.formContainer}>
            <View style={styles.inputContainer}>
              <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                Email
              </Text>
              <TextInput
                style={[styles.input, Typography.bodyLarge]}
                placeholder="Enter your email"
                placeholderTextColor={Colors.textSecondaryLight}
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                autoCorrect={false}
                editable={!isLoading}
              />
            </View>

            <View style={styles.inputContainer}>
              <Text style={[styles.inputLabel, Typography.labelMedium, { color: Colors.textSecondaryLight }]}>
                Password
              </Text>
              <TextInput
                style={[styles.input, Typography.bodyLarge]}
                placeholder="Enter your password"
                placeholderTextColor={Colors.textSecondaryLight}
                value={password}
                onChangeText={setPassword}
                secureTextEntry
                editable={!isLoading}
              />
            </View>

            <TouchableOpacity
              style={[styles.loginButton, { opacity: isLoading ? 0.6 : 1 }]}
              onPress={handleLogin}
              disabled={isLoading}
            >
              <Text style={[styles.loginButtonText, Typography.labelLarge, { color: 'white' }]}>
                {isLoading ? 'Signing In...' : 'Sign In'}
              </Text>
            </TouchableOpacity>
          </View>

          {/* Social Login */}
          <View style={styles.socialContainer}>
            <Text style={[styles.socialText, Typography.bodyMedium, { color: Colors.textSecondaryLight }]}>
              Or continue with
            </Text>

            <View style={styles.socialButtons}>
              <TouchableOpacity
                style={[styles.socialButton, { opacity: isLoading ? 0.6 : 1 }]}
                onPress={() => handleSocialLogin('google')}
                disabled={isLoading}
              >
                <CustomIcon name="google" size={24} color={Colors.primaryLight} />
                <Text style={[styles.socialButtonText, Typography.labelMedium, { color: Colors.primaryLight }]}>
                  Google
                </Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={[styles.socialButton, { opacity: isLoading ? 0.6 : 1 }]}
                onPress={() => handleSocialLogin('apple')}
                disabled={isLoading}
              >
                <CustomIcon name="apple" size={24} color={Colors.textPrimaryLight} />
                <Text style={[styles.socialButtonText, Typography.labelMedium, { color: Colors.textPrimaryLight }]}>
                  Apple
                </Text>
              </TouchableOpacity>
            </View>
          </View>

          {/* Sign up link */}
          <View style={styles.signupContainer}>
            <Text style={[Typography.bodyMedium, { color: Colors.textSecondaryLight }]}>
              New to Lock In?{' '}
            </Text>
            <TouchableOpacity
              onPress={() => navigation.navigate('Register')}
              disabled={isLoading}
            >
              <Text style={[Typography.bodyMedium, { color: Colors.primaryLight, fontWeight: '600' }]}>
                Start Journey
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.backgroundLight,
  },
  scrollContent: {
    flexGrow: 1,
    justifyContent: 'center',
  },
  content: {
    paddingHorizontal: responsiveWidth(6),
    paddingVertical: responsiveHeight(4),
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: responsiveHeight(6),
  },
  logoText: {
    marginTop: Spacing.md,
    fontWeight: '700',
  },
  welcomeText: {
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: responsiveHeight(1),
  },
  subtitle: {
    textAlign: 'center',
    marginBottom: responsiveHeight(4),
  },
  loadingContainer: {
    alignItems: 'center',
    marginBottom: responsiveHeight(3),
  },
  errorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.warningLight + '1A',
    padding: Spacing.lg,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.warningLight + '4D',
    marginBottom: responsiveHeight(3),
  },
  errorText: {
    marginLeft: Spacing.md,
    flex: 1,
  },
  formContainer: {
    marginBottom: responsiveHeight(4),
  },
  inputContainer: {
    marginBottom: Spacing.lg,
  },
  inputLabel: {
    marginBottom: Spacing.sm,
  },
  input: {
    backgroundColor: Colors.surfaceLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    borderRadius: BorderRadius.lg,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.lg,
    color: Colors.textPrimaryLight,
  },
  loginButton: {
    backgroundColor: Colors.primaryLight,
    paddingVertical: Spacing.lg,
    borderRadius: BorderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: Spacing.md,
  },
  loginButtonText: {
    fontWeight: '600',
  },
  socialContainer: {
    alignItems: 'center',
    marginBottom: responsiveHeight(4),
  },
  socialText: {
    marginBottom: Spacing.lg,
  },
  socialButtons: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: '100%',
  },
  socialButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surfaceLight,
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.lg,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    minWidth: responsiveWidth(35),
    justifyContent: 'center',
  },
  socialButtonText: {
    marginLeft: Spacing.sm,
    fontWeight: '500',
  },
  signupContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default LoginScreen;
