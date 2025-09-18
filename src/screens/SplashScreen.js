import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Animated,
  Dimensions,
  StatusBar,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useNavigation } from '@react-navigation/native';

import CustomIcon from '../components/CustomIcon';
import BatteryProgressIndicator from '../components/BatteryProgressIndicator';
import CountdownTimer from '../components/CountdownTimer';
import { Colors, Typography, Spacing, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const { width, height } = Dimensions.get('window');

const SplashScreen = () => {
  const navigation = useNavigation();
  const [initializationProgress, setInitializationProgress] = useState(0);
  const [currentTask, setCurrentTask] = useState('Initializing...');
  const [hasError, setHasError] = useState(false);

  const backgroundAnim = useRef(new Animated.Value(0)).current;
  const contentAnim = useRef(new Animated.Value(0)).current;

  const initializationTasks = [
    { task: 'Checking authentication...', duration: 800 },
    { task: 'Loading user preferences...', duration: 600 },
    { task: 'Syncing IG points...', duration: 700 },
    { task: 'Fetching progress stamps...', duration: 500 },
    { task: 'Preparing community data...', duration: 400 },
    { task: 'Ready to lock in!', duration: 300 },
  ];

  useEffect(() => {
    startAnimations();
    startInitialization();
  }, []);

  const startAnimations = () => {
    Animated.timing(backgroundAnim, {
      toValue: 1,
      duration: 2000,
      useNativeDriver: false,
    }).start();

    setTimeout(() => {
      Animated.timing(contentAnim, {
        toValue: 1,
        duration: 1500,
        useNativeDriver: false,
      }).start();
    }, 500);
  };

  const startInitialization = async () => {
    try {
      const progressStep = 1.0 / initializationTasks.length;

      for (let i = 0; i < initializationTasks.length; i++) {
        const task = initializationTasks[i];
        
        setCurrentTask(task.task);
        setInitializationProgress((i + 1) * progressStep);

        await new Promise(resolve => setTimeout(resolve, task.duration));
        await performInitializationTask(i);
      }

      await new Promise(resolve => setTimeout(resolve, 500));
      await navigateToNextScreen();
    } catch (error) {
      setHasError(true);
      setCurrentTask('Initialization failed. Retrying...');
      
      setTimeout(() => {
        startInitialization();
      }, 2000);
    }
  };

  const performInitializationTask = async (taskIndex) => {
    switch (taskIndex) {
      case 0:
        await checkAuthenticationStatus();
        break;
      case 1:
        await loadUserPreferences();
        break;
      case 2:
        await syncIGPoints();
        break;
      case 3:
        await fetchProgressStamps();
        break;
      case 4:
        await prepareCommunityData();
        break;
      case 5:
        await finalSetup();
        break;
    }
  };

  const checkAuthenticationStatus = async () => {
    const isLoggedIn = await AsyncStorage.getItem('is_logged_in');
    const hasCompletedOnboarding = await AsyncStorage.getItem('completed_onboarding');
    
    await AsyncStorage.setItem(
      'should_show_dashboard',
      (isLoggedIn === 'true' && hasCompletedOnboarding === 'true').toString()
    );
  };

  const loadUserPreferences = async () => {
    const selectedSkills = await AsyncStorage.getItem('selected_skills') || '["Technology"]';
    const preferredDifficulty = await AsyncStorage.getItem('preferred_difficulty') || 'Intermediate';
    const notificationsEnabled = await AsyncStorage.getItem('notifications_enabled') || 'true';

    await AsyncStorage.setItem('cached_skills', selectedSkills);
    await AsyncStorage.setItem('cached_difficulty', preferredDifficulty);
    await AsyncStorage.setItem('cached_notifications', notificationsEnabled);
  };

  const syncIGPoints = async () => {
    const currentPoints = await AsyncStorage.getItem('ig_points') || '0';
    const lastSyncTime = await AsyncStorage.getItem('last_sync_time') || '0';
    const now = Date.now();

    if (now - parseInt(lastSyncTime) > 86400000) {
      const newPoints = parseInt(currentPoints) + 50;
      await AsyncStorage.setItem('ig_points', newPoints.toString());
    }

    await AsyncStorage.setItem('last_sync_time', now.toString());
  };

  const fetchProgressStamps = async () => {
    const stamps = await AsyncStorage.getItem('progress_stamps') || '[]';
    const mockStamp = {
      timestamp: Date.now(),
      activity: 'app_launch',
      hash: `mock_crypto_hash_${Date.now()}`,
    };

    const stampsArray = JSON.parse(stamps);
    stampsArray.push(mockStamp);
    await AsyncStorage.setItem('progress_stamps', JSON.stringify(stampsArray));
  };

  const prepareCommunityData = async () => {
    const communityData = {
      active_users: 15420,
      daily_challenges: 3,
      trending_skills: ['Flutter', 'AI/ML', 'Cooking', 'Photography'],
      featured_mentors: 12,
    };

    await AsyncStorage.setItem('cached_community_data', JSON.stringify(communityData));
  };

  const finalSetup = async () => {
    await AsyncStorage.setItem('last_launch_time', Date.now().toString());
    
    const countdownTarget = await AsyncStorage.getItem('countdown_target');
    if (!countdownTarget) {
      const sixMonthsFromNow = new Date();
      sixMonthsFromNow.setDate(sixMonthsFromNow.getDate() + 180);
      await AsyncStorage.setItem('countdown_target', sixMonthsFromNow.getTime().toString());
    }
  };

  const navigateToNextScreen = async () => {
    const shouldShowDashboard = await AsyncStorage.getItem('should_show_dashboard');
    const hasCompletedOnboarding = await AsyncStorage.getItem('completed_onboarding');

    if (shouldShowDashboard === 'true') {
      navigation.replace('MainTabs');
    } else if (hasCompletedOnboarding !== 'true') {
      navigation.replace('Login');
    } else {
      navigation.replace('Login');
    }
  };

  const countdownTarget = new Date();
  countdownTarget.setDate(countdownTarget.getDate() + 180);

  return (
    <View style={styles.container}>
      <StatusBar hidden />
      <Animated.View style={[styles.background, { opacity: backgroundAnim }]}>
        <LinearGradient
          colors={[
            Colors.primaryLight + 'FF',
            Colors.secondaryLight + 'FF',
            Colors.accentLight + 'CC',
          ]}
          style={styles.gradient}
        >
          <Animated.View style={[styles.content, { opacity: contentAnim }]}>
            {/* Top section with countdown timer */}
            <View style={styles.topSection}>
              <CountdownTimer
                targetDate={countdownTarget}
                backgroundColor="rgba(255, 255, 255, 0.2)"
                textStyle={[Typography.labelSmall, { color: 'white', fontWeight: '600' }]}
              />
            </View>

            {/* Main content area */}
            <View style={styles.mainContent}>
              {/* Animated logo */}
              <View style={styles.logoContainer}>
                <CustomIcon name="lock" size={responsiveWidth(30)} color="white" />
              </View>

              <Text style={[styles.tagline, Typography.headlineSmall, { color: 'white' }]}>
                Accelerate Your Growth
              </Text>

              <Text style={[styles.subtitle, Typography.bodyMedium, { color: 'rgba(255, 255, 255, 0.8)' }]}>
                Gamified skill development with social proof
              </Text>
            </View>

            {/* Bottom section with progress */}
            <View style={styles.bottomSection}>
              <View style={styles.progressContainer}>
                <BatteryProgressIndicator
                  progress={initializationProgress}
                  width={responsiveWidth(20)}
                  height={responsiveHeight(6)}
                  batteryColor="white"
                  backgroundColor="rgba(255, 255, 255, 0.3)"
                />
                <Text style={[styles.progressText, Typography.labelMedium, { color: 'white' }]}>
                  {Math.round(initializationProgress * 100)}%
                </Text>
              </View>

              <Text style={[
                styles.taskText,
                Typography.bodySmall,
                { 
                  color: hasError ? Colors.warningLight : 'rgba(255, 255, 255, 0.8)',
                  textAlign: 'center'
                }
              ]}>
                {currentTask}
              </Text>

              {hasError && (
                <View style={styles.errorContainer}>
                  <CustomIcon name="refresh" size={16} color="white" />
                  <Text style={[styles.retryText, Typography.labelSmall, { color: 'white' }]}>
                    Retrying...
                  </Text>
                </View>
              )}
            </View>
          </Animated.View>
        </LinearGradient>
      </Animated.View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  background: {
    flex: 1,
  },
  gradient: {
    flex: 1,
  },
  content: {
    flex: 1,
    paddingHorizontal: responsiveWidth(5),
    paddingVertical: responsiveHeight(2),
  },
  topSection: {
    alignItems: 'flex-end',
    paddingTop: responsiveHeight(2),
  },
  mainContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  logoContainer: {
    marginBottom: responsiveHeight(8),
  },
  tagline: {
    fontWeight: '600',
    letterSpacing: 0.5,
    textAlign: 'center',
    marginBottom: responsiveHeight(2),
  },
  subtitle: {
    fontWeight: '400',
    textAlign: 'center',
  },
  bottomSection: {
    paddingHorizontal: responsiveWidth(8),
    paddingVertical: responsiveHeight(4),
  },
  progressContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: responsiveHeight(2),
  },
  progressText: {
    marginLeft: responsiveWidth(4),
    fontWeight: '600',
  },
  taskText: {
    fontWeight: '400',
    marginBottom: responsiveHeight(2),
  },
  errorContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  retryText: {
    marginLeft: 8,
    fontWeight: '500',
  },
});

export default SplashScreen;
