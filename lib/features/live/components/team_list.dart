import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/team_detail.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

class TeamList extends StatefulWidget {
  String team1Code;
  String team2Code;

  TeamList({super.key, required this.team1Code, required this.team2Code});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  static const String BASE_URL = "http://192.168.1.3:8000/api/team/";

  bool isLoading = true;
  bool isError = false;
  late TeamDetails team1Details;
  late TeamDetails team2Details;

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
          team2Response.error) {
        setState(() {
          isError = true;
          isLoading = false;
        });
        return;
      }
      setState(() {
        team1Details = TeamDetails.fromJson(team1Response.responseBody['data']);
        team2Details = TeamDetails.fromJson(team2Response.responseBody['data']);
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              "Team ${team1Details.football.teamName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.only(top: 8.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: team1Details.football.players.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 12.0),
                                child: Row(
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
                                          imageUrl: team1Details
                                              .football.players[index].playerImage,
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
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            team1Details
                                                .football.players[index].playerName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 2.0,),
                                          Text(
                                              team1Details.football.players[index]
                                                  .playerDescription,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: Colors.grey[400])),
                                        ],
                                      ),
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
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              "Team ${team2Details.football.teamName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.only(top: 12.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: team2Details.football.players.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            team2Details
                                                .football.players[index].playerName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 2.0,),
                                          Text(
                                              team2Details.football.players[index]
                                                  .playerDescription,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: Colors.grey[400])),
                                        ],
                                      ),
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
                                          imageUrl: team2Details
                                              .football.players[index].playerImage,
                                          placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.person),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                ],
              );
  }
}
