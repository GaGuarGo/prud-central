import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/models/user_model.dart';

// ignore: must_be_immutable
class MessageWidget extends StatelessWidget {
  String messageId;
  MessageWidget(this.messageId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('messages')
          .document(messageId)
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
          return Container(
            margin: EdgeInsets.only(left: 8, top: 2, bottom: 2),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: snapshot.data['nome'] != "PrudCentral"
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data['message'],
                  style: TextStyle(
                      color: snapshot.data['nome'] != "PrudCentral"
                          ? Colors.white
                          : Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  snapshot.data['nome'] != "PrudCentral"
                      ? 'Enviada - ${UserModel.of(context).userData['nome']} '
                      : 'Enviada - PrudCentral',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
      },
    );
  }
}
