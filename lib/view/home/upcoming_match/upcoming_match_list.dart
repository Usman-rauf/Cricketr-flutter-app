import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/model/match/matchlist_model.dart';
import 'package:cricketly/view/home/upcoming_match/team_player_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class UpcomingListScreen extends StatefulWidget {
  final List<Upcomming> upcomingMatchList;
  const UpcomingListScreen({super.key, required this.upcomingMatchList});

  @override
  State<UpcomingListScreen> createState() => _UpcomingListScreenState();
}

class _UpcomingListScreenState extends State<UpcomingListScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.upcomingMatchList.isEmpty) {
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
        itemCount: widget.upcomingMatchList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var upcomingMatchInfo = widget.upcomingMatchList[index];
          DateTime newdate = DateTime.parse(upcomingMatchInfo.date ?? "");
          int endTime = newdate.millisecondsSinceEpoch + 1000 * 30;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                Map<String, dynamic> matchInfo = {
                  'date': upcomingMatchInfo.date,
                  'venue': upcomingMatchInfo.venue,
                  'time': upcomingMatchInfo.time,
                  'umpire': upcomingMatchInfo.umpireId.toString(),
                  'over': upcomingMatchInfo.over.toString(),
                  'matchId': upcomingMatchInfo.id.toString(),
                };
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamPlayerListScreen(
                      teamAName: upcomingMatchInfo.team1Name ?? '',
                      teamBName: upcomingMatchInfo.team2Name ?? '',
                      matchId: upcomingMatchInfo.id.toString(),
                      matchInfo: matchInfo,
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
                    vertical: size.height * 0.026,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTeamName(
                          size: size, name: upcomingMatchInfo.team1Name ?? ""),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'T20 MATCH 2022',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            children: [
                              CountdownTimer(
                                endTime: endTime,
                                widgetBuilder:
                                    (context, CurrentRemainingTime? time) {
                                  if (time == null) {
                                    return Text('Start',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: ConstColors.appGreen8FColor,
                                          fontSize: size.height * 0.013,
                                        ));
                                  }
                                  return Text(
                                    '${time.days == null ? "" : "${time.days}d"} ${time.hours == null ? "" : "${time.hours}h"} ${time.min == null ? "" : "${time.min}m"} ${time.sec == null ? "" : "${time.sec}s"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ConstColors.appGreen8FColor,
                                      fontSize: size.height * 0.013,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              // Text(
                              //   'Dec 24, 5:00 PM',
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.w500,
                              //     color: ConstColors.grayColor95,
                              //     fontSize: size.height * 0.013,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(),
                        ],
                      ),
                      _buildTeamName(
                          size: size, name: upcomingMatchInfo.team2Name ?? ""),
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

  Widget _buildTeamName({required Size size, required String name}) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: '',
          imageBuilder: (context, imageProvider) => Container(
            width: size.height * 0.035,
            height: size.height * 0.035,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: size.height * 0.028,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ConstColors.appGreen8FColor,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Center(
                child: Text(
                  name[0].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
