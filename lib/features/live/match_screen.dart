import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_hit_times_app/features/live/components/team_list.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/football_score_card.dart';
import 'components/timeline_listview.dart';
import 'match_history.dart';

class MatchScreenArguments {
  final String id;

  MatchScreenArguments({required this.id});
}

class MatchScreen extends StatefulWidget {
  static const ROUTE_NAME = "/live-screen/timeline";

  String? matchId;

  MatchScreen({super.key, this.matchId});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  /// Handles the share button on the app bar
  /// It takes a screenshot of the score card and shares it.
  void handleShareButton() async {
    screenshotController.capture().then((Uint8List? value) async {
      if (value == null) return;

      // make a XFile from the bytes
      final path = await storeFileTemporarily(value);
      await Share.shareXFiles(
        [XFile(path)],
        text:
            """THT Khabri: Know about the buzz around campus, as it happens with light speed.
Get the latest updates, accurate and earliest... delivered specially for you.
Download now:https://play.google.com/store/apps/details?id=com.thehittimes.tht&hl=en-IN"""
                .trim(),
      );
    });
  }

  /// store the image generate from the ScreenShotController
  /// in a temporary directory.
  Future<String> storeFileTemporarily(Uint8List image) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/score_card.png';
    final file = await File(path).create();
    file.writeAsBytesSync(image);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MatchScreenArguments?;

    if (widget.matchId == null && args != null) {
      widget.matchId = args.id;
    }

    // This is a edge case when app loads from live screen from the match id
    // It should never happen
    if (widget.matchId == null && args == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("The HIT Times"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _liveMatchRepo.getLiveMatchById(widget.matchId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnimatedIconWidget(),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Failed to load live match",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            final match = LiveMatch.fromFirestore(snapshot.data!, null);
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text("The HIT Times"),
                    centerTitle: true,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Color.fromARGB(255, 7, 95, 115),
                    expandedHeight: 220.0,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: handleShareButton,
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: Screenshot(
                              controller: screenshotController,
                              child: FootballScoreCard(
                                  liveMatch: match,
                                  backgroundColor:
                                      Color.fromARGB(255, 7, 95, 115))),
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50.0),
                      child: Container(
                        color: const Color.fromARGB(255, 7, 95, 115),
                        child: const TabBar(
                          indicatorWeight: 3.0,
                          indicatorColor: Colors.white,
                          tabs: [
                            Tab(
                              child: Text(
                                "Timeline",
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Team",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  TimelineListView(matchFirebaseId: widget.matchId!),
                  TeamList(
                      team1Code: match.team1!.teamCode!,
                      team2Code: match.team2!.teamCode!)
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
