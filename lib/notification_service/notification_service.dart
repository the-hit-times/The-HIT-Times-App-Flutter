import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:the_hit_times_app/database_helper.dart';
import 'package:the_hit_times_app/features/live/models/LiveMatch.dart';
import 'package:the_hit_times_app/models/notification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_hit_times_app/notify.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const LIVE_NOTIFICATION_ID = 0;

  //  Initialise Flutter Local Notifications Plugin with AndroidInitializationSettings
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/notification_icon"),
    );

    _notificationsPlugin.initialize(initializationSettings);
    _requestNotificationPermission();
    _subscribeToTopics();
  }

  // Request notification permission for android 13 and iOS devices
  static void _requestNotificationPermission() async {
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
  static void _subscribeToTopics() async {
    await _messaging.subscribeToTopic("live_notification");
    await _messaging.subscribeToTopic("posts_notification");
  }

  // Display a notification when app is in foreground
  // with the help of Flutter Local Notification Plugin
  static void show(RemoteMessage message) async {
    final http.Response response =
        await http.get(Uri.parse(message.notification!.android!.imageUrl!));

        print(" hi "+message.notification!.android!.imageUrl!);
        print(" hi2 ${message.notification!.title}");
        print(" hi3 ${message.notification!.body}");

        await NotificationDatabase.instance.create(
          Notification(
          imageUrl: message.notification!.android!.imageUrl!,
          title: message.notification!.title!,
          description: message.notification!.body!, 
          createdTime:  DateTime.now(),)
          );

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
      _notificationIDGenerator(),
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }

  static void liveNotification(RemoteMessage message) async {
    // final http.Response response =
    // await http.get(Uri.parse(message.notification!.android!.imageUrl!));
    print(message.data.toString());

    var matchInfo =  LiveMatch.fromNotification(message);
    print(matchInfo.toFirestore().toString());


   /* var bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(response.bodyBytes)));*/

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "Live Notification", "Live updates for HIT football, cricket and various other matches.",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
              "${matchInfo.team1?.teamScore}-${matchInfo.team2?.teamScore}", htmlFormatBigText: true,
              htmlFormatTitle:true ,
              htmlFormatContent:true ,
              contentTitle: "${matchInfo.team1?.getTeamName()}-${matchInfo.team2?.getTeamName()}",
              htmlFormatContentTitle: true,
          )),
    );

   await _notificationsPlugin.show(
      LIVE_NOTIFICATION_ID,
      "<b>${matchInfo.team1?.getTeamName()}-${matchInfo.team2?.getTeamName()}</b>",
      "${matchInfo.team1?.teamScore}-${matchInfo.team2?.teamScore}",
      notificationDetails,
    );
  }

  /// It is responsible for generating random ids for the post such that
  /// if two posts are posted at same time, two independent notifications
  /// instead of its getting overriden by new post notification.
  static int _notificationIDGenerator() {
    final random = Random();
    const MIN_ID = 100;
    const MAX_ID = 10000;
    return MIN_ID + random.nextInt(MAX_ID);
  }

}