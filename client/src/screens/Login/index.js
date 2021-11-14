import React, {useState} from 'react';
import {
  Image,
  SafeAreaView,
  ScrollView,
  StatusBar,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import FormButton from '../../components/utils/FormButton';
import FormInput from '../../components/utils/FormInput';
import {GoogleSignin} from '@react-native-google-signin/google-signin';
import styles from './styles';
import GoogleSigninButton from '../../components/utils/GoogleSigninButton';

const LoginScreen = () => {
  const [email, setEmail] = useState();
  const [password, setPassword] = useState();

  return (
    <SafeAreaView style={{height: '100%', backgroundColor: '#fff'}}>
      <StatusBar
        backgroundColor={'transparent'}
        barStyle="dark-content"
        translucent
      />

      <View style={styles.smallCircleView}></View>
      <View style={styles.bigCircleView}></View>

      <ScrollView contentContainerStyle={styles.contentContainer}>
        <Image
          style={styles.logo}
          source={require('../../../assets/images/LogoNonBG.png')}
        />
        <View style={styles.welcomeTextView}>
          <Text style={styles.welcomeText}>Welcome!</Text>
        </View>
        <FormInput
          labelValue={email}
          onChangeText={userEmail => setEmail(userEmail)}
          placeholderText="Email"
          iconType="envelope"
          keyboardType="email-address"
          autoCapitalize="none"
          autoCorrect={false}
        />
        <FormInput
          labelValue={password}
          onChangeText={userPass => setPassword(userPass)}
          placeholderText="Password"
          iconType="lock"
          secureTextEntry
        />
        <FormButton
          buttonTitle="Login"
          onPress={() => {
            if (!email || !password) {
              return;
            }
            //login(email, password);
          }}
        />

        <TouchableOpacity style={styles.forgotButton} onPress={() => {}}>
          <Text style={styles.navButtonText}>Forgot password?</Text>
        </TouchableOpacity>

        <GoogleSigninButton
          buttonTitle="Sign In with Google"
          onPress={() => {
            if (!email || !password) {
              return;
            }
            //login(email, password);
          }}
        />

        <View style={styles.textNavView}>
          <Text style={styles.navText}>Don't have an account? </Text>
          <TouchableOpacity onPress={() => {}}>
            <Text style={styles.navButtonText}>Sign Up</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default LoginScreen;
