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

const ForgotPassword = () => {
  const [email, setEmail] = useState();

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
        <View style={styles.titleView}>
          <Text style={styles.title}>Forgot Password?</Text>
        </View>
        <View style={styles.contentView}>
          <Text style={styles.content}>
            Enter your email address associated with your account
          </Text>
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
        <FormButton
          buttonTitle="Send"
          onPress={() => {
            if (!email || !password) {
              return;
            }
            //SignUp(email, password);
          }}
        />
      </ScrollView>
    </SafeAreaView>
  );
};

export default ForgotPassword;
