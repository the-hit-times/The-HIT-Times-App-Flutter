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
  static const String ROUTE_NAME = "/live-screen";

  const MatchHistoryScreen({super.key});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  final LiveMatchRepo _liveMatchRepo = LiveMatchRepo();
  bool _isOffline = false;
  int? _selectedYear;
  late List<int> _years;
  String? _errorMessage;

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      setState(() {
        _isOffline = connectivityResult == ConnectivityResult.none;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check connectivity: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    final currentYear = DateTime.now().year;
    _years = List.generate(5, (index) => currentYear - index);
    _selectedYear = currentYear;
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
                  if (newValue != null) {
                    setState(() => _selectedYear = newValue);
                  }
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
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: TabBar(
              indicatorWeight: 3.0,
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.sports_soccer), text: "Football"),
                Tab(icon: Icon(Icons.sports_cricket), text: "Cricket"),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SafeArea(
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!);
    }
    if (_isOffline) {
      return _buildOfflineWidget();
    }
    return TabBarView(
      children: [
        _buildMatchList(_liveMatchRepo.getLiveMatches(), isFootball: true),
        _buildMatchList(_liveMatchRepo.getCrickLiveMatches(),
            isFootball: false),
      ],
    );
  }

  Widget _buildOfflineWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnimatedIconWidget(),
          const SizedBox(height: 8.0),
          Text(
            "No Internet Connection",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8.0),
          FilledButton.icon(
            onPressed: _checkConnectivity,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchList(Query<LiveMatch> baseQuery,
      {required bool isFootball}) {
    return FirestoreListView<LiveMatch>(
      pageSize: 4,
      query: baseQuery.where(
        LiveMatch.FIELD_MATCH_DATE,
        isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(_selectedYear!)),
        isLessThan: Timestamp.fromDate(DateTime(_selectedYear! + 1)),
      ),
      itemBuilder: (context, doc) {
        final match = doc.data();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: isFootball
              ? FootballScoreCard(
                  liveMatch: match,
                  onTap: () => _navigateToMatchScreen(match.id!),
                )
              : CricketScoreCard(
                  liveMatch: match,
                  onTap: () => _navigateToMatchScreen(match.id!),
                ),
        );
      },
      emptyBuilder: (_) => _buildEmptyWidget(),
      errorBuilder: (_, error, __) => _buildErrorWidget(error.toString()),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
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
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnimatedIconWidget(),
          const SizedBox(height: 8.0),
          Text(
            "Error: $error",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToMatchScreen(String matchId) {
    Navigator.of(context).pushNamed(
      MatchScreen.ROUTE_NAME,
      arguments: MatchScreenArguments(id: matchId),
    );
  }
}

class AnimatedIconWidget extends StatefulWidget {
  const AnimatedIconWidget({super.key});

  @override
  State<AnimatedIconWidget> createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget> {
  int _index = 0;
  Timer? _timer;
  static const List<IconData> _icons = [
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_cricket,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _index = (_index + 1) % _icons.length);
      }
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
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        _icons[_index],
        key: ValueKey<int>(_index),
        size: 60.0,
        color: Colors.grey,
      ),
    );
  }
}
