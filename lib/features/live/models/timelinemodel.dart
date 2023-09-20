import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Timeline {
  String? id;
  String? msgHtml;
  DateTime? timelineDate;

  Timeline({
    required this.id,
    this.msgHtml,
    required this.timelineDate,
  });

  static const FIELD_ID = "_id";
  static const FIELD_MSG_HTML = "msgHtml";
  static const FIELD_TIMELINE_DATE = "timeline_date";

  factory Timeline.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Timeline(
      id: snapshot.id,
      msgHtml: data?[FIELD_MSG_HTML],
      timelineDate: DateTime.fromMillisecondsSinceEpoch(
          (data?[FIELD_TIMELINE_DATE] as Timestamp).millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (msgHtml != null) FIELD_MSG_HTML: msgHtml,
      if (timelineDate != null) FIELD_TIMELINE_DATE: timelineDate,
      if (id != null) FIELD_ID: id,
    };
  }


  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      id: json[FIELD_ID],
      msgHtml: json[FIELD_MSG_HTML],
      timelineDate: DateTime.parse(json[FIELD_TIMELINE_DATE]),
    );
  }


  
  String getFormattedDate() {
    return "${DateFormat("EEEE, MMM dd").format(timelineDate!)} \u00B7 ${DateFormat.jm().format(timelineDate!)}";
  }
  
}

class TimelineList {
  final List<Timeline> timelines;

  TimelineList({
    required this.timelines,
  });

  factory TimelineList.fromJson(List<dynamic> parsedJson) {
    List<Timeline> posts = <Timeline>[];
    posts = parsedJson.map((i) => Timeline.fromJson(i)).toList();

    return TimelineList(
      timelines: posts,
    );
  }
}