import 'react-native-gesture-handler';
// Initialize optional Sentry (no-op if DSN missing)
import { initSentry } from './src/services/logging/sentry';

// Call initSentry early so errors during startup are captured if configured.
initSentry();

// Re-export the main app implemented in src/App.js
export { default } from './src/App';
