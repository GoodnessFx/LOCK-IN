import React from 'react';
import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { DarkTheme, Colors, Typography, BorderRadius, Spacing } from '../theme/AppTheme';

const LockmateComingSoon = () => {
  const isDarkMode = useColorScheme() === 'dark';
  const theme = isDarkMode ? DarkTheme : { colors: Colors };

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <View style={styles.card}>
        <Text style={[Typography.headlineSmall, { color: theme.colors.text, textAlign: 'center' }]}>LOCKMATE</Text>
        <Text style={[Typography.titleMedium, { color: theme.colors.textSecondary, textAlign: 'center', marginTop: Spacing.sm }]}>Coming Soon</Text>
        <Text style={[Typography.bodyMedium, { color: theme.colors.textSecondary, textAlign: 'center', marginTop: Spacing.lg }]}>An AI study partner that motivates, plans, and checks in. Stay tuned.</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  card: {
    backgroundColor: Colors.surfaceDark,
    borderRadius: BorderRadius.xl,
    padding: Spacing.xxl,
    width: '85%',
  },
});

export default LockmateComingSoon;


