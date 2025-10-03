// Optional Sentry setup. Import and call initSentry() in app entry if SENTRY_DSN exists.

import * as Sentry from '@sentry/react-native';
import { getEnv, isProd } from '../../utils/env';

export function initSentry() {
  const dsn = getEnv('SENTRY_DSN', '');
  if (!dsn) return;

  Sentry.init({
    dsn,
    tracesSampleRate: isProd() ? 0.2 : 1.0,
    enableAutoSessionTracking: true,
    debug: !isProd(),
  });
}

export default Sentry;


