import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../config/app_constants.dart';
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
  var _selectedIndex;
  late List<Widget> _pages;
  late PageController _pageController;
  String? userId;

  @override
  void initState() {
    super.initState();
    _pages = [HomeScreen()];
    _selectedIndex = 0;
    _updateScreensList();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  _updateScreensList() async {
    await _checkLogin();
    setState(() {
      _pages = [
        HomeScreen(),
        FavoriteScreen(
          userId: userId.toString(),
        ),
        CartScreen(
          userId: userId.toString(),
        ),
        ProfileScreen(
          userId: userId.toString(),
        )
      ];
    });
  }

  Future<void> _onItemTapped(int index) async {
    if (index != 0) {
      bool isLoggedIn = await _checkLogin();
      if (isLoggedIn) {
        setState(() {
          _selectedIndex = index;
          if (userId == null || userId.toString().isEmpty) {
            if (index == 1) {
              _pages[index] = FavoriteScreen(
                userId: userId.toString(),
              );
            } else if (index == 2) {
              _pages[index] = CartScreen(
                userId: userId.toString(),
              );
            } else if (index == 3) {
              _pages[index] = ProfileScreen(
                userId: userId.toString(),
              );
            }
          }
          _pageController.jumpToPage(index);
        });
      } else {
        _showLoginDialog();
      }
    } else {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  Future<bool> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token == null) {
      return false;
    } else {
      userId = prefs.getString('id');
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
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
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
              icon: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoadSuccess) {
                    if (state.cartDetailList!.isNotEmpty) {
                      return Badge(
                        animationType: BadgeAnimationType.scale,
                        badgeContent: Text(
                          state.cartDetailList!.length.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        badgeColor: Colors.redAccent,
                        child: Icon(Icons.shopping_cart,
                            color: _selectedIndex == 2
                                ? ColorsConstant.activeTabButton
                                : ColorsConstant.inactiveTabButton),
                      );
                    } else {
                      return Icon(Icons.shopping_cart,
                          color: _selectedIndex == 2
                              ? ColorsConstant.activeTabButton
                              : ColorsConstant.inactiveTabButton);
                    }
                  } else {
                    return Icon(Icons.shopping_cart,
                        color: _selectedIndex == 2
                            ? ColorsConstant.activeTabButton
                            : ColorsConstant.inactiveTabButton);
                  }
                },
              ),
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
