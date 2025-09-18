import { StyleSheet, Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window');

// Responsive dimensions helper (equivalent to sizer package)
export const responsiveWidth = (percentage) => (width * percentage) / 100;
export const responsiveHeight = (percentage) => (height * percentage) / 100;
export const responsiveFontSize = (size) => (width * size) / 100;

// Focused Growth Palette - Color specifications
export const Colors = {
  // Light theme colors
  primaryLight: '#2563EB', // Deep blue for trust and focus
  secondaryLight: '#10B981', // Growth green for progress indicators
  accentLight: '#F59E0B', // Achievement amber for milestones
  backgroundLight: '#FAFAFA', // Soft white reducing harsh contrast
  surfaceLight: '#FFFFFF', // Pure white for content cards
  textPrimaryLight: '#111827', // Near-black for optimal readability
  textSecondaryLight: '#6B7280', // Medium gray for supporting text
  borderSubtleLight: '#E5E7EB', // Light gray for necessary divisions
  successLight: '#059669', // Deeper green for confirmation states
  warningLight: '#DC2626', // Clear red for important alerts

  // Dark theme colors
  primaryDark: '#3B82F6', // Lighter blue for dark backgrounds
  secondaryDark: '#34D399', // Brighter green for dark mode
  accentDark: '#FBBF24', // Brighter amber for dark visibility
  backgroundDark: '#0F172A', // Deep dark blue-gray
  surfaceDark: '#1E293B', // Elevated surface color
  textPrimaryDark: '#F8FAFC', // Near-white for readability
  textSecondaryDark: '#94A3B8', // Light gray for supporting text
  borderSubtleDark: '#334155', // Subtle borders for dark mode
  successDark: '#10B981', // Consistent success green
  warningDark: '#EF4444', // Bright red for dark mode alerts

  // Shadow colors
  shadowLight: 'rgba(0, 0, 0, 0.05)',
  shadowMediumLight: 'rgba(0, 0, 0, 0.10)',
  shadowStrongLight: 'rgba(0, 0, 0, 0.15)',
  shadowDark: 'rgba(255, 255, 255, 0.10)',
  shadowMediumDark: 'rgba(255, 255, 255, 0.20)',
  shadowStrongDark: 'rgba(255, 255, 255, 0.30)',

  // Common colors
  white: '#FFFFFF',
  black: '#000000',
  transparent: 'transparent',
};

// Typography styles using Inter font family
export const Typography = {
  // Display styles for large headings
  displayLarge: {
    fontSize: responsiveFontSize(14.25), // 57px equivalent
    fontWeight: '700',
    lineHeight: responsiveFontSize(16), // 1.12
    letterSpacing: -0.25,
  },
  displayMedium: {
    fontSize: responsiveFontSize(11.25), // 45px equivalent
    fontWeight: '700',
    lineHeight: responsiveFontSize(13), // 1.16
    letterSpacing: 0,
  },
  displaySmall: {
    fontSize: responsiveFontSize(9), // 36px equivalent
    fontWeight: '600',
    lineHeight: responsiveFontSize(11), // 1.22
    letterSpacing: 0,
  },

  // Headline styles for section headers
  headlineLarge: {
    fontSize: responsiveFontSize(8), // 32px equivalent
    fontWeight: '600',
    lineHeight: responsiveFontSize(10), // 1.25
    letterSpacing: 0,
  },
  headlineMedium: {
    fontSize: responsiveFontSize(7), // 28px equivalent
    fontWeight: '600',
    lineHeight: responsiveFontSize(9), // 1.29
    letterSpacing: 0,
  },
  headlineSmall: {
    fontSize: responsiveFontSize(6), // 24px equivalent
    fontWeight: '600',
    lineHeight: responsiveFontSize(8), // 1.33
    letterSpacing: 0,
  },

  // Title styles for cards and components
  titleLarge: {
    fontSize: responsiveFontSize(5.5), // 22px equivalent
    fontWeight: '500',
    lineHeight: responsiveFontSize(7), // 1.27
    letterSpacing: 0,
  },
  titleMedium: {
    fontSize: responsiveFontSize(4), // 16px equivalent
    fontWeight: '500',
    lineHeight: responsiveFontSize(6), // 1.50
    letterSpacing: 0.15,
  },
  titleSmall: {
    fontSize: responsiveFontSize(3.5), // 14px equivalent
    fontWeight: '500',
    lineHeight: responsiveFontSize(5), // 1.43
    letterSpacing: 0.1,
  },

  // Body text for main content
  bodyLarge: {
    fontSize: responsiveFontSize(4), // 16px equivalent
    fontWeight: '400',
    lineHeight: responsiveFontSize(6), // 1.50
    letterSpacing: 0.5,
  },
  bodyMedium: {
    fontSize: responsiveFontSize(3.5), // 14px equivalent
    fontWeight: '400',
    lineHeight: responsiveFontSize(5), // 1.43
    letterSpacing: 0.25,
  },
  bodySmall: {
    fontSize: responsiveFontSize(3), // 12px equivalent
    fontWeight: '400',
    lineHeight: responsiveFontSize(4), // 1.33
    letterSpacing: 0.4,
  },

  // Label styles for buttons and form elements
  labelLarge: {
    fontSize: responsiveFontSize(3.5), // 14px equivalent
    fontWeight: '500',
    lineHeight: responsiveFontSize(5), // 1.43
    letterSpacing: 0.1,
  },
  labelMedium: {
    fontSize: responsiveFontSize(3), // 12px equivalent
    fontWeight: '500',
    lineHeight: responsiveFontSize(4), // 1.33
    letterSpacing: 0.5,
  },
  labelSmall: {
    fontSize: responsiveFontSize(2.75), // 11px equivalent
    fontWeight: '500',
    lineHeight: responsiveFontSize(4), // 1.45
    letterSpacing: 0.5,
  },
};

// Spacing system
export const Spacing = {
  xs: responsiveHeight(0.5), // 4px
  sm: responsiveHeight(1), // 8px
  md: responsiveHeight(1.5), // 12px
  lg: responsiveHeight(2), // 16px
  xl: responsiveHeight(2.5), // 20px
  xxl: responsiveHeight(3), // 24px
  xxxl: responsiveHeight(4), // 32px
};

// Border radius system
export const BorderRadius = {
  sm: responsiveWidth(1), // 4px
  md: responsiveWidth(2), // 8px
  lg: responsiveWidth(3), // 12px
  xl: responsiveWidth(4), // 16px
  xxl: responsiveWidth(5), // 20px
  round: responsiveWidth(50), // 50% for circular
};

// Shadow styles
export const Shadows = {
  light: {
    shadowColor: Colors.shadowLight,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 1,
    shadowRadius: 4,
    elevation: 2,
  },
  medium: {
    shadowColor: Colors.shadowMediumLight,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 1,
    shadowRadius: 8,
    elevation: 4,
  },
  strong: {
    shadowColor: Colors.shadowStrongLight,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 1,
    shadowRadius: 16,
    elevation: 8,
  },
};

// Light theme styles
export const LightTheme = {
  colors: {
    primary: Colors.primaryLight,
    secondary: Colors.secondaryLight,
    accent: Colors.accentLight,
    background: Colors.backgroundLight,
    surface: Colors.surfaceLight,
    text: Colors.textPrimaryLight,
    textSecondary: Colors.textSecondaryLight,
    border: Colors.borderSubtleLight,
    success: Colors.successLight,
    warning: Colors.warningLight,
    error: Colors.warningLight,
  },
  typography: Typography,
  spacing: Spacing,
  borderRadius: BorderRadius,
  shadows: Shadows,
};

// Dark theme styles
export const DarkTheme = {
  colors: {
    primary: Colors.primaryDark,
    secondary: Colors.secondaryDark,
    accent: Colors.accentDark,
    background: Colors.backgroundDark,
    surface: Colors.surfaceDark,
    text: Colors.textPrimaryDark,
    textSecondary: Colors.textSecondaryDark,
    border: Colors.borderSubtleDark,
    success: Colors.successDark,
    warning: Colors.warningDark,
    error: Colors.warningDark,
  },
  typography: Typography,
  spacing: Spacing,
  borderRadius: BorderRadius,
  shadows: {
    light: {
      shadowColor: Colors.shadowDark,
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 1,
      shadowRadius: 4,
      elevation: 2,
    },
    medium: {
      shadowColor: Colors.shadowMediumDark,
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 1,
      shadowRadius: 8,
      elevation: 4,
    },
    strong: {
      shadowColor: Colors.shadowStrongDark,
      shadowOffset: { width: 0, height: 8 },
      shadowOpacity: 1,
      shadowRadius: 16,
      elevation: 8,
    },
  },
};

// Common styles
export const CommonStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.backgroundLight,
  },
  containerDark: {
    flex: 1,
    backgroundColor: Colors.backgroundDark,
  },
  centerContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rowSpaceBetween: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  column: {
    flexDirection: 'column',
  },
  card: {
    backgroundColor: Colors.surfaceLight,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    ...Shadows.medium,
  },
  cardDark: {
    backgroundColor: Colors.surfaceDark,
    borderRadius: BorderRadius.lg,
    padding: Spacing.lg,
    ...Shadows.medium,
  },
  button: {
    backgroundColor: Colors.primaryLight,
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.md,
    borderRadius: BorderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonDark: {
    backgroundColor: Colors.primaryDark,
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.md,
    borderRadius: BorderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
  },
  input: {
    backgroundColor: Colors.surfaceLight,
    borderWidth: 1,
    borderColor: Colors.borderSubtleLight,
    borderRadius: BorderRadius.lg,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.lg,
    fontSize: Typography.bodyLarge.fontSize,
    color: Colors.textPrimaryLight,
  },
  inputDark: {
    backgroundColor: Colors.surfaceDark,
    borderWidth: 1,
    borderColor: Colors.borderSubtleDark,
    borderRadius: BorderRadius.lg,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.lg,
    fontSize: Typography.bodyLarge.fontSize,
    color: Colors.textPrimaryDark,
  },
});

export default LightTheme;
