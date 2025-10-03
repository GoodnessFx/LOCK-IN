import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors, Typography, BorderRadius } from '../theme/AppTheme';

// Minimal live clock. Shows local time HH:mm with subtle chip styling.
export default function LiveClock() {
  const [now, setNow] = useState(new Date());

  useEffect(() => {
    const id = setInterval(() => setNow(new Date()), 1000 * 30);
    return () => clearInterval(id);
  }, []);

  const hh = now.getHours().toString().padStart(2, '0');
  const mm = now.getMinutes().toString().padStart(2, '0');

  return (
    <View style={styles.container}>
      <Text style={[styles.text, Typography.labelMedium, { color: Colors.textPrimaryLight }]}>{`${hh}:${mm}`}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    backgroundColor: Colors.surfaceLight,
    paddingHorizontal: 12,
    paddingVertical: 6,
  },
  text: {
    fontWeight: '600',
    letterSpacing: 0.3,
  },
});


