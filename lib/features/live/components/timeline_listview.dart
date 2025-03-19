import 'dart:async';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html;
import 'package:the_hit_times_app/features/live/models/timelinemodel.dart';
import 'package:the_hit_times_app/features/live/repo/live_match_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class TimelineListView extends StatefulWidget {
  const TimelineListView({Key? key, required this.matchFirebaseId})
      : super(key: key);

  final String matchFirebaseId;

  @override
  State<TimelineListView> createState() => _TimelineListViewState();
}

class _TimelineListViewState extends State<TimelineListView>
    with AutomaticKeepAliveClientMixin {
  final LiveMatchRepo _liveMatchRepo = LiveMatchRepo();

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF071F2A), Color(0xFF0A3D62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FirestoreListView<Timeline>(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        emptyBuilder: (context) => _buildEmptyWidget(),
        pageSize: 4,
        query: _liveMatchRepo.getTimelines(widget.matchFirebaseId),
        itemBuilder: (context, doc) {
          final timeline = doc.data();
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1D3557),
                    const Color(0xFF1D3557).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, top: 12.0, right: 12.0),
                    child: Text(
                      timeline.getFormattedDate(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Html(
                      data: timeline.msgHtml,
                      style: {
                        "body": Style(
                          color: Colors.white,
                          fontSize: FontSize(16.0),
                        ),
                        "a": Style(
                          color: const Color(0xFFE63946), // Vibrant link color
                          textDecoration: TextDecoration.underline,
                        ),
                      },
                      onLinkTap: (String? url, Map<String, String> attributes,
                          html.Element? element) {
                        if (url != null) {
                          _launchInBrowser(Uri.parse(url));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AnimatedIconWidget(), // Reusing from MatchHistoryScreen
          const SizedBox(height: 16),
          Text(
            "No Timeline Available",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Assuming AnimatedIconWidget is defined elsewhere (e.g., in match_history.dart).
// If not, here’s a simplified version for completeness:
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
    Icons.sports_cricket,
    Icons.sports_baseball,
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
        color: Colors.white70,
      ),
    );
  }
}
