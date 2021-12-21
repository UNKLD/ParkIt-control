import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Confirm extends StatelessWidget {
  static const id = "confirmScreen";
  final String userId;
  final String userEmail;
  const Confirm({this.userId, this.userEmail});

  void check(BuildContext context) {
    final databaseRef =
        FirebaseDatabase.instance.reference().child('parkedUsers');
    databaseRef.child(userId).once().then((snap) {
      if (snap.value != null)
        unPark();
      else
        checkReserved(context);
    });
  }

  void checkReserved(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child('reservations')
        .child(userId);
    databaseRef.remove().whenComplete(() => park(context));
  }

  void park(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child('parkedUsers')
        .child(userId);
    databaseRef.set({
      'id': userId,
      'userEmail': userEmail,
      'time': TimeOfDay.now().format(context),
    }).whenComplete(() => updateParkingLot(context));
  }

  void updateParkingLot(BuildContext context) {
    final newRef = FirebaseDatabase.instance.reference().child('parkingLot');
    newRef.once().then((snap) {
      String aSlot = '';
      String lotId = '';
      if (snap.value != null)
        for (var value in snap.value.values) {
          aSlot = value['availableSlots'];
          lotId = value['id'];
        }
      print(snap.value);
      int newSlots = int.parse(aSlot) - 1;

      newRef.child(lotId).update({
        'availableSlots': newSlots.toString(),
      });
    }).whenComplete(() => report(context));
  }

  void report(BuildContext context) {
    final newRef = FirebaseDatabase.instance.reference().child('report').push();
    String newKey = newRef.key;
    newRef.set({
      'id': newKey,
      'userEmail': userEmail,
      'report': 'parked',
      'time': TimeOfDay.now().format(context),
    }).onError((error, stackTrace) => print(error));
  }

  void unPark() {
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child('parkedUsers')
        .child(userId);
    databaseRef.remove().whenComplete(() {
      final newRef = FirebaseDatabase.instance.reference().child('parkingLot');
      newRef.once().then((snap) {
        String aSlot = '';
        String lotId = '';
        if (snap.value != null)
          for (var value in snap.value.values) {
            aSlot = value['availableSlots'];
            lotId = value['id'];
          }
        int newSlots = int.parse(aSlot) + 1;
        newRef.child(lotId).update({
          'availableSlots': newSlots.toString(),
        });
      });
    });
  }

  void autoClose(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

// showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Already Parked'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, MyHomePage.id);
//             },
//             child: Text('Ok'),
//           ),
//         ],
//       ),
//     );
  @override
  Widget build(BuildContext context) {
    check(context);
    autoClose(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmed'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/happy.png'),
              Text('Successful', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
      ),
    );
  }
}
