import React from 'react';
import {View, Text, TouchableOpacity, StyleSheet} from 'react-native';
import {windowHeight} from '../../utils/Dimension';
import FontAwesome from 'react-native-vector-icons/FontAwesome5';

const GoogleSigninButton = ({buttonTitle, ...rest}) => {
  return (
    <TouchableOpacity style={styles.buttonContainer} {...rest}>
      <View style={styles.inputContainer}>
        <View style={styles.iconStyle}>
          <FontAwesome name="google" size={25} color="#666"></FontAwesome>
        </View>
        <Text style={styles.buttonText}>{buttonTitle}</Text>
      </View>
    </TouchableOpacity>
  );
};

export default GoogleSigninButton;

const styles = StyleSheet.create({
  inputContainer: {
    margin: 4.0,
    width: '100%',
    height: windowHeight / 15,
    borderRadius: 20,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  iconStyle: {
    paddingVertical: 10,
    paddingLeft: 10,
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    width: 50,
  },
  buttonContainer: {
    marginTop: 16.0,
    width: '100%',
    height: windowHeight / 15,
    padding: 10,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 20,
    borderColor: '#EDEEF1',
    borderWidth: 2,
  },
  buttonText: {
    fontSize: 17,
    fontWeight: 'bold',
    color: '#666',
  },
});
