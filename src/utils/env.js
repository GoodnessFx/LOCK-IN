// Environment helpers with .env support via process.env. If using bare RN, use babel-plugin-inline-dotenv or react-native-config.

export function getEnv(key, fallback = undefined) {
  const value = process?.env?.[key];
  return value !== undefined ? value : fallback;
}

export function getNodeEnv() {
  return process?.env?.NODE_ENV || 'development';
}

export function isDev() {
  const env = getNodeEnv();
  return env === 'development';
}

export function isProd() {
  const env = getNodeEnv();
  return env === 'production';
}


