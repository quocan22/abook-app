import 'package:client/src/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../screens/cart_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigator createState() => _BottomNavigator();
}

class _BottomNavigator extends State<BottomNavigator> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  Future<void> _onItemTapped(int index) async {
    if (index != 0) {
      bool isLoggedIn = await _checkLogin();
      if (isLoggedIn) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        _showLoginDialog();
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<bool> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _showLoginDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You need to login before using this feature'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to Login'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNames.login, (route) => false);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled,
                  color: _selectedIndex == 0
                      ? ColorsConstant.activeTabButton
                      : ColorsConstant.inactiveTabButton),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _selectedIndex == 1
                      ? ColorsConstant.activeTabButton
                      : ColorsConstant.inactiveTabButton),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart,
                  color: _selectedIndex == 2
                      ? ColorsConstant.activeTabButton
                      : ColorsConstant.inactiveTabButton),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _selectedIndex == 3
                      ? ColorsConstant.activeTabButton
                      : ColorsConstant.inactiveTabButton),
              label: '')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
