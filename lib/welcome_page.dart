import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/sign_in_page.dart';
import 'package:quality_control_tracker/view/inspector/inspector_dashboard_page.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_dashboard_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    String account = '';
    // ignore: unused_local_variable
    StreamSubscription<DatabaseEvent>? userSubscription;

    if (FirebaseAuth.instance.currentUser != null) {
      // Redirect the user to the homepage

      DatabaseReference nameRef =
          FirebaseDatabase.instance.ref().child('inspectors/$userID/role');
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

    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xffDCE4E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/images/welcome.png'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Welcome',
              style: TextStyle(fontFamily: 'Rubik', fontSize: 40),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Track construction projects with ease!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff221540),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                minimumSize: const Size(160, 50),
              ),
              child: const Text('Get Started!'),
            ),
          ],
        ),
      ),
    );
  }
}
