import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/model/match/matchlist_model.dart';
import 'package:cricketly/view/home/live_match/live_match_screen/live_match_screen.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:flutter/material.dart';

class LiveMatchListScreen extends StatefulWidget {
  final List<Previous> liveMatchList;
  const LiveMatchListScreen({super.key, required this.liveMatchList});

  @override
  State<LiveMatchListScreen> createState() => _LiveMatchListScreenState();
}

class _LiveMatchListScreenState extends State<LiveMatchListScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.liveMatchList.isEmpty) {
      return SizedBox(
        height: size.height / 1.5,
        child: Center(
          child: Text(
            "No match available",
            style: TextStyle(
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.bold,
              color: ConstColors.grayColor95,
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: widget.liveMatchList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var liveMatchData = widget.liveMatchList[index];
          return Dismissible(
            background: Card(
              elevation: 7,
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            key: ValueKey(liveMatchData),
            onDismissed: (DismissDirection direction) {
              // setState(() {
              //   livematchList.removeAt(index);
              // });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveMatchScreen(
                        matchId: liveMatchData.matchId.toString(),
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CachedNetworkImageView(
                              imageUrl:
                                  liveMatchData.battingTeamPlayers?.image ?? '',
                              username:
                                  liveMatchData.battingTeamPlayers?.name ?? '',
                              imageSize: size.height * 0.07,
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              liveMatchData.battingTeamPlayers?.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              ' ${liveMatchData.battingTeamPlayers?.run}-${liveMatchData.battingTeamPlayers?.wicket}',
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            // Text(
                            //   '${liveMatchData.battingTeamPlayers?.name ?? ''} \nvs \n${liveMatchData.bowingTeamPlayers?.name ?? ''}',
                            //   textAlign: TextAlign.center,
                            //   style: const TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: ConstColors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                child: Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: ConstColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.height * 0.012,
                                  ),
                                ),
                              ),
                            ),
                            Container(),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Text(
                              'Overs  ${liveMatchData.battingTeamPlayers?.over}.${liveMatchData.battingTeamPlayers?.ballNumber} (${liveMatchData.totalOver})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CachedNetworkImageView(
                              imageUrl:
                                  liveMatchData.bowingTeamPlayers?.name ?? '',
                              username:
                                  liveMatchData.bowingTeamPlayers?.name ?? '',
                              imageSize: size.height * 0.07,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Text(
                              liveMatchData.bowingTeamPlayers?.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Text(
                              '${liveMatchData.bowingTeamPlayers?.run} - ${liveMatchData.bowingTeamPlayers?.wicket} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // Widget _buildTeamName(Size size, Live liveData, int index) {
    //   return Column(
    //     children: [
    //       const CircleAvatar(),
    //       SizedBox(
    //         height: size.height * 0.01,
    //       ),
    //       Text(
    //        liveData.team1Name??'',
    //         style: const TextStyle(
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //       SizedBox(
    //         height: size.height * 0.01,
    //       ),
    //       Text(livematchList[index]["run"]),
    //     ],
    //   );
    // }
  }
}
