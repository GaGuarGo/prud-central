import 'package:flutter/material.dart';
import 'package:prud_central/models/user_model.dart';
//import 'package:prud_central/screens/login_screen.dart';
import 'package:prud_central/tabs/splash_tab.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ), 
        home: SplashTab()   
      ),
    );
  }
}