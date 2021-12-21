import 'package:firebase_database/firebase_database.dart';
import 'package:parkitcontrol/screens/Angry.dart';
import 'package:parkitcontrol/screens/progressDialog.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:parkitcontrol/screens/Confirm.dart';
import 'package:parkitcontrol/screens/Wrong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkIt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MyHomePage.id,
      routes: {
        Confirm.id: (context) => Confirm(),
        Wrong.id: (context) => Wrong(),
        MyHomePage.id: (context) => MyHomePage(),
        Angry.id: (context) => Angry(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const id = "homeScreen";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "Press button to Scan";
  int count = 0;

  void proceed(String result) {
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(
              message: 'Loading',
            ));
    final databaseRef =
        FirebaseDatabase.instance.reference().child('users').child(result);
    databaseRef.once().then((snap) {
      if (snap.value != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Confirm(
              userId: result,
              userEmail: snap.value['email'],
            ),
          ),
        );
        setState(() {
          count = 0;
        });
      } else if (count >= 2) {
        Navigator.pop(context);
        Navigator.pushNamed(context, Angry.id);
      } else {
        Navigator.pop(context);
        Navigator.pushNamed(context, Wrong.id);
        setState(() {
          count += 1;
        });
      }
    });
  }

  Future _scanQR() async {
    try {
      String cameraScanResult = await scanner.scan();
      print(cameraScanResult);
      proceed(cameraScanResult);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ParkIt Controller"),
      ),
      body: Center(
        child: Text(result), // Here the scanned result will be shown
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        onPressed: () {
          _scanQR(); // calling a function when user click on button
        },
        label: Text("Scan"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
