import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalSheet extends StatefulWidget {
  final Function pickPhoto;
  final Function pickGallery;

  ModalSheet({this.pickPhoto, this.pickGallery});

  @override
  _ModalSheetState createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        enableDrag: true,
        onClosing: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.15,
            color: Colors.white,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                      tileMode: TileMode.mirror,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.greenAccent])
                  .createShader(bounds),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: widget.pickPhoto,
                    icon: Icon(
                      Icons.camera_enhance,
                      size: MediaQuery.of(context).size.height * 0.07,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.pickGallery,
                    icon: Icon(
                      Icons.photo,
                      size: MediaQuery.of(context).size.height * 0.07,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )),
      );
    } else {
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Câmera'),
            onPressed: widget.pickPhoto,
          ),
          CupertinoActionSheetAction(
              child: Text('Galeria'), onPressed: widget.pickGallery)
        ],
      );
    }
  }
}
