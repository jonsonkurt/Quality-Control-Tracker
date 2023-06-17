import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/view/inspector/inspector_dashboard_page.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_dashboard_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var logger = Logger();
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String account = '';
  StreamSubscription<DatabaseEvent>? userSubscription;
  StreamSubscription<DatabaseEvent>? userSubscription2;

  @override
  void dispose() {
    userSubscription?.cancel();
    userSubscription2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      DatabaseReference nameRef =
          FirebaseDatabase.instance.ref().child('inspectors/$userID/role');
      userSubscription = nameRef.onValue.listen((event) {
        try {
          account = event.snapshot.value.toString();
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
            DatabaseReference nameRef2 = FirebaseDatabase.instance
                .ref()
                .child('responsibleParties/$userID/role');
            userSubscription2 = nameRef2.onValue.listen((event) {
              try {
                account = event.snapshot.value.toString();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ResponsiblePartyDashboardPage(
                      role: account,
                    ),
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
              } catch (error, stackTrace) {
                logger.d('Error occurred: $error');
                logger.d('Stack trace: $stackTrace');
              }
            });
          }
        } catch (error, stackTrace) {
          logger.d('Error occurred: $error');
          logger.d('Stack trace: $stackTrace');
        }
      });
      return const Scaffold(
        appBar: null,
        backgroundColor: Color(0xffDCE4E9),
        body: Center(
          child:
              CircularProgressIndicator(), // Show a loading indicator while checking Firebase
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
