import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quality_control_tracker/notification_controller.dart';
import 'package:quality_control_tracker/view/admin/admin_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/view/inspector/inspector_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/view/inspector/inspector_dashboard_page.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/welcome_page.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

import 'loading_page.dart';

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
      routes: {
        '/': (context) => const WelcomePage(),
        '/loading': (context) => const LoadingPage(),
        '/adminDashboard': (context) => const AdminBottomNavigation(),
        // Define other routes here
      },
      initialRoute: '/',
    );
  }
}
