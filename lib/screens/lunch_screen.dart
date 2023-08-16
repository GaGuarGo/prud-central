import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prud_central/classes/size_config.dart';
import 'package:prud_central/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LunchScreen extends StatefulWidget {
  @override
  _LunchScreenState createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool egg = false;
  bool rice = false;
  bool day = false;
  bool riceEgg = false;

  bool success = false;
  bool loading = false;

  String ovo = 'Não Adiconar';
  String arroz = 'Não Adicionar';
  String dia = 'Não';
  int hora = Timestamp.now().microsecondsSinceEpoch;

  void _clear() {
    setState(() {
      egg = false;
      rice = false;
      riceEgg = false;
      day = false;
      ovo = 'Não Adiconar';
      arroz = 'Não Adicionar';
      dia = 'Não';
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
        fontSize: SizeConfig.blockSizeVertical * 2.5);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: TileMode.repeated,
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                Color.fromRGBO(0, 184, 212, 1),
                //Color.fromRGBO(0,191,165, 1),
                Colors.white,
                Colors.blueAccent
              ])),
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            body: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          )),
                          color: Colors.white,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16),
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Seu Pedido:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26)),
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: _clear,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Arroz Integral: $arroz',
                                  style: _style,
                                ),
                                Text(
                                  'Ovo: $ovo',
                                  style: _style,
                                ),
                                Text(
                                  'Guarnição do Dia: $dia',
                                  style: _style,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: DragTarget(
                              builder: (context, List<String> candidateData,
                                  rejectData) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: rice && egg == true
                                              ? AssetImage(
                                                  'images/arrozovo.png')
                                              : rice == true
                                                  ? AssetImage(
                                                      'images/pratoarroz.png')
                                                  : egg == true
                                                      ? AssetImage(
                                                          'images/pratoovo.png')
                                                      : day == true
                                                          ? AssetImage(
                                                              'images/pratodia.png')
                                                          : AssetImage(
                                                              'images/prato.png'))),
                                );
                              },
                              onWillAccept: (data) {
                                return true;
                              },
                              onAccept: (data) {
                                if (data == 'egg') {
                                  setState(() {
                                    egg = true;
                                    ovo = 'Adicionar';
                                  });
                                } else if (data == 'rice') {
                                  setState(() {
                                    rice = true;

                                    arroz = 'Adicionar';
                                  });
                                } else if (data == 'day') {
                                  setState(() {
                                    day = true;
                                    dia = 'Sim';
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 22.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Draggable(
                                  data: 'day',
                                  feedback: Container(
                                    height: SizeConfig.blockSizeVertical * 12,
                                    width: SizeConfig.blockSizeHorizontal * 22,
                                    child: Image.asset('images/pratodia.png'),
                                  ),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: day == true
                                                  ? Colors.green
                                                  : Colors.white,
                                              width: 2.0)),
                                      height: SizeConfig.blockSizeVertical * 12,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 22,
                                      child:
                                          Image.asset('images/pratodia.png'))),
                              Draggable(
                                  data: 'egg',
                                  feedback: Container(
                                      height: SizeConfig.blockSizeVertical * 12,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 22,
                                      child:
                                          Image.asset('images/pratoovo.png')),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: egg == true
                                                  ? Colors.green
                                                  : Colors.white,
                                              width: 2.0)),
                                      height: SizeConfig.blockSizeVertical * 12,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 22,
                                      child:
                                          Image.asset('images/pratoovo.png'))),
                              Draggable(
                                  data: 'rice',
                                  feedback: Container(
                                      height: SizeConfig.blockSizeVertical * 12,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 22,
                                      child:
                                          Image.asset('images/pratoarroz.png')),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: rice == true
                                                  ? Colors.green
                                                  : Colors.white,
                                              width: 2.0)),
                                      height: SizeConfig.blockSizeVertical * 12,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 22,
                                      child: Image.asset(
                                          'images/pratoarroz.png'))),
                            ],
                          ),
                        ),
                        ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            if (!Platform.isAndroid)
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: CupertinoButton.filled(
                                    onPressed: _lunch,
                                    child: !model.isLoading
                                        ? Center(
                                            child: Text(
                                              'Marcar',
                                              /*
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                                  */
                                            ),
                                          )
                                        : success == true
                                            ? Center(
                                                child: Icon(Icons.check,
                                                    size: 20,
                                                    color: Colors.white))
                                            : Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Platform.isAndroid
                                                        ? CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Colors
                                                                        .white),
                                                          )
                                                        : CupertinoActivityIndicator()),
                                              )),
                              );
                            else
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      tileMode: TileMode.mirror,
                                      colors: [
                                        success == true
                                            ? Colors.green
                                            : Colors.blueAccent,
                                        success == true
                                            ? Colors.green
                                            : Colors.lightBlueAccent
                                      ]),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledColor: !success == true
                                        ? Colors.grey
                                        : Colors.green,
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    onPressed: _lunch,
                                    child: !model.isLoading
                                        ? Text(
                                            'Marcar',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : success == true
                                            ? Center(
                                                child: Icon(Icons.check,
                                                    size: 20,
                                                    color: Colors.white))
                                            : Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Platform.isAndroid
                                                        ? CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Colors
                                                                        .white),
                                                          )
                                                        : CupertinoActivityIndicator()),
                                              )),
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // estilizar o botão de marcar para IOS

  _lunch() {
    var format = DateFormat('dd/MM/yyyy-HH:mm');
    var date = new DateTime.fromMicrosecondsSinceEpoch(hora);
    var diaHora = format.format(date);

    Map<String, dynamic> lunch = {
      'nome': UserModel.of(context).userData['nome'],
      'userId': UserModel.of(context).firebaseUser.uid,
      'hora': diaHora,
      'almoço': dia,
      'ovo': ovo,
      'arroz': arroz,
    };
    if (day && rice && egg == true) {
      _warning('Almoço inválido!');
    } else if (day && rice && egg == false) {
      _warning('Almoço inválido!');
    } else if (day && egg == true) {
      _warning('Escolha a guarnição do dia ou alguma opção!');
    } else if (day && rice == true) {
      _warning('Escolha a guarnição do dia ou alguma opção!');
    } else if (rice && egg == true) {
      UserModel.of(context)
          .sendOrderRaE(order: lunch, onSuccess: _onSuccess, onFail: _onFail);
      _complete();
      _clear();
    } else if (egg == true) {
      UserModel.of(context)
          .sendOrderEgg(order: lunch, onSuccess: _onSuccess, onFail: _onFail);
      _complete();
      _clear();
    } else if (rice == true) {
      UserModel.of(context)
          .sendOrderRice(order: lunch, onSuccess: _onSuccess, onFail: _onFail);
      _complete();
      _clear();
    } else if (day == true) {
      UserModel.of(context)
          .sendOrder(order: lunch, onSuccess: _onSuccess, onFail: _onFail);
      _complete();
      _clear();
    }
  }

  _warning(String warn) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
      content: Text(
        warn,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ));
  }

  _complete() async {
    setState(() {
      success = true;
    });
    await Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        success = false;
      });
    });
  }

  _onSuccess() async {}

  _onFail() {}
}
