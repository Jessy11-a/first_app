// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

showAlertDia(title, content, context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 20)),
        content: Text(content, style: TextStyle(fontSize: 20),),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          ElevatedButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}