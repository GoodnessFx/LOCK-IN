import React from 'react';
import { Image } from 'react-native';

const priorities = { low: 'low', normal: 'normal', high: 'high' };
const resizeModes = { contain: 'contain', cover: 'cover', stretch: 'stretch', center: 'center' };

const FastImageShim = ({ source, resizeMode = 'cover', style, ...rest }) => {
  const resolved = typeof source === 'object' ? source : { uri: source };
  return <Image source={resolved} resizeMode={resizeMode} style={style} {...rest} />;
};

FastImageShim.resizeMode = resizeModes;
FastImageShim.priority = priorities;

export default FastImageShim;

