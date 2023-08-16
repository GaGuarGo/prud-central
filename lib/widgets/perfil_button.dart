import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prud_central/widgets/perfil_warning.dart';

class PerfilButton extends StatefulWidget {
  @override
  _PerfilButtonState createState() => _PerfilButtonState();
}

class _PerfilButtonState extends State<PerfilButton> {
  final _style = TextStyle(color: Colors.blueGrey, fontSize: 12);
  File _imgFile;

  _pickPhoto() async {
    // ignore: deprecated_member_use
    final File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        _imgFile = img;
      });
      showDialog(
          context: context,
          builder: (context) => PerfilDialog(
                imgFile: _imgFile,
              ));
    }
  }

  _pickGallery() async {
    // ignore: deprecated_member_use
    final File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _imgFile = img;
      });
      showDialog(
          context: context,
          builder: (context) => PerfilDialog(
                imgFile: _imgFile,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return SpeedDial(
        tooltip: 'Editar Foto',
        overlayOpacity: 0.4,
        backgroundColor: Colors.blueGrey,
        child: Center(
          child: Icon(
            CupertinoIcons.pencil,
            size: 20,
            color: Colors.white,
          ),
        ),
        children: [
          SpeedDialChild(
              label: 'Camera',
              labelStyle: _style,
              onTap: _pickPhoto,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.camera,
                  color: Colors.blueGrey,
                ),
              )),
          SpeedDialChild(
              label: 'Galeria',
              labelStyle: _style,
              onTap: _pickGallery,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.photo_album,
                  color: Colors.blueGrey,
                ),
              )),
        ],
      );
    else
      return FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          showCupertinoDialog(
              context: context, builder: (context) => Sheet());
        },
        tooltip: 'Editar Foto',
        child: Center(
          child: Icon(
            CupertinoIcons.pencil,
            size: 20,
            color: Colors.white,
          ),
        ),
      );
  }
}

class Sheet extends StatefulWidget {
  @override
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  File _imgFile;
  _pickPhoto() async {
    // ignore: deprecated_member_use
    final File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        _imgFile = img;
      });
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) => PerfilDialog(
                imgFile: _imgFile,
              ));
    }
  }

  _pickGallery() async {
    // ignore: deprecated_member_use
    final File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _imgFile = img;
      });
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) => PerfilDialog(
                imgFile: _imgFile,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: _pickPhoto,
        ),
        CupertinoActionSheetAction(
            child: Text('Galeria'), onPressed: _pickGallery)
      ],
    );
  }
}
