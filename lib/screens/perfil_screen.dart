import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/classes/size_config.dart';
import 'package:prud_central/tabs/perfil_tab.dart';

import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/widgets/perfil_button.dart';
import 'package:scoped_model/scoped_model.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
      onRefresh: () async {
        UserModel.of(context).loadCurrentUser();
      },
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator());
          else
            return Scaffold(
              floatingActionButton: PerfilButton(),
              backgroundColor: Colors.blueGrey,
              body: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection('users')
                          .document(UserModel.of(context).firebaseUser.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: Platform.isAndroid
                                  ? CircularProgressIndicator()
                                  : CupertinoActivityIndicator());
                        else if (snapshot.data['foto'] == null) {
                          return Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 70),
                            child: ClipOval(
                                child: Image.asset('assets/user.png',
                                    height: SizeConfig.blockSizeVertical * 28,
                                    width: SizeConfig.safeBlockHorizontal * 50,
                                    fit: BoxFit.cover)),
                          );
                        } else
                          return Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 70),
                            child: ClipOval(
                                child: Image.network(snapshot.data['foto'],
                                    height: SizeConfig.blockSizeVertical * 28,
                                    width: SizeConfig.safeBlockHorizontal * 50,
                                    fit: BoxFit.cover)),
                          );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: DraggableScrollableSheet(
                            initialChildSize: 0.62,
                            minChildSize: 0.62,
                            maxChildSize: 0.9,
                            builder: (context, scrollController) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: PerfilTab(model: model)),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
