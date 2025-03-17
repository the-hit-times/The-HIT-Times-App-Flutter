import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_hit_times_app/features/live/components/team_list.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';

import 'components/cricket_score_card.dart';
import 'components/football_score_card.dart';
import 'components/timeline_listview.dart';

class MatchScreenArguments {
  final String id;

  const MatchScreenArguments({required this.id});
}

class MatchScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/live-screen/timeline";

  final String? matchId;

  const MatchScreen({super.key, this.matchId});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  Future<void> _handleShareButton(LiveMatch match) async {
    try {
      final image = await screenshotController.capture();
      if (image == null) {
        _showSnackBar('Failed to capture screenshot');
        return;
      }

      final path = await _storeFileTemporarily(image);
      await Share.shareXFiles(
        [XFile(path)],
        text:
            """THT Khabri: Know about the buzz around campus, as it happens with light speed.
Get the latest updates, accurate and earliest... delivered specially for you.
Download now: https://play.google.com/store/apps/details?id=com.thehittimes.tht&hl=en-IN"""
                .trim(),
      );
    } catch (e) {
      _showSnackBar('Error sharing match: $e');
    }
  }

  Future<String> _storeFileTemporarily(Uint8List image) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/score_card.png';
    final file = await File(path).create();
    await file.writeAsBytes(image);
    return path;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as MatchScreenArguments?;
    final effectiveMatchId = widget.matchId ?? args?.id;

    if (effectiveMatchId == null) {
      return Scaffold(
        appBar: _buildAppBar(null),
        body: const Center(child: Text('No match ID provided')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _liveMatchRepo.getLiveMatchById(effectiveMatchId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _buildErrorWidget(
                  'Failed to load match: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return _buildErrorWidget('Match data not found');
            }

            final match = LiveMatch.fromFirestore(snapshot.data!, null);
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text("The HIT Times"),
                  centerTitle: true,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: const Color.fromARGB(255, 7, 95, 115),
                  expandedHeight: 220.0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _handleShareButton(match),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        child: Screenshot(
                          controller: screenshotController,
                          child: _getScoreCard(match),
                        ),
                      ),
                    ),
                  ),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: TabBar(
                      indicatorWeight: 3.0,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(text: "Timeline"),
                        Tab(text: "Team"),
                      ],
                    ),
                  ),
                ),
              ],
              body: _buildTabBarView(match, effectiveMatchId),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(LiveMatch? match) {
    return AppBar(
      title: const Text("The HIT Times"),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 95, 115),
      actions: match != null
          ? [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _handleShareButton(match),
              ),
            ]
          : null,
    );
  }

  Widget _getScoreCard(LiveMatch match) {
    switch (match.matchType?.toLowerCase()) {
      case 'football':
        return FootballScoreCard(
          liveMatch: match,
          backgroundColor: const Color.fromARGB(255, 7, 95, 115),
        );
      case 'cricket':
        return CricketScoreCard(
          liveMatch: match,
          backgroundColor: const Color.fromARGB(255, 7, 95, 115),
        );
      default:
        return const Center(child: Text('Unknown match type'));
    }
  }

  Widget _buildTabBarView(LiveMatch match, String matchId) {
    final team1Code = match.team1?.teamCode;
    final team2Code = match.team2?.teamCode;
    final matchType = match.matchType;

    if (team1Code == null || team2Code == null || matchType == null) {
      return _buildErrorWidget(
          'Invalid match data: Missing team codes or match type');
    }

    return TabBarView(
      children: [
        TimelineListView(matchFirebaseId: matchId),
        TeamList(
          team1Code: team1Code,
          team2Code: team2Code,
          matchType: matchType,
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message) {
    return Scaffold(
      appBar: _buildAppBar(null),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedIconWidget(),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
