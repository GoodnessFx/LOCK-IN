// Minimal AppNavigator shim kept for compatibility.
// Some parts of the codebase may import this path; provide a harmless default
// export to avoid runtime 'undefined' errors.
import React from 'react';
import { View } from 'react-native';

export default function AppNavigatorShim() {
	return <View />;
}
