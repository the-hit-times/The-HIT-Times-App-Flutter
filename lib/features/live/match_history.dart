import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/match_screen.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/cricket_score_card.dart';
import 'components/football_score_card.dart';

class MatchHistoryScreen extends StatefulWidget {
  static const ROUTE_NAME = "/live-screen";

  const MatchHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  final LiveMatchRepo _liveMatchRepo = LiveMatchRepo();
  bool _isOffline = false;
  int? _selectedYear;
  late List<int> _years;

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
    // Generate years list (e.g., last 5 years)
    int currentYear = DateTime.now().year;
    _years = List.generate(5, (index) => currentYear - index);
    _selectedYear = currentYear; // Default to current year
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Matches'),
              DropdownButton<int>(
                value: _selectedYear,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: const Color.fromARGB(255, 7, 95, 115),
                style: const TextStyle(color: Colors.white),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                },
                items: _years.map<DropdownMenuItem<int>>((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(
                      year.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 7, 95, 115),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              child: const TabBar(
                indicatorWeight: 3.0,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.sports_soccer),
                    child: Text("Football"),
                  ),
                  Tab(
                    icon: Icon(Icons.sports_cricket),
                    child: Text("Cricket"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SafeArea(
            child: _isOffline
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnimatedIconWidget(),
                        const SizedBox(height: 8.0),
                        Text(
                          "No Internet Connection",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 8.0),
                        FilledButton.icon(
                          onPressed: _isDeviceOffline,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        )
                      ],
                    ),
                  )
                : TabBarView(
                    children: [
                      FirestoreListView<LiveMatch>(
                        emptyBuilder: (context) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AnimatedIconWidget(),
                                const SizedBox(height: 8.0),
                                Text(
                                  "No Live Matches",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                        pageSize: 4,
                        query: _liveMatchRepo.getLiveMatches().where(
                            LiveMatch.FIELD_MATCH_DATE,
                            isGreaterThanOrEqualTo:
                                Timestamp.fromDate(DateTime(_selectedYear!)),
                            isLessThan: Timestamp.fromDate(
                                DateTime(_selectedYear! + 1))),
                        itemBuilder: (context, doc) {
                          final match = doc.data();
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 8),
                            child: FootballScoreCard(
                              liveMatch: match,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MatchScreen.ROUTE_NAME,
                                    arguments:
                                        MatchScreenArguments(id: match.id!));
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
                                const SizedBox(height: 8.0),
                                Text(
                                  "Failed to load live matches: $error",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.grey),
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
                                const SizedBox(height: 8.0),
                                Text(
                                  "No Live Matches",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                        pageSize: 4,
                        query: _liveMatchRepo.getCrickLiveMatches().where(
                            LiveMatch.FIELD_MATCH_DATE,
                            isGreaterThanOrEqualTo:
                                Timestamp.fromDate(DateTime(_selectedYear!)),
                            isLessThan: Timestamp.fromDate(
                                DateTime(_selectedYear! + 1))),
                        itemBuilder: (context, doc) {
                          final match = doc.data();
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 8),
                            child: CricketScoreCard(
                              liveMatch: match,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MatchScreen.ROUTE_NAME,
                                    arguments:
                                        MatchScreenArguments(id: match.id!));
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
                                const SizedBox(height: 8.0),
                                Text(
                                  "Failed to load live matches: $error",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
