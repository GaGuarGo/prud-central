import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/screens/home_screen_ios.dart';
import 'package:prud_central/screens/login_screen.dart';
import 'package:prud_central/screens/perfil_screen.dart';
import 'package:prud_central/screens/lunch_screen.dart';
import 'package:prud_central/screens/orders_screen.dart';
import 'package:prud_central/screens/menu_screen.dart';
import 'package:prud_central/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  var isExtended = false;

  List<Widget> screens = [
    LunchScreen(),
    OrderScreen(),
    MenuScreen(),
    ChatScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return Scaffold(
        body: SafeArea(
          child: Container(
              child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: NavigationRail(
                  groupAlignment: 0.0,
                  extended: isExtended,
                  minWidth: MediaQuery.of(context).size.width * 0.16,
                  minExtendedWidth: MediaQuery.of(context).size.width * 0.5,
                  selectedIndex: _selectedIndex,
                  elevation: 20,
                  backgroundColor: Colors.white,
                  leading: Column(
                    children: [
                      Container(
                        child: Center(
                            child: IconButton(
                          icon: Icon(
                            isExtended == false
                                ? Icons.menu_rounded
                                : Icons.close,
                            color: isExtended == false
                                ? Colors.grey
                                : Colors.blueGrey,
                            size: 25,
                          ),
                          onPressed: () {
                            setState(() {
                              isExtended = !isExtended;
                            });
                          },
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: Firestore.instance
                            .collection('users')
                            .document(UserModel.of(context).firebaseUser.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else if (snapshot.data['foto'] == null) {
                            return Image.asset(
                              'assets/user.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            );
                          } else
                            return ClipOval(
                                child: Image.network(
                              '${snapshot.data['foto']}',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ));
                        },
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          size: 30,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          UserModel().signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ],
                  ),
                  selectedIconTheme:
                      IconThemeData(color: Colors.blueGrey, size: 30),
                  unselectedIconTheme:
                      IconThemeData(color: Colors.grey, size: 25),
                  selectedLabelTextStyle: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  unselectedLabelTextStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.none,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.dinner_dining),
                      selectedIcon: Icon(Icons.dinner_dining),
                      label: Text('Almoço'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_outlined),
                      selectedIcon: Icon(Icons.menu),
                      label: Text('Pedidos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.restaurant_menu_outlined),
                      selectedIcon: Icon(Icons.restaurant_menu),
                      label: Text('Cardápio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.message_outlined),
                      selectedIcon: Icon(Icons.message),
                      label: Text('Contate-nos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Perfil'),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 0.5,
              ),
              Expanded(
                  //width: MediaQuery.of(context).size.width * 0.83,
                  child: screens[_selectedIndex]),
            ],
          )),
        ),
      );
    else
      return HomeScreenIos();
  }
}
