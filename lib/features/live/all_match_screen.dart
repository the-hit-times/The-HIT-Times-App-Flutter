import 'dart:async';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';
import 'package:the_hit_times_app/features/live/match_screen.dart';

import 'components/football_score_card.dart';

class LiveScreen extends StatelessWidget {
  static const ROUTE_NAME = "/live-screen";

  LiveScreen({super.key});

  LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

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
                    AnimatedIconWidget(),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "No Live Matches",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
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
                child: FootballScoreCard(
                  liveMatch: match,
                  onTap: () {
                    Navigator.of(context).pushNamed(MatchScreen.ROUTE_NAME,
                        arguments: MatchScreenArguments(id: match.id!));
                  },
                ),
              );
            }),
      ),
      /*body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 8.0,
              children: [
                FootballScoreCard(
                  liveMatch: LiveMatch(
                    team1: Team(teamCode: "100", teamScore: "11"),
                    team2: Team(teamCode: "101", teamScore: "10"),
                    isLive: true,
                    matchDate: DateTime.now(),
                    matchType: "Football",
                    matchStatus: "Delayed due to rain.",
                    id: "",
                  ),
                ),
                FootballScoreCard(
                    liveMatch: LiveMatch(
                  team1: Team(teamCode: "102", teamScore: "0"),
                  team2: Team(teamCode: "103", teamScore: "1"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Half-Time",
                  id: "",
                )),
                FootballScoreCard(
                    liveMatch: LiveMatch(
                  team1: Team(teamCode: "104", teamScore: "0"),
                  team2: Team(teamCode: "105", teamScore: "0"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Full-Time",
                  id: "",
                )),
                FootballScoreCard(
                    liveMatch: LiveMatch(
                  team1: Team(teamCode: "106", teamScore: "0"),
                  team2: Team(teamCode: "107", teamScore: "0"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Full-Time",
                  id: "",
                )),
                FootballScoreCard(
                    liveMatch: LiveMatch(
                  team1: Team(teamCode: "108", teamScore: "0"),
                  team2: Team(teamCode: "109", teamScore: "0"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Full-Time",
                  id: "",
                )),
                FootballScoreCard(
                    liveMatch: LiveMatch(
                  team1: Team(teamCode: "110", teamScore: "0"),
                  team2: Team(teamCode: "111", teamScore: "0"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Full-Time",
                  id: "",
                )),
                FootballScoreCard(
                    liveMatch: LiveMatch(
                  team1: Team(teamCode: "112", teamScore: "0"),
                  team2: Team(teamCode: "112", teamScore: "0"),
                  isLive: true,
                  matchDate: DateTime.now(),
                  matchType: "Football",
                  matchStatus: "Full-Time",
                  id: "",
                )),
              ],
            ),
          ),
        ),
      ),*/
    );
  }

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
}

class AnimatedIconWidget extends StatefulWidget {
  const AnimatedIconWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedIconWidget> createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget> {
  int index = 0;
  Timer? _timer;

  dynamic icons = [
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_cricket,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        index = (index + 1) % 3;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Icon(
        icons[index],
        key: ValueKey<int>(index),
        size: 60.0,
        color: Colors.white,
      ),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
