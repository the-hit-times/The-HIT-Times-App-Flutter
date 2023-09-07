import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:the_hit_times_app/features/live/models/timelinemodel.dart';
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


  Timer? _timer;


  List<Timeline> items = [];

  // load timeline from the database
  void _loadTimeline() async {
    String url = "http://192.168.1.7:8000/api/live/match/${widget.matchFirebaseId}/timeline";
    var response = await Http.getBody(url, headers: {
      "Content-Type": "application/json"
    });
    var data = jsonDecode(response);
    data = data["timeline"];


    TimelineList timelineList = TimelineList.fromJson(data);

    setState(() {
      items = timelineList.timelines;
    });

  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTimeline();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _loadTimeline();
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 4.0, right: 16.0),
                child: Text(
                  items[index].getFormattedDate(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.grey,
                  )
                ),
              ),
              Container(
                child: Html(
                    data: items[index].msgHtml,
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
      },
    );
  }
}