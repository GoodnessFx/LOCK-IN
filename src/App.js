import React from 'react';
import { StatusBar, View } from 'react-native';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/MaterialIcons';

// Import screens
import SplashScreen from './screens/SplashScreen';
import LoginScreen from './screens/LoginScreen';
import DashboardHome from './screens/DashboardHome';
import ProgressTracking from './screens/ProgressTracking';
import CommunityFeed from './screens/CommunityFeed';
import LockInLearn from './screens/LockInLearn';
import UserProfile from './screens/UserProfile';

// Import theme
import { Colors } from './theme/AppTheme';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

// Bottom Tab Navigator
function BottomTabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;

          if (route.name === 'Dashboard') {
            iconName = 'home';
          } else if (route.name === 'Progress') {
            iconName = 'timeline';
          } else if (route.name === 'LOCK IN') {
            iconName = 'school';
          } else if (route.name === 'Community') {
            iconName = 'people';
          } else if (route.name === 'Profile') {
            iconName = 'person';
          }

          return <Icon name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: Colors.primaryLight,
        tabBarInactiveTintColor: Colors.textSecondaryLight,
        tabBarStyle: {
          backgroundColor: Colors.surfaceLight,
          borderTopColor: Colors.borderSubtleLight,
          borderTopWidth: 1,
          paddingBottom: 5,
          paddingTop: 5,
          height: 60,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: '500',
        },
        headerShown: false,
      })}
    >
      <Tab.Screen 
        name="Dashboard" 
        component={DashboardHome}
        options={{
          tabBarLabel: 'Home',
        }}
      />
      <Tab.Screen 
        name="Progress" 
        component={ProgressTracking}
        options={{
          tabBarLabel: 'Progress',
        }}
      />
      <Tab.Screen 
        name="LOCK IN" 
        component={LockInLearn}
        options={{
          tabBarLabel: 'LOCK IN',
        }}
      />
      <Tab.Screen 
        name="Community" 
        component={CommunityFeed}
        options={{
          tabBarLabel: 'Community',
        }}
      />
      <Tab.Screen 
        name="Profile" 
        component={UserProfile}
        options={{
          tabBarLabel: 'Profile',
        }}
      />
    </Tab.Navigator>
  );
}

// Main App Navigator
function AppNavigator() {
  return (
    <Stack.Navigator
      initialRouteName="Splash"
      screenOptions={{
        headerShown: false,
        cardStyle: { backgroundColor: Colors.backgroundLight },
      }}
    >
      <Stack.Screen name="Splash" component={SplashScreen} />
      <Stack.Screen name="Login" component={LoginScreen} />
      <Stack.Screen name="MainTabs" component={BottomTabNavigator} />
    </Stack.Navigator>
  );
}

export default function App() {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <StatusBar 
          barStyle="dark-content" 
          backgroundColor={Colors.backgroundLight}
          translucent={false}
        />
        <NavigationContainer>
          <AppNavigator />
        </NavigationContainer>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}
