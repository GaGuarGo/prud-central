import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prud_central/classes/size_config.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/widgets/modal_bottomsheet.dart';
import 'package:prud_central/widgets/signup_field.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fieldStyle = TextStyle(
      color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final rmController = TextEditingController();

  Widget _box() => SizedBox(
        height: SizeConfig.blockSizeVertical * 3,
      );

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  File _imgFile;
  String _url;
  bool isLoading = false;
  bool loading = false;

  Future<void> savePhoto() async {
    setState(() {
      loading = true;
    });
    if (_imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(_imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _url = url;
        loading = false;
      });
    } else {
      setState(() {
        _url = null;
        loading = false;
      });
    }
  }

  _pickPhoto() async {
    setState(() {
      isLoading = true;
    });
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        _imgFile = img;
        isLoading = false;
      });
    }
    Navigator.of(context).pop();
  }

  _pickGallery() async {
    setState(() {
      isLoading = true;
    });
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _imgFile = img;
        isLoading = false;
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.lightBlueAccent),
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: Container(
                height: SizeConfig.blockSizeVertical * 40,
                width: SizeConfig.blockSizeHorizontal * 40,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                          tileMode: TileMode.mirror,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.greenAccent])
                      .createShader(bounds),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.modulate),
                    child: FlareActor(
                      'assets/PrudLoadWhite.flr',
                      animation: 'load',
                    ),
                  ),
                ),
              ),
            );
          return Container(
            margin: EdgeInsets.only(top: 0, bottom: 8, left: 6, right: 4),
            alignment: Alignment.topCenter,
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 30,
                      width: SizeConfig.blockSizeHorizontal * 30,
                      alignment: Alignment.center,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                                tileMode: TileMode.mirror,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.blue, Colors.greenAccent])
                            .createShader(bounds),
                        child: ColorFiltered(
                          child: /* Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/prudente-55426.appspot.com/o/layout%2Flogosc.png?alt=media&token=6af499a1-912a-4216-912e-64ccf79c18f5'),
                          */ Image.asset('assets/logosc.png'),
                          colorFilter: ColorFilter.mode(
                              Colors.white, BlendMode.modulate),
                        ),
                      ),
                    ),
                    isLoading == false
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 4),
                            margin:
                                EdgeInsets.only(bottom: 8, right: 4, left: 4),
                            height: SizeConfig.blockSizeVertical * 10,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              /*
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 2),
                      left: BorderSide(color: Colors.white, width: 2),
                      right: BorderSide(color: Colors.white, width: 2),
                      bottom: BorderSide(color: Colors.white, width: 2),

                    )*/
                            ),
                            child: _imgFile == null
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (context) => ModalSheet(
                                                    pickGallery: _pickGallery,
                                                    pickPhoto: _pickPhoto,
                                                  ));
                                        },
                                        icon: Icon(
                                          Icons.photo_library,
                                          size: 50,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) => ModalSheet(
                                                pickGallery: _pickGallery,
                                                pickPhoto: _pickPhoto,
                                              ));
                                    },
                                    child: ClipOval(
                                      child: Image.file(
                                        _imgFile,
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                          )
                        : LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Colors.lightBlueAccent),
                          ),
                    SignUpField(
                      validator: (text) {
                        if (text.isEmpty || text.length < 5)
                          return 'Nome invalido';
                      },
                      label: 'Digite seu Nome',
                      icon: Icon(Icons.book, size: 20, color: Colors.white),
                      controller: nameController,
                    ),
                    _box(),
                    SignUpField(
                      validator: (text) {
                        if (text.isEmpty || !text.contains('@'))
                          return 'Email invalido';
                      },
                      label: 'Digite seu email',
                      icon: Icon(Icons.email, size: 20, color: Colors.white),
                      controller: emailController,
                      type: TextInputType.emailAddress,
                    ),
                    _box(),
                    SignUpField(
                      validator: (text) {
                        if (text.isEmpty)
                          return 'Senha invalida';
                        else if (text.length < 6) return 'Senha muito Curta';
                      },
                      label: 'Digite sua senha',
                      icon: Icon(Icons.lock, size: 20, color: Colors.white),
                      controller: passController,
                      obscure: true,
                    ),
                    _box(),
                    SignUpField(
                      type: TextInputType.number,
                      validator: (text) {
                        if (text.isEmpty || text.length > 5 || text.length < 5)
                        if (text.isEmpty || text.length > 5 || text.length < 5)
                          return 'RM invalido';
                      },
                      label: 'Digite seu RM',
                      icon: Icon(Icons.credit_card,
                          size: 20, color: Colors.white),
                      controller: rmController,
                    ),
                    _box(),
                    Container(
                      height: SizeConfig.blockSizeVertical * 6,
                      margin: EdgeInsets.only(left: 4, right: 4),
                      child: RaisedButton(
                          disabledColor: Colors.lightBlueAccent.withAlpha(150),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              savePhoto().then((_) {
                                Map<String, dynamic> userData = {
                                  'nome': nameController.text,
                                  'email': emailController.text,
                                  'RM': rmController.text,
                                  'Tipo': 'Aluno',
                                  'foto': _url,
                                };

                                model.signUp(
                                  userData: userData,
                                  pass: passController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail,
                                );
                              });
                            }
                          },
                          color: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: loading == false
                              ? Center(
                                  child: Text(
                                    'Cadastrar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  ),
                                )),
                    ),
                  ],
                )),
          );
        }));
  }

  void _onSuccess() {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text(
        'Cadastrado com Sucesso!',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
// ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
      content: Text(
        'Falha ao Cadastrar!',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
