const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
const defaultConfig = getDefaultConfig(__dirname);

defaultConfig.resolver = {
    ...defaultConfig.resolver,
    extraNodeModules: {
        ...(defaultConfig.resolver ? defaultConfig.resolver.extraNodeModules : {}),
        'react-native-linear-gradient': path.resolve(__dirname, 'src/shims/react-native-linear-gradient'),
        'react-native-fast-image': path.resolve(__dirname, 'src/shims/react-native-fast-image'),
        'react-native-haptic-feedback': path.resolve(__dirname, 'src/shims/react-native-haptic-feedback'),
    },
};

module.exports = defaultConfig;
