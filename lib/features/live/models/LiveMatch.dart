import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Team {
  String? teamCode;
  String? teamScore;

  Team({required this.teamCode, required this.teamScore});

  final Map _codeToName = {
    "100": "CSE",
    "101": "IT",
    "102": "ECE",
    "103": "AEIE",
    "104": "EE",
    "105": "MECH",
    "106": "CIVIL",
    "107": "CHEMICAL",
    "108": "BT/FT",
    "109": "CSE CS",
    "110": "CSE DS",
    "111": "CSE AIML",
    "112": "MASTERS",
  };

  final Map _codeToFootballImage = {
    "100": "assets/images/football/cse.png",
    "101": "assets/images/football/it.jpg",
    "102": "assets/images/football/it.jpg",
    "103": "AEIE",
    "104": "assets/images/football/ee.png",
    "105": "MECH",
    "106": "assets/images/football/civil.png",
    "107": "assets/images/football/chemical.png",
    "108": "assets/images/football/bt_ft.png",
    "109": "CSE CS",
    "110": "CSE DS",
    "111": "assets/images/football/aiml.png",
    "112": "MASTERS",
  };

  // TODO: Not yet implemented
  final Map _codeToCricketImage = {
    "100": "assets/images/football/cse.png",
    "101": "assets/images/football/it.jpg",
    "102": "assets/images/football/it.jpg",
    "103": "AEIE",
    "104": "assets/images/football/ee.png",
    "105": "MECH",
    "106": "assets/images/football/civil.png",
    "107": "assets/images/football/chemical.png",
    "108": "assets/images/football/bt_ft.png",
    "109": "CSE CS",
    "110": "CSE DS",
    "111": "assets/images/football/aiml.png",
    "112": "MASTERS",
  };

  String getTeamName() {
    return _codeToName[teamCode] ?? teamCode;
  }

  String? getTeamFootballLogo() {
    return _codeToFootballImage[teamCode];
  }

  // TODO: Not yet implemented
  String? getTeamCricketLogo() {
    return _codeToCricketImage[teamCode];
  }

}

class LiveMatch {
  DateTime? matchDate;
  String? id;
  Team? team1;
  Team? team2;
  bool? isLive;
  String? matchStatus;
  String? matchType;

  static const FIELD_MATCH_DATE = "match_date";
  static const FIELD_TEAM_ONE = "team1";
  static const FIELD_TEAM_TWO = "team2";
  static const FIELD_TEAM_SCORE = "team_score";
  static const FIELD_TEAM_CODE = "team_code";
  static const FIELD_MATCH_LIVE = "is_live";
  static const FIELD_MATCH_STATUS = "match_status";
  static const FIELD_MATCH_TYPE = "match_type";

  LiveMatch(
      {this.id,
      required this.team1,
      required this.team2,
      required this.matchDate,
      required this.isLive,
      required this.matchStatus,
        required this.matchType
      });

  factory LiveMatch.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    // debugPrint(data.toString());

    final team1 = Team(
      teamCode: data?[FIELD_TEAM_ONE][FIELD_TEAM_CODE],
      teamScore: data?[FIELD_TEAM_ONE][FIELD_TEAM_SCORE],
    );

    final team2 = Team(
      teamCode: data?[FIELD_TEAM_TWO][FIELD_TEAM_CODE],
      teamScore: data?[FIELD_TEAM_TWO][FIELD_TEAM_SCORE],
    );

    return LiveMatch(
        id: snapshot.id,
        team1: team1,
        team2: team2,
        matchDate: DateTime.fromMillisecondsSinceEpoch(
            (data?[FIELD_MATCH_DATE] as Timestamp).millisecondsSinceEpoch),
        isLive: data?[FIELD_MATCH_LIVE],
        matchStatus: data?[FIELD_MATCH_STATUS],
        matchType: data?[FIELD_MATCH_TYPE]
    );
  }

  factory LiveMatch.fromNotification(
      RemoteMessage message
      ) {
    final data = jsonDecode(message.data["data"]);
    debugPrint("From factory: " + data.toString());

    final team1 = Team(
      teamCode: data[FIELD_TEAM_ONE][FIELD_TEAM_CODE],
      teamScore: data[FIELD_TEAM_ONE][FIELD_TEAM_SCORE],
    );

    final team2 = Team(
      teamCode: data[FIELD_TEAM_TWO][FIELD_TEAM_CODE],
      teamScore: data[FIELD_TEAM_TWO][FIELD_TEAM_SCORE],
    );

    return LiveMatch(
        id: data["matchId"],
        team1: team1,
        team2: team2,
        matchDate: DateTime.parse(data[FIELD_MATCH_DATE]),
        isLive: data[FIELD_MATCH_LIVE],
        matchStatus: data[FIELD_MATCH_STATUS],
        matchType: data[FIELD_MATCH_TYPE]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (team1 != null)
        FIELD_TEAM_ONE: {
          if (team1!.teamCode != null) FIELD_TEAM_CODE: team1!.teamCode,
          if (team1!.teamScore != null) FIELD_TEAM_SCORE: team1!.teamScore,
        },
      if (team2 != null)
        FIELD_TEAM_TWO: {
          if (team1!.teamCode != null) FIELD_TEAM_CODE: team2!.teamCode,
          if (team1!.teamScore != null) FIELD_TEAM_SCORE: team2!.teamScore,
        },
      if (matchDate != null) FIELD_MATCH_DATE: matchDate,
      if (isLive != null) FIELD_MATCH_LIVE: isLive,
      if (matchStatus != null) FIELD_MATCH_STATUS: matchStatus,
      if (matchType != null) FIELD_MATCH_TYPE: matchType,
    };
  }

  String formattedMatchDate() {
    return DateFormat.MMMEd().format(matchDate!);
  }
}
