import React from 'react';
import LottieView from 'lottie-react-native';
import { View, StyleSheet } from 'react-native';

// Supply a door animation JSON at assets/door.json or pass source via props
export default function DoorLottie({ source, autoPlay = true, loop = false, style }) {
  if (!source) {
    // Gracefully render nothing if no animation is provided
    return <View style={[styles.container, style]} />;
  }
  return (
    <View style={[styles.container, style]}>
      <LottieView source={source} autoPlay={autoPlay} loop={loop} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: '100%',
  },
});


