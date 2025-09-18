import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, Animated } from 'react-native';
import CustomIcon from './CustomIcon';
import { Colors, Typography, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const CountdownTimer = ({ 
  targetDate, 
  textStyle, 
  backgroundColor, 
  padding,
  onComplete 
}) => {
  const [timeRemaining, setTimeRemaining] = useState({ days: 0, hours: 0, minutes: 0, seconds: 0 });
  const pulseAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    const updateTimer = () => {
      const now = new Date();
      const difference = targetDate.getTime() - now.getTime();

      if (difference > 0) {
        const days = Math.floor(difference / (1000 * 60 * 60 * 24));
        const hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((difference % (1000 * 60)) / 1000);

        setTimeRemaining({ days, hours, minutes, seconds });
      } else {
        setTimeRemaining({ days: 0, hours: 0, minutes: 0, seconds: 0 });
        if (onComplete) onComplete();
      }
    };

    updateTimer();
    const interval = setInterval(updateTimer, 1000);

    // Pulse animation
    const pulseAnimation = Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, {
          toValue: 1.1,
          duration: 1000,
          useNativeDriver: true,
        }),
        Animated.timing(pulseAnim, {
          toValue: 1.0,
          duration: 1000,
          useNativeDriver: true,
        }),
      ])
    );
    pulseAnimation.start();

    return () => {
      clearInterval(interval);
      pulseAnimation.stop();
    };
  }, [targetDate, onComplete, pulseAnim]);

  const formatDuration = () => {
    if (timeRemaining.days > 0) {
      return `${timeRemaining.days}d ${timeRemaining.hours}h`;
    } else if (timeRemaining.hours > 0) {
      return `${timeRemaining.hours}h ${timeRemaining.minutes}m`;
    } else if (timeRemaining.minutes > 0) {
      return `${timeRemaining.minutes}m ${timeRemaining.seconds}s`;
    } else {
      return `${timeRemaining.seconds}s`;
    }
  };

  return (
    <Animated.View style={[styles.container, { transform: [{ scale: pulseAnim }] }]}>
      <View style={[
        styles.timerContainer,
        { 
          backgroundColor: backgroundColor || Colors.accentLight + '1A',
          paddingHorizontal: (padding && padding.horizontal) || 12,
          paddingVertical: (padding && padding.vertical) || 6
        }
      ]}>
        <CustomIcon 
          name="timer" 
          size={16} 
          color={Colors.accentLight} 
        />
        <Text style={[
          styles.timerText,
          textStyle || {
            ...Typography.labelMedium,
            color: Colors.accentLight,
            fontWeight: '600',
            letterSpacing: 0.5,
          }
        ]}>
          {formatDuration()}
        </Text>
      </View>
    </Animated.View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  timerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.accentLight,
  },
  timerText: {
    marginLeft: 6,
  },
});

export default CountdownTimer;
