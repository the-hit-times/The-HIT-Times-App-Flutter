import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Team {
  final String? teamCode;
  final String? teamScore;
  final String? teamPenalty;

  Team({
    required this.teamCode,
    required this.teamScore,
    required this.teamPenalty,
  });

  static const Map<String, String> _codeToName = {
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

  static const Map<String, String> _codeToFootballImage = {
    "100":
        "https://drive.google.com/file/d/1wqZR93KPy9MZ3R0HTxy9BxRCy_fqJadf/view?usp=drive_link",
    "101":
        "https://drive.google.com/file/d/144jjcBnP8zA0FuWyESWXI36Ki0gtWvhE/view?usp=drive_link",
    "102":
        "https://drive.google.com/file/d/1HMG_MxHBQBf8eKYo_5mOftu4yFOmLp6M/view?usp=drive_link",
    "103":
        "https://drive.google.com/file/d/11F2Lhy4ldNfDXTPlc6_u7QC7yA-4UBFQ/view?usp=drive_link",
    "104":
        "https://drive.google.com/file/d/1_ej_C4URenZcLZ5me_GLB8KWJ0_7-ecl/view?usp=drive_link",
    "105":
        "https://drive.google.com/file/d/1-F5F-G0py1-iBc_DO-KHVEj8Ab70kO9_/view?usp=drive_link",
    "106":
        "https://drive.google.com/file/d/1E3L7hJaT0jw22aT4VM9m0T6WypWLuV5s/view?usp=drive_link",
    "107":
        "https://drive.google.com/file/d/1Y_Ob8lKyX_rGph9RZpU7lJO9NNYVVzTq/view?usp=drive_link",
    "108":
        "https://drive.google.com/file/d/1ekwOSkFgspwF1N3mPmOtd-ov3g_H6hJV/view?usp=drive_link",
    "109":
        "https://drive.google.com/file/d/1RCJN4tjXR9e4oMYosU56CSiReK4gIi60/view?usp=drive_link",
    "110":
        "https://drive.google.com/file/d/1bgWdM45WkDYYLh6vQSl1-83KTLeW0Gow/view?usp=drive_link",
    "111":
        "https://drive.google.com/file/d/1c4_hDng2y7rCJUjO7iGsXyekzK3KMUkR/view?usp=drive_link",
    "112":
        "https://drive.google.com/file/d/1wLghT_Sf2DPckPFIjVBtuP7lCj0BV7ln/view?usp=drive_link",
  };

  static const Map<String, String> _codeToCricketImage = {
    "100":
        "https://drive.google.com/file/d/1WodEFgrzjW_jKnXFS1LSlDNutgf_fCZq/view?usp=drive_link",
    "101":
        "https://drive.google.com/file/d/1oYo2eJx8ndP9BwsqTE4LHrmWAnqL79qw/view?usp=drive_link",
    "102":
        "https://drive.google.com/file/d/1TuxonuWMRJJQ1n2A5ezQSDiU4czoV0eU/view?usp=drive_link",
    "103":
        "https://drive.google.com/file/d/1vBkpkJpktYEJlOWrGmYpdg3Qbs5FTp_n/view?usp=drive_link",
    "104":
        "https://drive.google.com/file/d/1j0UIualNr-vO-WGsjtfFjtNA7AOnd7pL/view?usp=drive_link",
    "105":
        "https://drive.google.com/file/d/1b2Cu-t2OeofAyvvRgDITJPIA72NZg64s/view?usp=drive_link",
    "106":
        "https://drive.google.com/file/d/1NL2UbiBjn4YD85IPklaHzK8dDYTCA4AC/view?usp=drive_link",
    "107":
        "https://drive.google.com/file/d/1vyvxY2fJ0aXSFqKhAC4off-Fqhn6F15q/view?usp=drive_link",
    "108":
        "https://drive.google.com/file/d/1t7ukG6SCJNX27PInnRiYPxaBvu9ZZtb8/view?usp=drive_link",
    "109":
        "https://drive.google.com/file/d/1nlYJsd2SzSSelbAx0_E7ew0dM0peYzEP/view?usp=drive_link",
    "110":
        "https://drive.google.com/file/d/1AjX32UYvnPqf_RsI4GgALpqgWdJVSGMq/view?usp=drive_link",
    "111":
        "https://drive.google.com/file/d/1N3SXswlClxPU5Cu3V56BMRVD3pwPUDhI/view?usp=drive_link",
    "112":
        "https://drive.google.com/file/d/134MS61GXJvhXF0hbHp65DJvQ86jc5b1q/view?usp=drive_link",
  };

  String getTeamName() => _codeToName[teamCode] ?? teamCode ?? 'Unknown Team';

  String getTeamFootballLogo() {
    return _getImageUrl(_codeToFootballImage[teamCode]);
  }

  String getTeamCricketLogo() {
    return _getImageUrl(_codeToCricketImage[teamCode]);
  }

  String _getImageUrl(String? driveLink) {
    if (driveLink == null || driveLink.isEmpty) return '';
    try {
      final fileId = driveLink.split('/d/')[1].split('/view')[0];
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    } catch (e) {
      if (kDebugMode) print('Error parsing image URL: $e');
      return '';
    }
  }
}

class LiveMatch {
  final String? id;
  final Team? team1;
  final Team? team2;
  final DateTime? matchDate;
  final bool? isLive;
  final String? matchStatus;
  final String? matchType;

  static const String FIELD_MATCH_DATE = "match_date";
  static const String fieldTeamOne = "team1";
  static const String fieldTeamTwo = "team2";
  static const String fieldTeamScore = "team_score";
  static const String fieldTeamCode = "team_code";
  static const String fieldTeamPenalty = "team_penalty";
  static const String FIELD_MATCH_LIVE = "is_live";
  static const String fieldMatchStatus = "match_status";
  static const String FIELD_MATCH_TYPE = "match_type";

  LiveMatch({
    this.id,
    required this.team1,
    required this.team2,
    required this.matchDate,
    required this.isLive,
    required this.matchStatus,
    required this.matchType,
  });

  factory LiveMatch.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw const FormatException('Firestore document data is null');
    }

    return LiveMatch(
      id: snapshot.id,
      team1: _parseTeam(data[fieldTeamOne]),
      team2: _parseTeam(data[fieldTeamTwo]),
      matchDate: _parseTimestamp(data[FIELD_MATCH_DATE]),
      isLive: data[FIELD_MATCH_LIVE] as bool? ?? false,
      matchStatus: data[fieldMatchStatus] as String? ?? 'Unknown',
      matchType: data[FIELD_MATCH_TYPE] as String? ?? 'Unknown',
    );
  }

  factory LiveMatch.fromNotification(RemoteMessage message) {
    try {
      final data = jsonDecode(message.data["data"]) as Map<String, dynamic>;
      return LiveMatch(
        id: data["id"] as String?,
        team1: _parseTeam(data[fieldTeamOne]),
        team2: _parseTeam(data[fieldTeamTwo]),
        matchDate: DateTime.tryParse(data[FIELD_MATCH_DATE] as String? ?? '') ??
            DateTime.now(),
        isLive: data[FIELD_MATCH_LIVE] as bool? ?? false,
        matchStatus: data[fieldMatchStatus] as String? ?? 'Unknown',
        matchType: data[FIELD_MATCH_TYPE] as String? ?? 'Unknown',
      );
    } catch (e) {
      if (kDebugMode) print('Error parsing notification: $e');
      throw FormatException('Failed to parse notification data: $e');
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (team1 != null)
        fieldTeamOne: {
          if (team1!.teamCode != null) fieldTeamCode: team1!.teamCode,
          if (team1!.teamScore != null) fieldTeamScore: team1!.teamScore,
          if (team1!.teamPenalty != null) fieldTeamPenalty: team1!.teamPenalty,
        },
      if (team2 != null)
        fieldTeamTwo: {
          if (team2!.teamCode != null) fieldTeamCode: team2!.teamCode,
          if (team2!.teamScore != null) fieldTeamScore: team2!.teamScore,
          if (team2!.teamPenalty != null) fieldTeamPenalty: team2!.teamPenalty,
        },
      if (matchDate != null) FIELD_MATCH_DATE: Timestamp.fromDate(matchDate!),
      if (isLive != null) FIELD_MATCH_LIVE: isLive,
      if (matchStatus != null) fieldMatchStatus: matchStatus,
      if (matchType != null) FIELD_MATCH_TYPE: matchType,
    };
  }

  String formattedMatchDate() {
    return matchDate != null
        ? DateFormat.MMMEd().format(matchDate!)
        : 'Date unavailable';
  }

  String formattedMatchTime() {
    return matchDate != null
        ? DateFormat.jm().format(matchDate!)
        : 'Time unavailable';
  }

  static Team _parseTeam(dynamic teamData) {
    if (teamData is! Map<String, dynamic>) {
      return Team(teamCode: null, teamScore: null, teamPenalty: null);
    }
    return Team(
      teamCode: teamData[fieldTeamCode] as String?,
      teamScore: teamData[fieldTeamScore] as String?,
      teamPenalty: teamData[fieldTeamPenalty] as String?,
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateTime.fromMillisecondsSinceEpoch(
          timestamp.millisecondsSinceEpoch);
    }
    return DateTime.now();
  }
}
