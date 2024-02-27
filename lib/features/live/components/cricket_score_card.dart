import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';

class CricketScoreCard extends StatelessWidget {
  final LiveMatch liveMatch;
  final Function? onTap;
  final Color backgroundColor;
  final double height;
  const CricketScoreCard({super.key, required this.liveMatch, this.onTap, this.backgroundColor = Colors.black, this.height = 150.0});

  TextSpan getTeamScore(String teamScore) {
    String teamRuns = teamScore.split("/")[0];
    String teamWickets = teamScore.split("/")[1];

    return TextSpan(
      children: [
        TextSpan(
          text: teamRuns,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const TextSpan(
          text: " / ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: teamWickets,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final team1Logo = liveMatch.team1?.getTeamCricketLogo();
    final team2Logo = liveMatch.team2?.getTeamCricketLogo();



    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(5.0),
      child: Ink(
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            height: height,
            child: Stack(
              children: [
                liveMatch.isLive! ? const Positioned(
                  top: 18,
                  right: 18,
                  child: Badge(
                    label: Text(
                      "LIVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ): const Text(""),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 5.0,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                child: CachedNetworkImage(
                                  imageUrl: team1Logo!,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Text(
                                liveMatch.team1!.getTeamName(),
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                              child: RichText(
                                text: getTeamScore(
                                  liveMatch.team1!.teamScore.toString()
                                ),
                              )
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  liveMatch.matchStatus.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15,
                                      fontWeight: FontWeight.w300
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  liveMatch.formattedMatchDate(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  liveMatch.formattedMatchTime(),
                                  style: TextStyle( color: Colors.white, fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )),
                      ),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                              child:  RichText(
                                text: getTeamScore(
                                    liveMatch.team2!.teamScore.toString()
                                ),
                              )),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5.0,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                child: CachedNetworkImage(
                                  imageUrl: team2Logo!,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Text(
                                liveMatch.team2!.getTeamName(),
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
