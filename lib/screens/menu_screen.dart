import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance.collection('Cardápio').document('menus').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (Platform.isAndroid)
            return Center(child: CircularProgressIndicator());
          else
            return Center(child: CupertinoActivityIndicator());
        } else
          return SafeArea(
            child: InteractiveViewer(
              panEnabled: false,
              boundaryMargin: EdgeInsets.all(80),
              minScale: 1.0,
              maxScale: 4,
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.network(snapshot.data['url1'],
                            fit: BoxFit.fitHeight),
                      ),
                      Container(
                        child: Image.network(snapshot.data['url2'],
                            fit: BoxFit.fitHeight),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}
