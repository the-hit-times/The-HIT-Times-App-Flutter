import 'package:flutter/material.dart';
import 'package:the_hit_times_app/homepage.dart';

// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase for other services like cloud messaging.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  registerForNotification();
  runApp(const MyApp());
}

/*
*   Registers current devices for receiving notification for topics like
*   1. Events
* */
void registerForNotification() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permission for android 13 and iOS devices
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // final fcmToken = await messaging.getToken();
  // print(fcmToken);
  // print("FCM");
  final eventTopic = await FirebaseMessaging.instance.subscribeToTopic("events_notification");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The HIT Times',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: MainPage(),
    );
  }
}
