import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:the_hit_times_app/database_helper.dart';
import 'package:the_hit_times_app/features/live/match_history.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/match_screen.dart';
import 'package:the_hit_times_app/models/notification.dart' as NotificationModel;
import 'package:sqflite/sqflite.dart';
import 'package:the_hit_times_app/notidisplay.dart';
import 'package:the_hit_times_app/notify.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notificationsPlugin => _notificationsPlugin;

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const LIVE_NOTIFICATION_ID = 0;

  static late GlobalKey<NavigatorState> _navigatorKey;

  //  Initialise Flutter Local Notifications Plugin with AndroidInitializationSettings
  static void initialize({required GlobalKey<NavigatorState> navigatorKey}) async {

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/notification_icon"),
    );
    _navigatorKey = navigatorKey;
    _notificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    _requestNotificationPermission();
    _subscribeToTopics();
  }

  /// When a notification is tapped, this method is called.
  /// It is responsible for navigating to the respective screen
  /// based on the notification type.
  static Future<dynamic> onSelectNotification(payload) async {
    if (payload != null) {
      var data = jsonDecode(payload);
      switch (data["type"]) {
        case "POST":
          _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => NotificationDisplayWeb(postId: data["id"],)));
          break;
        case "LIVE":
          _navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => MatchScreen( matchId: data["id"],))
          );
          break;
      }
    }
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

        print(" hi ${message.notification!.android!.imageUrl!}");
        print(" hi2 ${message.notification!.title}");
        print(" hi3 ${message.notification!.body}");

        storeNotificationInDatabase(message);

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

    var payload = jsonEncode({
      "id": message.data["postId"],
      "type": "POST"
    });

    await _notificationsPlugin.show(
      _notificationIDGenerator(),
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: payload,
    );
  }

  static void storeNotificationInDatabase(RemoteMessage message) async {
    await NotificationDatabase.instance.create(
        NotificationModel.Notification(
          imageUrl: message.notification!.android!.imageUrl!,
          title: message.notification!.title!,
          description: message.notification!.body!,
          createdTime:  DateTime.now(),
          postId: message.data["postId"],)
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

    var timelineMessage = jsonDecode(message.data["data"])["timeline_message"];

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "Live Notification", "Live updates for HIT football, cricket and various other matches.",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
              timelineMessage != null ?
              "${matchInfo.team1?.teamScore} vs ${matchInfo.team2?.teamScore}<br><br>${timelineMessage}" :
              "${matchInfo.team1?.teamScore} vs ${matchInfo.team2?.teamScore}", htmlFormatBigText: true,
              htmlFormatTitle:true ,
              htmlFormatContent:true ,
              contentTitle: "${matchInfo.team1?.getTeamName()} vs ${matchInfo.team2?.getTeamName()}",
              htmlFormatContentTitle: true,
          )),
    );

    var payload = jsonEncode({
      "id": matchInfo.id,
      "type": "LIVE"
    });

   await _notificationsPlugin.show(
      LIVE_NOTIFICATION_ID,
      "<b>${matchInfo.team1?.getTeamName()} vs ${matchInfo.team2?.getTeamName()}</b>",
      "${matchInfo.team1?.teamScore} vs ${matchInfo.team2?.teamScore}",
      notificationDetails,
     payload: payload,
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