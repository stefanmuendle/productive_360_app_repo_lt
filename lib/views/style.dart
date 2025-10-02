import 'package:flutter/material.dart';

class KTextStyle {
  static const TextStyle tileTealText = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle descriptionText = TextStyle(fontSize: 16.0);
}

class KTextFieldStyle {
  static const InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
  );
}
