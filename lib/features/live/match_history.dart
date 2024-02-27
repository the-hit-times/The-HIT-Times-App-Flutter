import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';
import 'package:the_hit_times_app/features/live/match_screen.dart';

import 'components/cricket_score_card.dart';
import 'components/football_score_card.dart';

class MatchHistoryScreen extends StatefulWidget {
  static const ROUTE_NAME = "/live-screen";

  MatchHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {

  final LiveMatchRepo _liveMatchRepo = LiveMatchRepo();
  bool _isOffline = false;

  void _isDeviceOffline() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
       setState(() {
          _isOffline = true;
       });
    } else {
      setState(() {
        _isOffline = false;
      });
    }
  }

  @override
  void initState() {
    _isDeviceOffline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Matches'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Color.fromARGB(255, 7, 95, 115),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              child: const TabBar(
                indicatorWeight: 3.0,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.sports_soccer),
                    child: Text(
                      "Football",
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.sports_cricket),
                    child: Text(
                      "Cricket",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SafeArea(
            child: _isOffline ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnimatedIconWidget(),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "No Internet Connection",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  FilledButton.icon(
                      onPressed: _isDeviceOffline,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry")
                  )
                ],
              ),
            ) : TabBarView(
              children: [
                FirestoreListView<LiveMatch>(
                  emptyBuilder: (context) {
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
                  },
                  errorBuilder: (context, error, stackTrace) {
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
                            "Failed to load live matches",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                FirestoreListView<LiveMatch>(
                  emptyBuilder: (context) {
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
                  query: _liveMatchRepo.getCrickLiveMatches(),
                  itemBuilder: (context, doc) {
                    final match = doc.data();
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: CricketScoreCard(
                        liveMatch: match,
                        onTap: () {
                          Navigator.of(context).pushNamed(MatchScreen.ROUTE_NAME,
                              arguments: MatchScreenArguments(id: match.id!));
                        },
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
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
                            "Failed to load live matches",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
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
        color: Colors.grey,
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
