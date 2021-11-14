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
  title: {
    fontSize: 20,
    color: '#000',
    fontWeight: 'bold',
  },
  titleView: {
    marginBottom: 10,
    marginTop: 50,
    width: '100%',
    flexDirection: 'row',
  },
  content: {
    fontSize: 17,
    color: '#666',
  },
  contentView: {
    marginBottom: 10,
    width: '100%',
    flexDirection: 'row',
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
