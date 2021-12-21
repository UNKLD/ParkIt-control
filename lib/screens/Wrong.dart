import 'dart:async';
import 'package:flutter/material.dart';

class Wrong extends StatefulWidget {
  static const id = "wrongScreen";

  @override
  _WrongState createState() => _WrongState();
}

class _WrongState extends State<Wrong> {
  void autoClose(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    autoClose(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wrong'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/sad.png'),
              Text(
                'Wrong input!',
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
