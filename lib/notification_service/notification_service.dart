import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:the_hit_times_app/database_helper.dart';
import 'package:the_hit_times_app/features/live/match_screen.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/models/notification.dart'
    as NotificationModel;
import 'package:the_hit_times_app/notidisplay.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const LIVE_NOTIFICATION_ID = 0;

  static late GlobalKey<NavigatorState> _navigatorKey;

  static void initialize(
      {required GlobalKey<NavigatorState> navigatorKey}) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/notification_icon"),
    );

    _navigatorKey = navigatorKey;

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    _requestNotificationPermission();
    _subscribeToTopics();
    printFCMToken();
  }

  static Future<dynamic> onSelectNotification(payload) async {
    if (payload != null) {
      var data = jsonDecode(payload);
      switch (data["type"]) {
        case "POST":
          _navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => NotificationDisplayWeb(
                    postId: data["id"],
                  )));
          break;
        case "LIVE":
          _navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => MatchScreen(
                    matchId: data["id"],
                  )));
          break;
      }
    }
  }

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

  static void _subscribeToTopics() async {
    await _messaging.subscribeToTopic("live_notification");
    await _messaging.subscribeToTopic("posts_notification");
  }

  static void show(RemoteMessage message) async {
    final http.Response response =
        await http.get(Uri.parse(message.notification!.android!.imageUrl!));

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

    var payload = jsonEncode({"id": message.data["postId"], "type": "POST"});

    await _notificationsPlugin.show(
      _notificationIDGenerator(),
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: payload,
    );
  }

  static void storeNotificationInDatabase(RemoteMessage message) async {
    await NotificationDatabase.instance.create(NotificationModel.Notification(
      imageUrl: message.notification!.android!.imageUrl!,
      title: message.notification!.title!,
      description: message.notification!.body!,
      createdTime: DateTime.now(),
      postId: message.data["postId"],
    ));
  }

  static void liveNotification(RemoteMessage message) async {
    var matchInfo = LiveMatch.fromNotification(message);

    var timelineMessage = jsonDecode(message.data["data"])["timeline_message"];
    var team1Name = matchInfo.team1?.getTeamName();
    var team2Name = matchInfo.team2?.getTeamName();
    var team1Score = matchInfo.team1?.teamScore;
    var team2Score = matchInfo.team2?.teamScore;
    var team1Penalty = matchInfo.team1?.teamPenalty;
    var team2Penalty = matchInfo.team2?.teamPenalty;

    var hasPenalty = (team1Penalty != null && team2Penalty != null) &&
        (team1Penalty != "0" || team2Penalty != "0") &&
        team1Score == team2Score;

    var title = "<b>$team1Name vs $team2Name</b>";
    var messageBody = "$team1Score vs $team2Score<br>";
    if (hasPenalty) {
      messageBody += "<br>Penalty Shootout: <br>";
      messageBody += "$team1Penalty vs $team2Penalty<br>";
    }
    if (timelineMessage != null) {
      messageBody += "<br>";
      messageBody += timelineMessage;
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("Live Notification",
          "Live updates for HIT football, cricket and various other matches.",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            messageBody,
            htmlFormatBigText: true,
            htmlFormatTitle: true,
            htmlFormatContent: true,
            contentTitle: title,
            htmlFormatContentTitle: true,
          )),
    );

    var payload = jsonEncode({"id": matchInfo.id, "type": "LIVE"});

    await _notificationsPlugin.show(
      LIVE_NOTIFICATION_ID,
      title,
      messageBody,
      notificationDetails,
      payload: payload,
    );
  }

  static int _notificationIDGenerator() {
    final random = Random();
    const minId = 100;
    const maxId = 10000;
    return minId + random.nextInt(maxId);
  }

  static void printFCMToken() async {
    String? token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
  }
}
