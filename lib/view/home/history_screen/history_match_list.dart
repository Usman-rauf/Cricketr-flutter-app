import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/model/match/matchlist_model.dart';
import 'package:cricketly/view/home/scoreboard/score_board_screen.dart';
import 'package:flutter/material.dart';

import '../../../widgtes/image_view.dart';

class HistoryMatchList extends StatefulWidget {
  HistoryMatchList({super.key, required this.previousMatchList});
  List<Previous> previousMatchList = [];

  @override
  State<HistoryMatchList> createState() => _HistoryMatchListState();
}

class _HistoryMatchListState extends State<HistoryMatchList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.previousMatchList.isEmpty) {
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
        itemCount: widget.previousMatchList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var previousListData = widget.previousMatchList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScoreBoardWithTabScreen(
                      isLive: false,
                      matchId: previousListData.matchId.toString(),
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
                      _buildTeamName(
                        size: size,
                        teamName:
                            previousListData.battingTeamPlayers?.name ?? "",
                        teamImage:
                            previousListData.battingTeamPlayers?.image ?? '',
                      ),
                      Column(
                        children: [
                          Text(
                            '${previousListData.battingTeamPlayers?.name ?? ""} vs ${previousListData.bowingTeamPlayers?.name ?? ""}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: ConstColors.appGreen8FColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                'Complete',
                                style: TextStyle(
                                  color: ConstColors.white,
                                  fontWeight: FontWeight.w800,
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
                            previousListData.result ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      _buildTeamName(
                        size: size,
                        teamName:
                            previousListData.bowingTeamPlayers?.name ?? "",
                        teamImage:
                            previousListData.bowingTeamPlayers?.image ?? "",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildTeamName({
    required Size size,
    required String teamName,
    required String teamImage,
  }) {
    return Column(
      children: [
        CachedNetworkImageView(
          imageUrl: teamImage != '' ? teamImage : '',
          username: teamName,
          imageSize: size.height * 0.07,
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          teamName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
