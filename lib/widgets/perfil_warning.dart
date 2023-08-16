import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/models/user_model.dart';

class PerfilDialog extends StatefulWidget {
  final File imgFile;
  PerfilDialog({this.imgFile});

  @override
  _PerfilDialogState createState() => _PerfilDialogState();
}

class _PerfilDialogState extends State<PerfilDialog> {
  bool loading = false;
  String _url;
  bool done = false;

  Future<void> _savePhoto() async {
    if (widget.imgFile != null) {
      setState(() {
        loading = true;
      });
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(widget.imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _url = url;
      });

      Map<String, dynamic> data = {'foto': _url};

      await Firestore.instance
          .collection('users')
          .document(UserModel.of(context).firebaseUser.uid)
          .updateData(data)
          .then((_) {
        setState(() {
          loading = false;
          done = true;
        });
      });
    } else {
      setState(() {
        _url = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return AlertDialog(
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
          RaisedButton(
            color: Colors.blueAccent,
            onPressed: _savePhoto,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Text('Salvar',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
        title: Wrap(children: [
          Text(
            'Voce realmente deseja trocar sua foto de Perfil?',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ]),
        content: done == false
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: loading == false
                          ? ClipOval(
                              child: Image.file(widget.imgFile,
                                  height: 80, width: 80, fit: BoxFit.cover),
                            )
                          : CircularProgressIndicator()),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Icon(
                    Icons.check_box,
                    size: 60,
                    color: Colors.green,
                  ))
                ],
              ),
      );
    else
      return CupertinoAlertDialog(
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Fechar',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
          CupertinoDialogAction(
            onPressed: _savePhoto,
            child: Text(
              'Salvar',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          )
        ],
        title: Wrap(children: [
          Text(
            'Voce realmente deseja trocar sua foto de Perfil?',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ]),
        content: done == false
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: loading == false
                            ? ClipOval(
                                child: Image.file(widget.imgFile,
                                    height: 80, width: 80, fit: BoxFit.cover),
                              )
                            : CupertinoActivityIndicator()),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Icon(
                    CupertinoIcons.check_mark,
                    size: 60,
                    color: Colors.green,
                  ))
                ],
              ),
      );
  }
}
