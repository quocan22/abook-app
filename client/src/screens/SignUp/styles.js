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
  startText: {
    fontSize: 20,
    color: '#000',
    fontWeight: 'bold',
  },
  startTextView: {
    marginBottom: 10,
    marginTop: 50,
    width: '100%',
    flexDirection: 'row',
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
});

export default styles;
