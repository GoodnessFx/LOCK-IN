import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { Colors, Typography, BorderRadius, DarkTheme } from '../theme/AppTheme';

// Minimal live clock. Shows local time HH:mm with subtle chip styling.
export default function LiveClock() {
  const [now, setNow] = useState(new Date());
  const isDarkMode = useColorScheme() === 'dark';
  const theme = isDarkMode ? DarkTheme : { colors: Colors };

  useEffect(() => {
    const id = setInterval(() => setNow(new Date()), 1000 * 30);
    return () => clearInterval(id);
  }, []);

  const hh = now.getHours().toString().padStart(2, '0');
  const mm = now.getMinutes().toString().padStart(2, '0');

  return (
    <View style={[styles.container, { 
      backgroundColor: theme.colors.surface,
      borderColor: theme.colors.border 
    }]}>
      <Text style={[styles.text, Typography.labelMedium, { color: theme.colors.text }]}>{`${hh}:${mm}`}</Text>
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


