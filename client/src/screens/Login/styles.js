import {StyleSheet} from 'react-native';
import {windowHeight} from '../../utils/Dimension';

const styles = StyleSheet.create({
  contentContainer: {
    justifyContent: 'flex-start',
    alignItems: 'center',
    padding: 30,
    paddingTop: 0,
  },
  logo: {
    marginTop: 30,
    height: 150,
    width: 150,
    resizeMode: 'cover',
  },
  text: {
    fontSize: 30,
    marginBottom: 20,
    marginTop: 100,
    color: '#000',
  },
  welcomeText: {
    fontSize: 20,
    color: '#666',
  },
  welcomeTextView: {
    marginBottom: 10,
    marginTop: 50,
    width: '100%',
    flexDirection: 'row',
  },
  forgotButton: {
    marginTop: 35,
  },
  navButtonText: {
    fontSize: 15,
    fontWeight: '500',
    color: '#0096C7',
    fontWeight: 'bold',
  },
  navText: {
    fontSize: 15,
    fontWeight: '500',
    color: '#000',
    fontWeight: 'bold',
  },
  textNavView: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 15,
  },
  smallCircleView: {
    width: 150,
    height: 150,
    borderRadius: 75,
    backgroundColor: '#90E0EF',
    position: 'absolute',
    left: -30,
    bottom: -100,
  },
  bigCircleView: {
    width: 300,
    height: 300,
    borderRadius: 150,
    backgroundColor: '#CAF0F8',
    position: 'absolute',
    right: -150,
    bottom: -150,
  },
  googleButton: {
    marginTop: 15,
    width: '100%',
    height: windowHeight / 15,
  },
});

export default styles;
