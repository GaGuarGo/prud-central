import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/widgets/order_widget.dart';

// ignore: must_be_immutable
class OrderTab extends StatefulWidget {
  final String category;
  final String type;
  OrderTab(this.category, this.type);

  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                      colors: [
                    Color.fromARGB(500, 0, 191, 165),
                    Colors.lightBlueAccent
                  ])),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(UserModel.of(context).firebaseUser.uid)
                  .collection(widget.type)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : CupertinoActivityIndicator());
                else
                  return ListView(
                    children: snapshot.data.documents
                        .map((doc) =>
                            OrderWidget(doc.documentID, widget.category, widget.type))
                        .toList(),
                  );
              },
            ),
          ],
        ),
      );
    else
      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                      colors: [
                    Color.fromARGB(500, 0, 191, 165),
                    Colors.lightBlueAccent
                  ])),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(UserModel.of(context).firebaseUser.uid)
                  .collection(widget.type)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : CupertinoActivityIndicator());
                else
                  return ListView(
                    children: snapshot.data.documents
                        .map((doc) =>
                            OrderWidget(doc.documentID, widget.category, widget.type))
                        .toList(),
                  );
              },
            ),
          ],
        ),
      );
  }
}
