import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/tabs/chat_tab.dart';
import 'package:prud_central/widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _sendMessage({String text}) {
    Map<String, dynamic> mssg = {
      "nome": UserModel.of(context).userData['nome'],
      "hora": Timestamp.now(),
      'message': text
    };

    UserModel.of(context).message(
      mssg: mssg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(UserModel.of(context).firebaseUser.uid)
                  .collection('messages')
                  .orderBy('hora')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ));
                else
                  return ListView(
                      reverse: true,
                      children: snapshot.data.documents
                          .map((doc) => MessageWidget(doc.documentID))
                          .toList()
                          .reversed
                          .toList());
              },
            ),
          ),
          SizedBox(
            height: 4,
          ),
          MessageInput(_sendMessage),
        ],
      ),
    );
  }
}
