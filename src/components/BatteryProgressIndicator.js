import React, { useEffect, useRef } from 'react';
import { View, Animated, StyleSheet } from 'react-native';
import Svg, { Rect, Defs, LinearGradient, Stop } from 'react-native-svg';
import { Colors, BorderRadius, responsiveWidth, responsiveHeight } from '../theme/AppTheme';

const BatteryProgressIndicator = ({ 
  progress = 0, 
  width = 120, 
  height = 60, 
  batteryColor = Colors.secondaryLight,
  backgroundColor = Colors.borderSubtleLight,
  animated = true 
}) => {
  const animatedProgress = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (animated) {
      Animated.timing(animatedProgress, {
        toValue: progress,
        duration: 1500,
        useNativeDriver: false,
      }).start();
    } else {
      animatedProgress.setValue(progress);
    }
  }, [progress, animated, animatedProgress]);

  const getFillColor = (progressValue) => {
    if (progressValue < 0.3) return Colors.warningLight;
    if (progressValue < 0.7) return Colors.accentLight;
    return batteryColor;
  };

  return (
    <View style={[styles.container, { width, height }]}>
      <Svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}>
        <Defs>
          <LinearGradient id="batteryGradient" x1="0%" y1="0%" x2="100%" y2="0%">
            <Stop offset="0%" stopColor={getFillColor(progress)} stopOpacity="0.8" />
            <Stop offset="100%" stopColor={getFillColor(progress)} stopOpacity="0.4" />
          </LinearGradient>
        </Defs>
        
        {/* Battery outline */}
        <Rect
          x="0"
          y={height * 0.2}
          width={width * 0.85}
          height={height * 0.6}
          rx={height * 0.1}
          ry={height * 0.1}
          fill="none"
          stroke={backgroundColor}
          strokeWidth="2"
        />
        
        {/* Battery tip */}
        <Rect
          x={width * 0.85}
          y={height * 0.35}
          width={width * 0.15}
          height={height * 0.3}
          rx={height * 0.05}
          ry={height * 0.05}
          fill="none"
          stroke={backgroundColor}
          strokeWidth="2"
        />
        
        {/* Battery fill */}
        {progress > 0 && (
          <Animated.View>
            <Rect
              x="4"
              y={height * 0.2 + 4}
              width={(width * 0.85 - 8) * progress}
              height={height * 0.6 - 8}
              rx={height * 0.08}
              ry={height * 0.08}
              fill="url(#batteryGradient)"
            />
          </Animated.View>
        )}
      </Svg>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default BatteryProgressIndicator;
