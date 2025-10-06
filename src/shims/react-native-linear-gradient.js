import React from 'react';
import { Platform, View } from 'react-native';

// For native platforms, prefer the native package if it's installed.
// For web (or when the native package would call requireNativeComponent), use expo-linear-gradient.
let LinearGradient;
try {
  if (Platform.OS === 'web') {
    // Use expo-linear-gradient's web implementation if available
    // eslint-disable-next-line global-require
    const { LinearGradient: ExpoLinearGradient } = require('expo-linear-gradient');
    LinearGradient = ExpoLinearGradient;
  } else {
    // On native, attempt to use react-native-linear-gradient if present; otherwise fallback to expo-linear-gradient
    try {
      // eslint-disable-next-line global-require
      const RNLinearGradient = require('react-native-linear-gradient/dist/index.js').default;
      LinearGradient = RNLinearGradient;
    } catch (e) {
      // eslint-disable-next-line global-require
      const { LinearGradient: ExpoLinearGradient } = require('expo-linear-gradient');
      LinearGradient = ExpoLinearGradient;
    }
  }
} catch (err) {
  // Final fallback: simple View to avoid requireNativeComponent errors.
  // eslint-disable-next-line react/display-name
  LinearGradient = ({ children, style }) => <View style={style}>{children}</View>;
}

export default LinearGradient;
export { LinearGradient as LinearGradientComponent };