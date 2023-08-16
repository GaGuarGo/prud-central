import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final Function({String text}) sendMessage;
  MessageInput(this.sendMessage);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Digite sua mensagem',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(6),
            height: 55,
            width: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
                color: Colors.blueGrey,
                icon: Icon(
                  Icons.send,
                  color: Colors.blueGrey,
                ),
                onPressed: _isComposing
                    ? () {
                        widget.sendMessage(text: _controller.text);
                        _reset();
                      }
                    : null),
          ),
        ],
      );
    else
      return Container(
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: CupertinoTextField(
          placeholder: 'Digite sua mensagem',
          placeholderStyle: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
          controller: _controller,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white),
              color: Colors.white),
          onChanged: (text) {
            setState(() {
              _isComposing = text.isNotEmpty;
            });
          },
          suffix: Container(
            height: 30,
            width: 30,
            //margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            //padding: EdgeInsets.only(bottom: 4, right: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.lightBlue),
            child: IconButton(
                icon: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _isComposing
                    ? () {
                        widget.sendMessage(text: _controller.text);
                        _reset();
                      }
                    : null),
          ),
        ),
      );
  }
}
