import 'package:flutter/material.dart';

Widget appBarMain(context) {
  return AppBar(
    title: Text(
      'Messenger',
      style: TextStyle(
        //fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevation: 0.0,
  );
}

InputDecoration textFeieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white54),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}
