import 'package:flutter/material.dart';
import 'package:the_hit_times_app/features/live/models/LiveMatch.dart';

class FootballScoreCard extends StatelessWidget {
  final LiveMatch liveMatch;
  final Function? onTap;
  const FootballScoreCard({super.key, required this.liveMatch, this.onTap});

  @override
  Widget build(BuildContext context) {
    final team1Logo = liveMatch.team1?.getTeamFootballLogo();
    final team2Logo = liveMatch.team2?.getTeamFootballLogo();

    return Material(
      color: Colors.black,
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
            height: 150,
            child: Stack(
              children: [
                liveMatch.isLive! ? Positioned(
                  top: 8,
                  right: 8,
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(team1Logo!),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Text(
                                liveMatch.team1!.getTeamName(),
                                style: TextStyle(color: Colors.white, fontSize: 20),
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(team2Logo!),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Text(
                                liveMatch.team2!.getTeamName(),
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
