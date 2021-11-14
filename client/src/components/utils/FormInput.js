import React from 'react';
import {View, TextInput, StyleSheet} from 'react-native';
import {windowHeight, windowWidth} from '../../utils/Dimension';

import FontAwesome, {FA5Style} from 'react-native-vector-icons/FontAwesome5';

const FormInput = ({labelValue, placeholderText, iconType, ...rest}) => {
  return (
    <View style={styles.inputContainer}>
      <View style={styles.iconStyle}>
        <FontAwesome
          name={iconType}
          solid
          size={25}
          color="#0096C7"></FontAwesome>
      </View>
      <TextInput
        value={labelValue}
        style={styles.input}
        numberOfLines={1}
        placeholder={placeholderText}
        placeholderTextColor="#666"
        {...rest}
      />
    </View>
  );
};

export default FormInput;

const styles = StyleSheet.create({
  inputContainer: {
    margin: 4.0,
    width: '100%',
    height: windowHeight / 15,
    borderRadius: 20,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#EDEEF1',
  },
  iconStyle: {
    paddingLeft: 10,
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    width: 50,
  },
  input: {
    padding: 10,
    flex: 1,
    fontSize: 17,
    color: '#666',
    justifyContent: 'center',
    alignItems: 'center',
  },
  inputField: {
    padding: 10,
    margin: 8.0,
    fontSize: 16,
    borderRadius: 8,
    borderWidth: 1,
  },
});
