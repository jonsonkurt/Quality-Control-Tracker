import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quality_control_tracker/notification_controller.dart';
import 'package:quality_control_tracker/view/admin/admin_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/welcome_page.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

import 'loading_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    initFcm(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quality Control Tracker',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF221540)),
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
