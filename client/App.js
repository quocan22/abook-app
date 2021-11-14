import React from 'react';
import {StatusBar, View} from 'react-native';
import LoginScreen from './src/screens/Login';

const App = () => {
  return (
    <>
      <StatusBar barStyle="light-content" />
      <LoginScreen></LoginScreen>
    </>
  );
};

export default App;
