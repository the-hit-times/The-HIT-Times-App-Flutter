import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/LiveMatch.dart';

class FootballScoreCard extends StatelessWidget {
  final LiveMatch liveMatch;

  const FootballScoreCard({super.key, required this.liveMatch});

  @override
  Widget build(BuildContext context) {
    final team1Logo = liveMatch.team1?.getTeamFootballLogo();
    final team2Logo = liveMatch.team2?.getTeamFootballLogo();

    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16, top:16),
            child: liveMatch.isLive!
                ? Badge(
                    label: Text("LIVE"),
                  )
                : Text(""),
          ),
          Container(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    team1Logo != null
                        ? Image.asset(
                            team1Logo,
                            width: 60,
                            height: 60,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      liveMatch.team1!.getTeamName(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    liveMatch.team1!.teamScore.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        liveMatch.matchStatus.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),
                      ),
                      Text(
                        liveMatch.formattedMatchDate(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    liveMatch.team2!.teamScore.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    team2Logo != null
                        ? Image.asset(
                            team2Logo,
                            width: 60,
                            height: 60,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      liveMatch.team2!.getTeamName(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
