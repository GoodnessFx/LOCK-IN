import React from 'react';
import Icon from 'react-native-vector-icons/MaterialIcons';

const CustomIcon = ({ name, size = 24, color, style }) => {
  return (
    <Icon 
      name={name} 
      size={size} 
      color={color} 
      style={style}
    />
  );
};

export default CustomIcon;
