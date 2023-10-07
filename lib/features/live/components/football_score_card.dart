import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';

class FootballScoreCard extends StatelessWidget {
  final LiveMatch liveMatch;
  final Function? onTap;
  final Color backgroundColor;
  final double height;
  const FootballScoreCard({super.key, required this.liveMatch, this.onTap, this.backgroundColor = Colors.black, this.height = 150.0});

  @override
  Widget build(BuildContext context) {
    final team1Logo = liveMatch.team1?.getTeamFootballLogo();
    final team2Logo = liveMatch.team2?.getTeamFootballLogo();

    // check if the match is penalty shootout
    final isPenalty = (liveMatch.team1?.teamPenalty != null && liveMatch.team2?.teamPenalty != null)
        && (liveMatch.team1?.teamPenalty != "0" || liveMatch.team2?.teamPenalty != "0") &&
        (liveMatch.team1?.teamScore == liveMatch.team2?.teamScore);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(5.0),
      child: Ink(
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            debugPrint("Tapped");
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
                liveMatch.isLive! ? Positioned(
                  top: 18,
                  right: 18,
                  child: Badge(
                    label: Text(
                      "LIVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ): Text(""),
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
                        child: Container(
                          width: double.infinity,
                          child: Center(
                              child: Text(
                            liveMatch.team1!.teamScore.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
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
                                isPenalty ?
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Penalty: ", style: TextStyle(color: Colors.white),),
                                      Text( "${liveMatch.team1!.teamPenalty.toString()}-${liveMatch.team2!.teamPenalty.toString()}"
                                      , style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                ) : SizedBox(height: 0.0,),
                              ],
                            )),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Center(
                              child: Text(
                            liveMatch.team2!.teamScore.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
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
