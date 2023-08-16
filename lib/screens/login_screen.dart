import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/blocs/login_bloc/login_bloc.dart';
import 'package:prud_central/classes/size_config.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:prud_central/screens/home_screen.dart';
import 'package:prud_central/screens/signup_screen.dart';
import 'package:prud_central/tabs/recover_pass_tab.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool see = true;

  final _email = TextEditingController();
  final _pass = TextEditingController();

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) async {
      switch (state) {
        case LoginState.SUCCESS:
          UserModel.of(context).loadCurrentUser().then((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeWidget()));
          });
          break;
        case LoginState.FAIL:
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            content: Text(
              'Falha ao Entrar',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/prudblur.jpg')),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: FlareActor(
                        'assets/PrudLoadWhite.flr',
                        animation: 'load',
                      ),
                    ),
                  ),
                ]);
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
                return ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    if (model.isLoading)
                      return Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage('assets/prudblur.jpg')),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: FlareActor(
                              'assets/PrudLoadWhite.flr',
                              animation: 'load',
                            ),
                          ),
                        ),
                      ]);
                    else
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage('assets/prudblur.jpg')),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: SingleChildScrollView(
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(top: 80),
                                          height:
                                              SizeConfig.blockSizeVertical * 20,
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  20,
                                          child:
                                              /*Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/prudente-55426.appspot.com/o/layout%2Flogo.png?alt=media&token=7da5f8cc-8f44-49b9-ad35-5882aa5ebc5e'),
                                     */
                                              Image.asset('assets/logo.png')),
                                      StreamBuilder<String>(
                                          stream: _loginBloc.outEmail,
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 40.0),
                                              child: TextFormField(
                                                onChanged:
                                                    _loginBloc.changeEmail,
                                                controller: _email,
                                                cursorColor: Colors.white,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Digite seu E-mail',
                                                    fillColor: Colors.white,
                                                    labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    icon: Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        35))),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                              ),
                                            );
                                          }),
                                      SizedBox(height: 10),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 8, 4),
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PassAlert());
                                          },
                                          child: Text(
                                            'Esqueceu sua senha?',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<String>(
                                          stream: _loginBloc.outPassword,
                                          builder: (context, snapshot) {
                                            return TextFormField(
                                              onChanged:
                                                  _loginBloc.changePassword,
                                              controller: _pass,
                                              obscureText: see,
                                              cursorColor: Colors.white,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                        see == true
                                                            ? Icons
                                                                .remove_red_eye
                                                            : Icons
                                                                .visibility_off_sharp,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      if (see == true) {
                                                        setState(() {
                                                          see = false;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          see = true;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  labelText: 'Digite sua senha',
                                                  fillColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                  icon: Icon(
                                                    Icons.lock,
                                                    color: Colors.white,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      35))),
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                            );
                                          }),
                                      Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 7,
                                        margin: EdgeInsets.only(
                                            top: 35, left: 26, right: 26),
                                        child: RaisedButton(
                                            disabledColor:
                                                Colors.lightBlue.withAlpha(150),
                                            padding: EdgeInsets.only(
                                                top: 2, bottom: 2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            color: Colors.lightBlue,
                                            onPressed: () {
                                              if (_email.text.contains('@') &&
                                                  _email.text.isNotEmpty &&
                                                  _pass.text.isNotEmpty &&
                                                  _pass.text.length >= 6) {
                                                UserModel.of(context).signIn(
                                                  email: _email.text,
                                                  pass: _pass.text,
                                                  onSuccess: onSuccess,
                                                  onFail: onFail,
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Entrar',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Ainda não tem conta ?',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUpScreen()));
                                                },
                                                child: Text(
                                                  'Clique Aqui!',
                                                  style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontSize: 14,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: Container(
                                          height:
                                              SizeConfig.blockSizeVertical * 22,
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  22,
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                  Colors.white,
                                                  Colors.white,
                                                ]).createShader(bounds),
                                            child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.modulate),
                                                child:
                                                    /*Image.network(
                                                  'https://firebasestorage.googleapis.com/v0/b/prudente-55426.appspot.com/o/layout%2Flogosc.png?alt=media&token=6af499a1-912a-4216-912e-64ccf79c18f5'),
                                            */
                                                    Image.asset(
                                                        'assets/logosc.png')),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      );
                  },
                );
            }
          }),
    );
  }

  onSuccess() {
    Navigator.of(context).pushReplacement(Platform.isAndroid
        ? MaterialPageRoute(builder: (context) => HomeWidget())
        : CupertinoPageRoute(builder: (context) => HomeWidget()));
  }

  onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
      content: Text(
        'Falha ao Entrar!',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
