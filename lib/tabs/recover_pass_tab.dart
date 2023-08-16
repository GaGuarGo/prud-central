import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/classes/size_config.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class PassAlert extends StatefulWidget {
  @override
  _PassAlertState createState() => _PassAlertState();
}

class _PassAlertState extends State<PassAlert> {
  final _email = TextEditingController();
  bool done = false;
  bool error = false;
  bool isLoading = false;

  _onSuccess() async {
    _email.clear();
    setState(() {
      done = true;
    });
    Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        done = false;
      });
    });
  }

  _onFail() {
    setState(() {
      error = true;
    });
    Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        error = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (Platform.isAndroid) {
      return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (isLoading == true)
            return Container(
              child: Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : CupertinoActivityIndicator(),
              ),
            );
          else
            return AlertDialog(
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.redAccent,
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      UserModel().recoverPass(
                          email: _email.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail);

                      setState(() {
                        isLoading = false;
                      });
                    },
                    color: Colors.blueAccent,
                    child: Text(
                      'Enviar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                title: done == true
                    ? Container(
                        padding: EdgeInsets.only(top: 2, bottom: 2, left: 3),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.green,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Email enviado com sucesso! ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : error == true
                        ? Container(
                            padding:
                                EdgeInsets.only(top: 2, bottom: 2, left: 3),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.red),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Falha ao enviar email! ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : Wrap(children: [
                            Text(
                              'Digite seu email para reuparar sua senha: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: 'Digite seu email',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightBlueAccent),
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ],
                ));
        },
      );
    } else {
      return CupertinoAlertDialog(
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              UserModel().recoverPass(
                email: _email.text,
                onSuccess: _onSuccess,
                onFail: _onFail,
              );
            },
            child: Text(
              'Enviar',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          )
        ],
        title: done == true
            ? Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 3),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Email enviado com sucesso! ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : error == true
                ? Container(
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 3),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Falha ao enviar email! ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Wrap(children: [
                    Text(
                      'Digite seu email para reuparar sua senha: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CupertinoTextField(
            controller: _email,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]),
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        ),
      );
    }
  }
}
