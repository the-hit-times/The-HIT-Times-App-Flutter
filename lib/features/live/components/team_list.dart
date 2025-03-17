import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_hit_times_app/features/live/models/team_detail.dart';
import 'package:the_hit_times_app/globals.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

class TeamList extends StatefulWidget {
  final String team1Code;
  final String team2Code;
  final String matchType;

  const TeamList({
    super.key,
    required this.team1Code,
    required this.team2Code,
    required this.matchType,
  });

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList>
    with AutomaticKeepAliveClientMixin {
  static const String API_URL = "${Constants.BASE_URL}/team/";
  static const String FALLBACK_IMAGE_URL = 'https://via.placeholder.com/150';

  bool isLoading = false; // Start as false, load only if data is missing
  bool isError = false;
  TeamDetails? team1Details;
  TeamDetails? team2Details;
  BaseTeamDetails? team1;
  BaseTeamDetails? team2;

  // Cache to prevent repeated loads
  static final Map<String, TeamDetails> _teamCache = {};

  @override
  void initState() {
    super.initState();
    _loadTeamsIfNeeded();
  }

  Future<void> _loadTeamsIfNeeded() async {
    // Check if data is already loaded or cached
    if (team1Details != null && team2Details != null) {
      debugPrint("Data already loaded, skipping loadTeams");
      return;
    }

    if (_teamCache.containsKey(widget.team1Code) &&
        _teamCache.containsKey(widget.team2Code)) {
      debugPrint(
          "Using cached data for ${widget.team1Code} vs ${widget.team2Code}");
      setState(() {
        team1Details = _teamCache[widget.team1Code];
        team2Details = _teamCache[widget.team2Code];
        _setTeamData();
      });
      return;
    }

    await loadTeams();
  }

  Future<void> loadTeams() async {
    if (!mounted) return;
    debugPrint(
        "loadTeams called for ${widget.team1Code} vs ${widget.team2Code}");

    try {
      setState(() {
        isLoading = true;
        isError = false;
      });

      final team1Response = await CachedHttp.get(
        "$API_URL${widget.team1Code}",
        headers: {"Content-Type": "application/json"},
      );
      final team2Response = await CachedHttp.get(
        "$API_URL${widget.team2Code}",
        headers: {"Content-Type": "application/json"},
      );

      if (team1Response.error || team1Response.responseBody['data'] == null) {
        throw Exception(
            "Failed to load team 1 data: ${team1Response.responseBody}");
      }
      if (team2Response.error || team2Response.responseBody['data'] == null) {
        throw Exception(
            "Failed to load team 2 data: ${team2Response.responseBody}");
      }

      final tempTeam1Details =
          TeamDetails.fromJson(team1Response.responseBody['data']);
      final tempTeam2Details =
          TeamDetails.fromJson(team2Response.responseBody['data']);

      // Cache the data
      _teamCache[widget.team1Code] = tempTeam1Details;
      _teamCache[widget.team2Code] = tempTeam2Details;

      if (mounted) {
        setState(() {
          team1Details = tempTeam1Details;
          team2Details = tempTeam2Details;
          _setTeamData();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
      debugPrint("Error loading teams: $e");
    }
  }

  void _setTeamData() {
    if (widget.matchType == "cricket") {
      team1 = team1Details?.cricket;
      team2 = team2Details?.cricket;
    } else if (widget.matchType == "football") {
      team1 = team1Details?.football;
      team2 = team2Details?.football;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("TeamList build called");

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF071F2A), Color(0xFF0A3D62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isLoading
          ? _buildShimmerLoading()
          : isError
              ? _buildErrorWidget()
              : _buildTeamContent(),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(6, (index) => _buildShimmerItem()),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white70, size: 60),
          const SizedBox(height: 16),
          Text(
            "Failed to load team details",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: loadTeams, // Manual retry still allowed
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE63946),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTeamSection(team1, "Team ${team1?.teamName ?? '1'}"),
          const SizedBox(height: 24),
          _buildTeamSection(team2, "Team ${team2?.teamName ?? '2'}"),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BaseTeamDetails? team, String title) {
    if (team == null || team.players.isEmpty) {
      return _buildEmptyTeamWidget(title);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: team.players.length,
          itemBuilder: (context, index) {
            final player = team.players[index];
            final hasDescription = player.playerDescription.trim().isNotEmpty;
            final imageUrl = _convertGoogleDriveUrl(player.getPlayerImage());

            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(12.0),
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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _showFullImage(context, imageUrl, player.playerName),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: Colors.white70,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 30,
                            ),
                            fit: BoxFit.cover,
                            errorListener: (exception) {
                              debugPrint(
                                  "Image load failed for URL: $imageUrl - $exception");
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.playerName.isNotEmpty
                                ? player.playerName
                                : "Unknown Player",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (hasDescription) ...[
                            const SizedBox(height: 4),
                            Text(
                              player.playerDescription,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyTeamWidget(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "No players available for this team.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  String _convertGoogleDriveUrl(String url) {
    if (url.contains("drive.google.com/open?id=")) {
      final fileId = url.split("id=").last;
      final directUrl =
          "https://drive.google.com/uc?export=download&id=$fileId";
      debugPrint("Converted Google Drive URL: $url -> $directUrl");
      return directUrl;
    }
    if (url.isEmpty || !Uri.parse(url).isAbsolute || !_isImageUrl(url)) {
      debugPrint("Invalid or non-image URL detected: $url, using fallback");
      return FALLBACK_IMAGE_URL;
    }
    return url;
  }

  bool _isImageUrl(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.gif');
  }

  void _showFullImage(
      BuildContext context, String imageUrl, String playerName) {
    debugPrint("Showing full image for $playerName");
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white70),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child:
                            Icon(Icons.error, color: Colors.white70, size: 50),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    debugPrint("Dialog closed for $playerName");
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
