import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/order/order_event.dart';
import '../blocs/order/order_state.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_state.dart';
import '../blocs/user_claim/user_claim_bloc.dart';
import '../blocs/user_claim/user_claim_event.dart';
import '../blocs/user_claim/user_claim_state.dart';
import '../config/app_constants.dart';
import '../constants/constants.dart';
import '../models/user.dart';
import '../widgets/order_item.dart';
import './change_password_screen.dart';
import './edit_address_book_screen.dart';
import './edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    context
        .read<UserClaimBloc>()
        .add(UserClaimRequested(userId: widget.userId));
    context.read<OrderBloc>().add(OrderRequested(userId: widget.userId));

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.95),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: AssetImage('assets/images/app_logo_no_bg.png'),
                width: 24,
                height: 24,
              ),
              Text(
                'My Profile',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsConstant.primaryColor,
                    ),
              ),
              InkWell(
                  onTap: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLoggedOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNames.login, (route) => false);
                  },
                  child: Icon(Icons.logout, color: Colors.black))
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<UserClaimBloc>()
                .add(UserClaimRequested(userId: widget.userId));
            context
                .read<OrderBloc>()
                .add(OrderRequested(userId: widget.userId));
          },
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    BlocBuilder<UserClaimBloc, UserClaimState>(
                      builder: (context, state) {
                        if (state is UserClaimLoadSuccess) {
                          UserClaim userClaim = state.userClaim!;
                          return Padding(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(0, 3)),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 100 / 2),
                                  child: Stack(children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          16.0, 16.0 + 100 / 2, 16.0, 16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(state.userClaim!.displayName,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorsConstant
                                                          .primaryColor)),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          BlocBuilder<OrderBloc, OrderState>(
                                            builder: (context, state) {
                                              if (state is OrderLoadSuccess) {
                                                return IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Orders',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                          Text(
                                                            state.orderList!
                                                                .length
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: ColorsConstant
                                                                      .primaryColor,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      VerticalDivider(
                                                        color: Colors.grey,
                                                        width: 2,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Pending',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                          Text(
                                                            state.orderList!
                                                                .where((e) =>
                                                                    e.shippingStatus ==
                                                                    1)
                                                                .length
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: ColorsConstant
                                                                      .primaryColor,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              return SizedBox(
                                                height: 0,
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            openSettingOptions(context);
                                          },
                                          icon: Icon(Icons.settings)),
                                    )
                                  ]),
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 5.0),
                                      )
                                    ],
                                  ),
                                  child: BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (context, state) {
                                      if (state is ProfileInitial) {
                                        return CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    userClaim.avatarUrl));
                                      }
                                      if (state is ProfileUpdateSuccess) {
                                        if (state.avatarUrl != null) {
                                          return CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      state.avatarUrl!));
                                        } else {
                                          return CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      userClaim.avatarUrl));
                                        }
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text("My Orders",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: ColorsConstant.primaryColor)),
                        BlocBuilder<OrderBloc, OrderState>(
                          builder: (context, state) {
                            if (state is OrderLoadInProgress) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is OrderLoadSuccess) {
                              if (state.orderList!.length == 0) {
                                return Center(
                                  child: Text('You don\'t have any orders'),
                                );
                              }
                              return ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return OrderItem(
                                        order:
                                            state.orderList!.elementAt(index));
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  shrinkWrap: true,
                                  itemCount: state.orderList!.length);
                            }
                            return Center(
                              child: Text(
                                  'Oops!!! We have some errors, please check your internet and try again'),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openSettingOptions(BuildContext parentContext) {
    return showModalBottomSheet(
        context: parentContext,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 285,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Account Settings',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorsConstant.primaryColor,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => EditProfileScreen(
                                    userId: widget.userId,
                                  )));
                        },
                        child: Text(
                          'My Profile',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => EditAddressBookScreen(
                                    userId: widget.userId,
                                  )));
                        },
                        child: Text(
                          'My Address List',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChangePasswordScreen(
                                    userId: widget.userId,
                                  )));
                        },
                        child: Text(
                          'Change Password',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
