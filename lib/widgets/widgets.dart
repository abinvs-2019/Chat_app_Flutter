import 'package:flutter/material.dart';

InputDecoration textFiledInputDecoration(String hint) {
  InputDecoration(
    labelText: hint,
    fillColor: Colors.white,
    border: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(25.0),
      borderSide: new BorderSide(),
    ),
    //fillColor: Colors.green
  );
}
