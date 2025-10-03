import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors, Typography, Spacing, BorderRadius } from '../theme/AppTheme';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, info) {
    // Hook for Sentry or custom logger
    if (this.props.onError) {
      this.props.onError(error, info);
    }
  }

  render() {
    if (this.state.hasError) {
      return (
        <View style={styles.container}>
          <Text style={[styles.title, Typography.titleMedium, { color: Colors.textPrimaryLight }]}>Something went wrong</Text>
          <Text style={[styles.subtitle, Typography.bodySmall, { color: Colors.textSecondaryLight }]}>Please restart the app. The issue has been reported.</Text>
        </View>
      );
    }
    return this.props.children;
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.backgroundLight,
    alignItems: 'center',
    justifyContent: 'center',
    padding: Spacing.lg,
  },
  title: {
    fontWeight: '700',
    marginBottom: Spacing.sm,
  },
  subtitle: {
    textAlign: 'center',
  },
});

export default ErrorBoundary;


