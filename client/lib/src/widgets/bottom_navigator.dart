import 'package:client/src/constants/constants.dart';
import 'package:client/src/screens/cart_screen.dart';
import 'package:client/src/screens/favorite_screen.dart';
import 'package:client/src/screens/home_screen.dart';
import 'package:client/src/screens/profile_screen.dart';
import 'package:flutter/material.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
