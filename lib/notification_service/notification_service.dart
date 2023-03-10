import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:the_hit_times_app/models/note.dart';

import '../database_helper.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //  Initialise Flutter Local Notifications Plugin with AndroidInitializationSettings
  void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/notification_icon"),
    );

    _notificationsPlugin.initialize(initializationSettings);
    _requestNotificationPermission();
    _subscribeToTopics();
  }

  // Request notification permission for android 13 and iOS devices
  void _requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  // Subscribes to topics to receive notification
  // when a notification is broadcast from backend.
  void _subscribeToTopics() async {
    await _messaging.subscribeToTopic("events_notification");
    await _messaging.subscribeToTopic("posts_notification");
  }

  // Display a notification when app is in foreground
  // with the help of Flutter Local Notification Plugin
  void show(RemoteMessage message) async {
    final http.Response response =
        await http.get(Uri.parse(message.notification!.android!.imageUrl!));
        
        // DatabaseHelper helper = DatabaseHelper();
        print(" Hoooooollllllaaaa  ${message.notification!.title}");
                print(" Hoooooollllllaaaa1  ${message.notification!.body}");

        print(" Hoooooollllllaaaa2  ${message.notification!.android!.imageUrl!}");

        // int? result = await helper.insertNote(
        //   Note(9, message.notification!.title, message.notification!.android!.imageUrl!, 1, message.notification!.body)
        // );


    var bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(response.bodyBytes)));

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "pushnotificationapp", "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation),
    );

    await _notificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }
}