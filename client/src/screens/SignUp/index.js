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
import styles from './styles';

const SignUpScreen = () => {
  const [email, setEmail] = useState();
  const [password, setPassword] = useState();
  const [repeatPassword, setRepeatPassword] = useState();

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
        <View style={styles.startTextView}>
          <Text style={styles.startText}>Let's Get Start!</Text>
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
        <FormInput
          labelValue={repeatPassword}
          onChangeText={userPass => setRepeatPassword(userPass)}
          placeholderText="Repeat Password"
          iconType="lock"
          secureTextEntry
        />
        <FormButton
          buttonTitle="Sign Up"
          onPress={() => {
            if (!email || !password) {
              return;
            }
            //SignUp(email, password);
          }}
        />
        <View style={styles.textNavView}>
          <Text style={styles.navText}>Already have an account? </Text>
          <TouchableOpacity onPress={() => {}}>
            <Text style={styles.navButtonText}>Login</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default SignUpScreen;
