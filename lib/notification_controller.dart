import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/loading_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initFcm(context) async {
  // await Firebase.initializeApp();

  String? userID = FirebaseAuth.instance.currentUser?.uid;
  var logger = Logger();

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    if (FirebaseAuth.instance.currentUser != null) {
      DatabaseReference nameRef =
          FirebaseDatabase.instance.ref().child('inspectors/$userID/role');
      DatabaseReference ref = FirebaseDatabase.instance.ref().child('inspectors');
      DatabaseReference resRef =
          FirebaseDatabase.instance.ref().child('responsibleParties');
      nameRef.onValue.listen((event) async {
        try {
          String name = event.snapshot.value.toString();
          // ignore: unnecessary_null_comparison
          if (name == "Inspector") {
            final fcmToken = await FirebaseMessaging.instance.getToken();

            await ref.child(userID!).update({
              'fcmToken': fcmToken,
            });

            // ignore: use_build_context_synchronously
          } else {
            final fcmToken = await FirebaseMessaging.instance.getToken();

            await resRef.child(userID!).update({
              'fcmProfToken': fcmToken,
            });
          }
        } catch (error, stackTrace) {
          logger.d('Error occurred: $error');
          logger.d('Stack trace: $stackTrace');
        }
      });
    }

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    logger.d('Error occurred: $err');
  });

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher_round');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Configure FirebaseMessaging to handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle notification clicks when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
    RemoteNotification? notification = message?.notification;
    AndroidNotification? android = message?.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
            android: AndroidNotificationDetails('channel.id', 'channel.name',
                styleInformation: BigTextStyleInformation(''))),
        payload: json.encode(message?.data),
      );
    }
  });
  // Handle notification clicks when the app is terminated or in the background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
    handleNotification(message, context);
  });
}

Future<void> handleNotification(RemoteMessage? message, context) async {
  if (message?.data != null) {
    // Handle the notification payload here
    // Example: Navigate to a specific screen based on the payload data
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    // Extract the payload data
    // var payloadData = json.decode(message!.data['data']);
    // print(payloadData);

    // Example: Navigate to a screen named 'DetailScreen' with the payload data
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoadingPage()));
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle the background message here
  // You can perform custom logic here, such as saving the message to a local database,
  // scheduling a local notification, or updating the UI in some way.

  // IMPORTANT: Make sure to call `Firebase.initializeApp()` before using any Firebase services
  // await Firebase.initializeApp();

  // If you need to access Firebase services or perform additional tasks,
  // you can do so within this background handler function.
}
