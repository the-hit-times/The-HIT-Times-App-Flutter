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
    "107": "CHE",
    "108": "BT/FT+AGE",
    "109": "CSE CS",
    "110": "CSE DS",
    "111": "CSE AIML",
    "112": "MASTERS",
  };

  final Map _codeToFootballImage = {
    "100": "https://drive.google.com/file/d/1wqZR93KPy9MZ3R0HTxy9BxRCy_fqJadf/view?usp=drive_link", // CSE
    "101": "https://drive.google.com/file/d/144jjcBnP8zA0FuWyESWXI36Ki0gtWvhE/view?usp=drive_link", // IT
    "102": "https://drive.google.com/file/d/1HMG_MxHBQBf8eKYo_5mOftu4yFOmLp6M/view?usp=drive_link", // ECE
    "103": "https://drive.google.com/file/d/11F2Lhy4ldNfDXTPlc6_u7QC7yA-4UBFQ/view?usp=drive_link", // AEIE
    "104": "https://drive.google.com/file/d/1_ej_C4URenZcLZ5me_GLB8KWJ0_7-ecl/view?usp=drive_link", // EE
    "105": "https://drive.google.com/file/d/1-F5F-G0py1-iBc_DO-KHVEj8Ab70kO9_/view?usp=drive_link", // MECH
    "106": "https://drive.google.com/file/d/1E3L7hJaT0jw22aT4VM9m0T6WypWLuV5s/view?usp=drive_link", // CIVIL
    "107": "https://drive.google.com/file/d/1Y_Ob8lKyX_rGph9RZpU7lJO9NNYVVzTq/view?usp=drive_link", // CHEMICAL
    "108": "https://drive.google.com/file/d/1ekwOSkFgspwF1N3mPmOtd-ov3g_H6hJV/view?usp=drive_link", // BT/FT+AGE
    "109": null, // CSE CS
    "110": "https://drive.google.com/file/d/1bgWdM45WkDYYLh6vQSl1-83KTLeW0Gow/view?usp=drive_link", // CSE DS
    "111": "https://drive.google.com/file/d/1c4_hDng2y7rCJUjO7iGsXyekzK3KMUkR/view?usp=drive_link", // CSE AIML
    "112": "https://drive.google.com/file/d/1wLghT_Sf2DPckPFIjVBtuP7lCj0BV7ln/view?usp=drive_link", // MASTERS
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

  /// Converts the Google Drive link to a image link that can be used in CachedNetworkImage
  String? getTeamFootballLogo() {
    if (_codeToFootballImage[teamCode] == null) {
      return "";
    }
    String fileId = _codeToFootballImage[teamCode].substring(_codeToFootballImage[teamCode].indexOf('/d/') + 3, _codeToFootballImage[teamCode].indexOf('/view'));
    String newLink = 'https://drive.google.com/uc?export=view&id=$fileId';
    return newLink;
  }

  // TODO: Not yet implemented
  String? getTeamCricketLogo() {
    throw UnimplementedError();
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
        id: data["id"],
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

  String formattedMatchTime() {
    return DateFormat.jm().format(matchDate!);
  }

}
