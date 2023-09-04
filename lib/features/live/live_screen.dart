import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/LiveMatch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/football_score_card.dart';

class LiveScreen extends StatelessWidget {
  static const ROUTE_NAME = "/live-screen";

  LiveScreen({super.key});

  LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  /*FirestoreListView<LiveMatch>(
          emptyBuilder: (context) {
            return Text("No data");
          },
          pageSize: 4,
          query: _liveMatchRepo.getLiveMatches(), itemBuilder: (context, doc) {
            final match = doc.data();
            return ListTile(
              title: Text("${match.team1?.getTeamName()} vs ${match.team2?.getTeamName()}",
              style: TextStyle(
                  color: Colors.white,
              ),
              ),
              subtitle: Text("${match.team1?.teamScore} vs ${match.team2?.teamScore}\n${match.isLive}",  style: TextStyle(
                color: Colors.white,
              ),),
            );
      }),*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FirestoreListView<LiveMatch>(
            emptyBuilder: (context) {
              return Text("No data");
            },
            pageSize: 4,
            query: _liveMatchRepo.getLiveMatches(),
            itemBuilder: (context, doc) {
              final match = doc.data();
              return FootballScoreCard(liveMatch: match);
            }),
      ),
    );
  }
}
