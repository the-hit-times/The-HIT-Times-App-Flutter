import 'dart:convert';

// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:the_hit_times_app/features/live/match_history.dart';
import 'package:the_hit_times_app/homepage.dart';

import 'features/live/match_screen.dart';
import 'firebase_options.dart';
import 'notidisplay.dart';
import 'notification_service/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Whenever a notification is received in background, this function is called.
// Don't move this function to another file. It needs to be at the top level to function properly.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var notificationType = message.data["type"];
  print("Notification Type: $notificationType");
  NotificationService.initialize(navigatorKey: navigatorKey);
  if (notificationType == "LIVE") {
    NotificationService.liveNotification(message);
  } else {
    print("creating a notification database");
    NotificationService.storeNotificationInDatabase(
        message); // Store notification in database
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if it's not initialized yet
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase is already initialized: $e");
  }

  // Initialize Notification Service
  NotificationService.initialize(navigatorKey: navigatorKey);

  String? selectedNotificationPayload;

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await NotificationService()
          .notificationsPlugin
          .getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    var notificationType = message.data["type"];
    if (notificationType == "LIVE") {
      NotificationService.liveNotification(message);
    } else {
      NotificationService.show(message);
    }
  });

  runApp(MyApp(
    selectedNotificationPayload: selectedNotificationPayload,
  ));
}

/*
*   Registers current devices for receiving notification for topics like
*   1. Events
* */

class MyApp extends StatefulWidget {
  String? selectedNotificationPayload;
  MyApp({Key? key, this.selectedNotificationPayload}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'The HIT Times',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(37, 45, 59, 1),
        primarySwatch: Colors.teal,
        useMaterial3:
            false, // App uses material 2 design system, enabling it will lead to theme issues on different devices.
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            foregroundColor: Colors.white,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0),
      ),
      home: MainPage(),
      routes: {
        MatchHistoryScreen.ROUTE_NAME: (context) => MatchHistoryScreen(),
        MatchScreen.ROUTE_NAME: (context) => MatchScreen(),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedNotificationPayload != null) {
        var data = jsonDecode(widget.selectedNotificationPayload!);
        print("Data: $data");
        switch (data["type"]) {
          case "POST":
            navigatorKey.currentState?.push(MaterialPageRoute(
                builder: (context) => NotificationDisplayWeb(
                      postId: data["id"],
                    )));
            break;
          case "LIVE":
            navigatorKey.currentState?.push(MaterialPageRoute(
                builder: (context) => MatchScreen(
                      matchId: data["id"],
                    )));
            break;
        }
      }
    });
  }
}
