import 'package:flutter/material.dart';

const myTextFieldStyle = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  labelText: 'Email',
  labelStyle: TextStyle(color: Colors.white),
  border: OutlineInputBorder(),
);

const myInputTextStyle = TextStyle(
  color: Colors.white,
  overflow: TextOverflow.ellipsis,
);
