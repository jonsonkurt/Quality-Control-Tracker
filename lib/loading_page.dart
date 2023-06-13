import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/view/inspector/inspector_dashboard_page.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_dashboard_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: OnBoarding());
  }
}

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    String account = '';
    // ignore: unused_local_variable
    StreamSubscription<DatabaseEvent>? userSubscription;

    if (FirebaseAuth.instance.currentUser != null) {
      // Redirect the user to the homepage
      final firebaseApp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL:
            'https://quality-control-tracker-389614-default-rtdb.asia-southeast1.firebasedatabase.app/',
      );

      DatabaseReference nameRef = rtdb.ref().child('inspectors/$userID/role');
      userSubscription = nameRef.onValue.listen((event) {
        try {
          account = event.snapshot.value.toString();
          // ignore: unnecessary_null_comparison
          if (account == "Inspector") {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const InspectorDashboardPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          } else {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ResponsiblePartyDashboardPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          }
        } catch (error, stackTrace) {
          logger.d('Error occurred: $error');
          logger.d('Stack trace: $stackTrace');
        }
      });
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
