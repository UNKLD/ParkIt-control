import 'dart:async';
import 'package:flutter/material.dart';

class Angry extends StatelessWidget {
  static const id = 'angryScreen';

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
              Image.asset('images/angry.png'),
              Text(
                'More wrong input!',
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
