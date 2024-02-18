import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/team_detail.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

class TeamList extends StatefulWidget {
  String team1Code;
  String team2Code;
  String matchType;

  TeamList({super.key, required this.team1Code, required this.team2Code, required this.matchType});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> with AutomaticKeepAliveClientMixin  {
  static const String BASE_URL = "https://tht-admin.onrender.com/api/team/";

  bool isLoading = true;
  bool isError = false;
  late TeamDetails team1Details;
  late TeamDetails team2Details;

  late BaseTeamDetails team1;
  late BaseTeamDetails team2;

  @override
  initState() {
    super.initState();
    loadTeams();
  }

  // load teams information from api
  void loadTeams() async {

      var team1Response = await CachedHttp.get(BASE_URL + widget.team1Code,
          headers: {"Content-Type": "application/json"});
      var team2Response = await CachedHttp.get(BASE_URL + widget.team2Code,
          headers: {"Content-Type": "application/json"});

      if (team1Response.error ||
          team2Response.error || team1Response.responseBody['data'] == null || team2Response.responseBody['data'] == null) {
        setState(() {
          isError = true;
          isLoading = false;
        });
        return;
      }
      setState(() {

        print(team1Response.responseBody['data']);
        print(team2Response.responseBody['data']);

        team1Details = TeamDetails.fromJson(team1Response.responseBody['data']);
        team2Details = TeamDetails.fromJson(team2Response.responseBody['data']);

        if (widget.matchType == "cricket") {

          if (team1Details.cricket == null || team2Details.cricket == null) {
            isError = true;
            isLoading = false;
            return;
          }

          team1 = team1Details.cricket!;
          team2 = team2Details.cricket!;
        } else if (widget.matchType == "football") {

          if (team1Details.football == null || team2Details.football == null) {
            isError = true;
            isLoading = false;
            return;
          }

          team1 = team1Details.football!;
          team2 = team2Details.football!;
        }

        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : isError
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Failed to load team details",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    FilledButton.icon(
                      icon: Icon(Icons.refresh),
                      onPressed: () {

                        setState(() {
                          isLoading = true;
                          isError = false;
                        });

                      loadTeams();
                    }, label: Text("Retry"),)
                  ],
                ),
              )
            :
    Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Row(
            children: [
              Text(
                "Team ${team1.teamName}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              Text(
                "Team ${team2.teamName}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            shrinkWrap: true,
            itemCount: max(team1.players.length, team2.players.length),
            itemBuilder: (context, index) {

              final hasPlayerTeam1Description =
                  index > team1.players.length - 1 ? false :
                  team1.players[index].playerDescription.trim() != "";
              final hasPlayerTeam2Description =
                  index > team2.players.length - 1 ? false :
                  team2.players[index].playerDescription.trim() != "";

              final hasItemHeight = hasPlayerTeam1Description || hasPlayerTeam2Description;

              return Container(
                margin: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    index > team1.players.length - 1 ? Container(
                      height: 40,
                    ) :
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: team1.players[index].getPlayerImage(),
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.person ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              team1.players[index].playerName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                  color: Colors.white),
                            ),
                            hasItemHeight ?
                            const SizedBox(
                              height: 2.0,): Container(),
                            hasItemHeight ?
                            Text(
                                team1.players[index]
                                    .playerDescription,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey[400])) : Container(),
                          ],
                        ),
                      ],
                    ),
                    index > team2.players.length - 1 ? Container(
                      height: 40,
                    ) :
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              team2.players[index].playerName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                  color: Colors.white),
                            ),
                            hasItemHeight ?
                            const SizedBox(
                              height: 2.0,): Container(),
                            hasItemHeight ?
                              Text(
                                  team2.players[index]
                                      .playerDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey[400])): Container(),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: team2.players[index].getPlayerImage(),
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.person ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // This is used to keep the state of the widget alive
  // ie. when we switch between tabs, the state of the widget is not lost.
  @override
  bool get wantKeepAlive => true;
}
