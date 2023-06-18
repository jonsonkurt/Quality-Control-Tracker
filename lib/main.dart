import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quality_control_tracker/notification_controller.dart';
import 'package:quality_control_tracker/welcome_page.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    initFcm(context);
    return MaterialApp(
      title: 'Quality Control Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const WelcomePage(),
    );
  }
}
