import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';
import 'package:the_hit_times_app/features/live/timeline_screen.dart';

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
        child: FirestoreListView<LiveMatch>(
            emptyBuilder: (context) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_soccer, color: Colors.white, size: 64,),
                    const SizedBox(height: 8.0,),
                    Text("No Live Matches", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),),
                  ],
                ),
              );
            },
            pageSize: 4,
            query: _liveMatchRepo.getLiveMatches(),
            itemBuilder: (context, doc) {
              final match = doc.data();
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: FootballScoreCard(liveMatch: match, onTap: () {
                  Navigator.of(context).pushNamed(TimelineScreen.ROUTE_NAME,
                      arguments:
                      TimelineScreenArguments(id: match.id!));
                },),
              );
            }),
      ),
      /*body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            runSpacing: 8.0,
            children: [
              FootballScoreCard(
                liveMatch: LiveMatch(
                  team1: Team(teamCode: "101", teamScore: "11"),
                  team2: Team(teamCode: "106", teamScore: "10"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Delayed due to rain.",
                  id: "S4mzZcHWIZ3iq0QkeTGy",
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(TimelineScreen.ROUTE_NAME,
                      arguments:
                          TimelineScreenArguments(id: "S4mzZcHWIZ3iq0QkeTGy"));
                },
              ),
              FootballScoreCard(
                  liveMatch: LiveMatch(
                team1: Team(teamCode: "101", teamScore: "0"),
                team2: Team(teamCode: "100", teamScore: "1"),
                isLive: true,
                matchDate: DateTime.now(),
                matchType: "Football",
                matchStatus: "Half-Time",
                id: "NxUp0yyXlQNe0If9dAPO",
              )),
            ],
          ),
        ),
      ),*/
    );
  }
}
