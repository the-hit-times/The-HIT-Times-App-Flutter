import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/football_score_card.dart';
import 'components/timeline_listview.dart';

class MatchScreenArguments {
  final String id;

  MatchScreenArguments({required this.id});
}

class MatchScreen extends StatelessWidget {
  static const ROUTE_NAME = "/live-screen/timeline";

  String? matchId;

  MatchScreen({super.key, this.matchId});

  LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MatchScreenArguments?;

    if (matchId == null && args != null) {
      matchId = args.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('The HIT Times'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _liveMatchRepo.getLiveMatchById(matchId!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                final match = LiveMatch.fromFirestore(snapshot.data!, null);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FootballScoreCard(liveMatch: match),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("TIMELINE",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TimelineListView(matchFirebaseId: matchId!),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
