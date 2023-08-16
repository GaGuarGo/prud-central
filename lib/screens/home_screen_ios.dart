import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/screens/chat_screen.dart';
import 'package:prud_central/screens/login_screen.dart';
import 'package:prud_central/screens/lunch_screen.dart';
import 'package:prud_central/screens/menu_screen.dart';
import 'package:prud_central/screens/orders_screen.dart';
import 'package:prud_central/screens/perfil_screen.dart';

class HomeScreenIos extends StatefulWidget {
  @override
  _HomeScreenIosState createState() => _HomeScreenIosState();
}

class _HomeScreenIosState extends State<HomeScreenIos> {
  @override
  Widget build(BuildContext context) {
    int _index = 0;

    List<Widget> list = [
      LunchScreen(),
      OrderScreen(),
      MenuScreen(),
      ChatScreen(),
      PerfilScreen(),
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          border: Border.all(color: Colors.transparent),
          leading: Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () async {
                UserModel().signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(
                CupertinoIcons.square_arrow_left,
                color: Colors.blue,
              ),
            ),
          ),
          middle: Text("PrudCentral",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          trailing: Icon(Icons.info_outlined, color: Colors.blue)),
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            border: Border.all(color: Colors.transparent),
            iconSize: 30,
            backgroundColor: Colors.grey[200],
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.grey,
            currentIndex: _index,
            onTap: (int index) {
              setState(() {
                _index = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                  icon: Icon(Icons.dinner_dining),
                  // ignore: deprecated_member_use
                  title: Text('Almoço')),
              BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                  icon: Icon(CupertinoIcons.list_bullet),
                  // ignore: deprecated_member_use
                  title: Text('Pedidos')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  // ignore: deprecated_member_use
                  title: Text('Cardápio')),
              BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                  icon: Icon(CupertinoIcons.chat_bubble_text),
                  // ignore: deprecated_member_use
                  title: Text('Mensagens')),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_alt_circle),
                  // ignore: deprecated_member_use
                  title: Text('Perfil')),
            ],
          ),
          tabBuilder: (context, index) => Container(
            width: MediaQuery.of(context).size.width,
                child: list[index],
              )),
    );
  }
}
