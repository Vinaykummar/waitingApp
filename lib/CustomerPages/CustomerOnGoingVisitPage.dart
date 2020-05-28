import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';

class CustomerOnGoingVisitPage extends StatefulWidget {
  CustomerOnGoingVisitPage({Key key, this.title, @required this.visitedDoc})
      : super(key: key);

  final String title;
  final DocumentSnapshot visitedDoc;

  @override
  _CustomerOnGoingVisitPageState createState() =>
      _CustomerOnGoingVisitPageState();
}

class _CustomerOnGoingVisitPageState extends State<CustomerOnGoingVisitPage> {
  String label = "Seconds";
  int _counter = -1;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  void _incrementCounter() {
    //     final myfrontCustomer = widget.visitedDoc.data['tokenNo'] - 1;
//     final myWaitingTime =
//         myfrontCustomer * widget.visitedDoc.data['waitingTime'];
//     final timeOfBooking = DateTime.parse(widget.visitedDoc.data['time']);

//     DateTime myApproxTime = timeOfBooking.add(Duration(minutes: myWaitingTime));
//     Duration timeLeft = myApproxTime.difference(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      String bookedTime = widget.visitedDoc.data['time'];
      int queue = widget.visitedDoc.data['tokenNo'] - 1;
      int waitingTime = widget.visitedDoc.data['waitingTime'] * queue;
      DateTime myApprox =
          DateTime.parse(bookedTime).add(Duration(minutes: waitingTime));
          print(waitingTime);
      if (waitingTime > 0) {
        setState(() {
          final left = DateTime.parse('2020-05-28 00:24:19.110587').difference(DateTime.now());
          if(left.inSeconds <=  60){
            label = "Seconds";
          _counter = left.inSeconds;
          }
           if(left.inMinutes < 60){
            label = "Minutes";
          _counter = left.inMinutes;
          }

          if(left.inMinutes > 60){
            label = "Hours";
          _counter = left.inHours;
          } 

          if (left.inMinutes == 0) {
            _timer.cancel();
            print('Canceled');
          }
        });
      }else {
        setState(() {
          _counter = 0;
          if (_counter == 0) {
            _timer.cancel();
            print('Canceled');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _counter = 0;
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Booking Confirmed',
          ),
          if (_counter < 0)
            Text(
              'Calculating',
              style: Theme.of(context).textTheme.headline4,
            ),
          if (_counter > 0)
            Text(
              '${_counter} ${label} Left',
              style: Theme.of(context).textTheme.headline4,
            ),
          if (_counter == 0)
            Text(
              'Its Your Time',
              style: Theme.of(context).textTheme.headline4,
            ),
        ],
      ),
    );
  }
}

// class CustomerOnGoingVisitPage extends StatefulWidget {
//   final DocumentSnapshot visitedDoc;

//   CustomerOnGoingVisitPage({@required this.visitedDoc});

//   @override
//   _CustomerOnGoingVisitPageState createState() =>
//       _CustomerOnGoingVisitPageState();
// }

// class _CustomerOnGoingVisitPageState extends State<CustomerOnGoingVisitPage> {
//   int _waitTime = 10;
//   Timer _timer;

//   void timeLeft() {

//     final myfrontCustomer = widget.visitedDoc.data['tokenNo'] - 1;
//     final myWaitingTime =
//         myfrontCustomer * widget.visitedDoc.data['waitingTime'];
//     final timeOfBooking = DateTime.parse(widget.visitedDoc.data['time']);

//     DateTime myApproxTime = timeOfBooking.add(Duration(minutes: myWaitingTime));
//     Duration timeLeft = myApproxTime.difference(DateTime.now());
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_waitTime > 0) {
//           _waitTime = timeLeft.inSeconds;
//         } else {
//           _timer.cancel();
//         }
//       });
//     });
//   }

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     timeLeft();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = Provider.of<AuthProvider>(context);

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             Text('Booking Confirmed',
//                 style: TextStyle(
//                     color: Colors.green, fontWeight: FontWeight.bold)),
//             SizedBox(
//               height: 10,
//             ),
//             Text('Waiting Time',
//                 style: TextStyle(color: Colors.black, fontSize: 16)),
//             Text('${_waitTime} Seconds',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }
