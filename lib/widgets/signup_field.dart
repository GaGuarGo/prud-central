import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUpField extends StatelessWidget {
  final fieldStyle = TextStyle(
      color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold);

  SignUpField(
      {@required this.label,
      @required this.icon,
      @required this.controller,
      this.obscure = false,
      this.type,
      @required this.validator
      });

  final String label;
  final Icon icon;
  final TextEditingController controller;
  bool obscure;
  final TextInputType type;
  final Function(String text) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 2,
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
            tileMode: TileMode.mirror,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.blue, Colors.greenAccent]).createShader(bounds),
        child: Container(
          margin: EdgeInsets.only(top: 0),
          child: TextFormField(
            validator: validator,
            obscureText: obscure,
            keyboardType: type,
            controller: controller,
            decoration: InputDecoration(
                enabled: true,
                contentPadding: EdgeInsets.only(right: 4, left: 4),
                icon: icon,
                labelText: label,
                labelStyle: fieldStyle,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
          ),
        ),
      ),
    );
  }
}
