import 'react-native-gesture-handler';
import 'react-native-reanimated';
import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';
import { initSentry } from './src/services/logging/sentry';

// Initialize optional Sentry (no-op if DSN missing)
initSentry();

AppRegistry.registerComponent(appName, () => App);
