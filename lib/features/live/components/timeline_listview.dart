import 'dart:async';
import 'dart:convert';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:the_hit_times_app/features/live/match_history.dart';
import 'package:the_hit_times_app/features/live/models/timelinemodel.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as html;

class TimelineListView extends StatefulWidget {
  const TimelineListView({Key? key, required this.matchFirebaseId}): super(key: key);


  final String matchFirebaseId;

  @override
  State<TimelineListView> createState() => _TimelineListViewState();
}

class _TimelineListViewState extends State<TimelineListView> {

  final LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FirestoreListView<Timeline>(
      padding: const EdgeInsets.only(top: 8.0),
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        emptyBuilder: (context) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedIconWidget(),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "No Timeline Matches",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
        pageSize: 4,
        query: _liveMatchRepo.getTimelines(widget.matchFirebaseId),
        itemBuilder: (context, doc) {
          final timeline = doc.data();
          return Card(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 0.0, right: 16.0),
                  child: Text(
                      timeline.getFormattedDate(),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey,
                      )
                  ),
                ),
                Container(
                  child: Html(
                      data: timeline.msgHtml,
                      style: {
                        "body" : Style(
                          color: Colors.white,
                          fontSize: FontSize(15.0),
                        ),
                        "a" : Style(
                          color: Colors.blue,
                        ),
                      },
                      onLinkTap:  (String? url, Map<String, String> attributes, html.Element? element,) {
                        if (url != null) {
                          _launchInBrowser(Uri.parse(url));
                        }
                      }
                  ),
                ),
              ],
            ),
          );
        });
  }
}