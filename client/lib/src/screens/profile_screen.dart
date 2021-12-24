import 'package:client/src/config/app_constants.dart';
import 'package:client/src/constants/constants.dart';
import 'package:client/src/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsConstant.primaryColor,
                ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNames.login, (route) => false),
                icon: Icon(Icons.logout_rounded, color: Colors.black))
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text("LaggeR",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsConstant.primaryColor)),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Orders',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            Text(
                                              '10',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
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
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Pending',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            Text(
                                              '1',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorsConstant
                                                        .primaryColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EditProfileScreen()));
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
                          child: const CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1617975251517-b90ff061b52e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                      ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Container(
                                padding: const EdgeInsets.all(8.0),
                                height: 100,
                                child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            'https://images.unsplash.com/photo-1621351183012-e2f9972dd9bf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJvb2slMjBjb3ZlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'The two towers',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            Text(
                                              'Tolkien',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '250 000 VNĐ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          shrinkWrap: true,
                          itemCount: 30)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
