module.exports = {
  presets: ['babel-preset-expo'],
  plugins: [
    '@babel/plugin-transform-export-namespace-from',
    ['@babel/plugin-transform-private-methods', { loose: true }],
    ['@babel/plugin-transform-class-properties', { loose: true }],
    'react-native-reanimated/plugin',
  ],
};
