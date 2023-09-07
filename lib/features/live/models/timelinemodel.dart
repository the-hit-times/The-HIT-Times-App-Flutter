import 'dart:core';

import 'package:intl/intl.dart';

class Timeline {
  String id;
  String? msgHtml;
  DateTime timelineDate;

  Timeline({
    required this.id,
    this.msgHtml,
    required this.timelineDate,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      id: json['_id'],
      msgHtml: json['msgHtml'],
      timelineDate: DateTime.parse(json['timeline_date']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['msgHtml'] = msgHtml;
    data['timeline_date'] = timelineDate.toIso8601String();
    return data;
  }
  
  String getFormattedDate() {
    return "${DateFormat("EEEE, MMM dd").format(timelineDate)} \u00B7 ${DateFormat.jm().format(timelineDate)}";
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