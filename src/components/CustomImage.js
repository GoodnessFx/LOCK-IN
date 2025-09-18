import React from 'react';
import { View } from 'react-native';
import FastImage from 'react-native-fast-image';

const CustomImage = ({ 
  source, 
  width = 60, 
  height = 60, 
  style, 
  resizeMode = 'cover',
  fallbackSource = 'https://images.unsplash.com/photo-1584824486509-112e4181ff6b?q=80&w=2940&auto=format&fit=crop'
}) => {
  return (
    <FastImage
      source={{ 
        uri: source || fallbackSource,
        priority: FastImage.priority.normal,
      }}
      style={[{ width, height }, style]}
      resizeMode={FastImage.resizeMode[resizeMode] || FastImage.resizeMode.cover}
      fallback
    />
  );
};

export default CustomImage;
