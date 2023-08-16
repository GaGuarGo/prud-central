import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/tabs/order_tab.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _index = 0;

  var _screens = [
    OrderTab('Pedidos', 'orders'),
    OrderTab('PedidosOvo', 'ordersE'),
    OrderTab('PedidosArroz', 'ordersR'),
  ];

  final Map<int, Widget> tabs = {
    0: Text('Dia'),
    1: Text('Ovo'),
    2: Text('Arroz'),
  };

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Pedidos',
              style: TextStyle(
                  //color: Color.fromARGB(1000, 0, 172, 193),
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            bottom: TabBar(
              physics: NeverScrollableScrollPhysics(),
              tabs: [
                Tab(
                  text: 'Almoço',
                ),
                Tab(
                  text: 'Ovo',
                ),
                Tab(
                  text: 'Arroz',
                )
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              OrderTab('Pedidos', 'orders'),
              OrderTab('PedidosOvo', 'ordersE'),
              OrderTab('PedidosArroz', 'ordersR'),
            ],
          ),
        ),
      );
    else
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            border: Border.all(color: Colors.transparent),
            middle: Container(
              width: MediaQuery.of(context).size.width,
              child: CupertinoSlidingSegmentedControl(
                groupValue: _index,
                onValueChanged: (int selectedIndex) {
                  setState(() {
                    _index = selectedIndex;
                  });
                },
                children: tabs,
              ),
            ),
          ),
          child: SafeArea(
            child: Expanded(
              child: _screens[_index],
            ),
          ));
  }
}
