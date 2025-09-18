 Lock In 

A gamified skill development app with React Native, featuring progress tracking, community features, and achievement systems.

 Features

- 🎮 Gamified Experience: Battery progress indicators, achievement badges, and point systems
- 📊 Progress Tracking: Detailed progress logging with categories and time tracking
- 👥 Community Feed: Share progress, get inspired, and connect with other learners
- 🏆 Achievement System: Unlock badges and track your learning milestones
- 🎨 Beautiful UI: Modern design with smooth animations and responsive layouts
- 🌙 Dark Mode Support: Toggle between light and dark themes
- 📱 Cross-Platform: Runs on both iOS and Android

## Screenshots

The app includes the following main screens:
- **Splash Screen**: Animated loading with battery progress indicator
- **Login Screen**: Beautiful authentication with progress tracking
- **Dashboard**: Home screen with progress overview, achievements, and quick actions
- **Progress Tracking**: Detailed progress logging and skill development tracking
- **Community Feed**: Social features for sharing and discovering content
- **User Profile**: Personal stats, achievements, and settings

## Installation

### Prerequisites

- Node.js (v18+ recommended)
- React Native CLI
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lock-in-react-native
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **iOS Setup** (macOS only)
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Run the app**
   
   For Android:
   ```bash
   npm run android
   ```
   
   For iOS:
   ```bash
   npm run ios
   ```

## Project Structure

```
src/
├── components/           # Reusable UI components
│   ├── BatteryProgressIndicator.js
│   ├── CountdownTimer.js
│   ├── CustomIcon.js
│   └── CustomImage.js
├── screens/             # Main app screens
│   ├── SplashScreen.js
│   ├── LoginScreen.js
│   ├── DashboardHome.js
│   ├── ProgressTracking.js
│   ├── CommunityFeed.js
│   └── UserProfile.js
├── theme/               # App theming and styling
│   └── AppTheme.js
└── App.js              # Main app component
```

## Key Dependencies

- **Navigation**: `@react-navigation/native`, `@react-navigation/stack`, `@react-navigation/bottom-tabs`
- **State Management**: `redux`, `react-redux`, `@reduxjs/toolkit`
- **Storage**: `@react-native-async-storage/async-storage`
- **Networking**: `axios`
- **Animations**: `react-native-reanimated`, `react-native-gesture-handler`
- **Icons**: `react-native-vector-icons`
- **Images**: `react-native-fast-image`
- **SVG**: `react-native-svg`
- **Gradients**: `react-native-linear-gradient`
- **Haptic Feedback**: `react-native-haptic-feedback`
- **Network Info**: `@react-native-community/netinfo`

## Features Converted from Flutter

### UI Components
- ✅ Battery progress indicators with smooth animations
- ✅ Countdown timers with pulsing effects
- ✅ Custom icons and images with fallbacks
- ✅ Responsive design using percentage-based dimensions
- ✅ Beautiful gradients and shadows
- ✅ Modal overlays and bottom sheets

### Navigation
- ✅ Stack navigation for main app flow
- ✅ Bottom tab navigation for main sections
- ✅ Smooth transitions and animations

### State Management
- ✅ Local state management with React hooks
- ✅ AsyncStorage for persistent data
- ✅ Context API ready for global state

### Animations
- ✅ Smooth progress animations
- ✅ Pulsing effects for timers
- ✅ Fade and slide transitions
- ✅ Haptic feedback integration

## Customization

### Theming
The app uses a comprehensive theming system in `src/theme/AppTheme.js`:
- Color palettes for light and dark modes
- Typography scales
- Spacing and border radius constants
- Responsive dimension helpers
- Shadow definitions

### Adding New Features
1. Create new components in `src/components/`
2. Add new screens in `src/screens/`
3. Update navigation in `src/App.js`
4. Add new dependencies to `package.json`

## Building for Production

### Android
```bash
npm run build:android
```

### iOS
```bash
npm run build:ios
```

## Troubleshooting

### Common Issues

1. **Metro bundler issues**
   ```bash
   npx react-native start --reset-cache
   ```

2. **iOS build issues**
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. **Android build issues**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   ```

### Performance Optimization

- Images are optimized using `react-native-fast-image`
- Animations use native drivers where possible
- Lists are optimized with proper key props
- Memory management with proper cleanup

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on both iOS and Android
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Acknowledgments

- Converted from the original Flutter implementation
- UI/UX design inspired by modern mobile app patterns
- Icons from Material Design
- Images from Unsplash

## Support

For support and questions, please open an issue in the repository.
