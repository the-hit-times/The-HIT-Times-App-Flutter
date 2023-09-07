import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/football_score_card.dart';
import 'components/timeline_listview.dart';

class TimelineScreenArguments {
  final String id;

  TimelineScreenArguments({required this.id});
}

class TimelineScreen extends StatelessWidget {
  static const ROUTE_NAME = "/live-screen/timeline";

  TimelineScreen({super.key});

  LiveMatchRepo _liveMatchRepo = LiveMatchRepo();


  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TimelineScreenArguments;

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
      /* body: SafeArea(
        child: FirestoreListView<LiveMatch>(
            emptyBuilder: (context) {
              return Text("No data");
            },
            pageSize: 4,
            query: _liveMatchRepo.getLiveMatches(),
            itemBuilder: (context, doc) {
              final match = doc.data();
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: FootballScoreCard(liveMatch: match),
              );
            }),
      ),*/
      body: SafeArea(
        child: SingleChildScrollView(
          child:

          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _liveMatchRepo.getLiveMatchById(args.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                final match = LiveMatch.fromFirestore(snapshot.data!, null);
                return Wrap(
                  runSpacing: 8.0,
                  children: [
                    FootballScoreCard(liveMatch: match),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text("TIMELINE", style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TimelineListView(matchFirebaseId: args.id),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),




        ),
      ),
    );
  }
}
