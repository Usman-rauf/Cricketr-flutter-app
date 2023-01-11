import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/controller/match/scoreboard_controller.dart';
import 'package:cricketly/model/match/score_board_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/view/home/scoreboard/summary_screen.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScoreBoardWithTabScreen extends StatefulWidget {
  final String matchId;
  final bool isLive;
  const ScoreBoardWithTabScreen(
      {super.key, required this.matchId, required this.isLive});

  @override
  State<ScoreBoardWithTabScreen> createState() =>
      _ScoreBoardWithTabScreenState();
}

class _ScoreBoardWithTabScreenState extends State<ScoreBoardWithTabScreen>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  ScorebardContoller scorebardContoller = ScorebardContoller();

  @override
  void initState() {
    scorebardContoller.getScoreBoard(matchId: widget.matchId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<ResponseModel<ScoreBoardModel>>(
            stream: scorebardContoller.getScoreBoaerdStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CommanCircular();
              } else {
                var scoreCardData = snapshot.data?.data?.result;
                return Column(
                  children: [
                    Expanded(
                      child: DefaultTabController(
                        length: 4,
                        child: Stack(
                          children: [
                            // for background container
                            Column(
                              children: [
                                widget.isLive
                                    ? Container(
                                        height: size.height * 0.225,
                                        width: double.infinity,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffF64b60),
                                        ),
                                      )
                                    : SizedBox(
                                        height: size.height * 0.225,
                                        width: double.infinity,
                                        child: Image.asset(
                                          ConstImages.scoreBoardBackImage,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ],
                            ),

                            //
                            Column(
                              children: [
                                _buildAppBar(size),
                                _buildTeamCard(size, scoreCardData),
                                SizedBox(height: size.height * 0.04),
                                // // tab Bar
                                // TabBar(
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   // controller: _tabController,
                                //   isScrollable: true,
                                //   labelColor: ConstColors.appGreen8FColor,
                                //   unselectedLabelColor: ConstColors.grayColor95,
                                //   indicatorColor: ConstColors.appGreen8FColor,
                                //   indicator: UnderlineTabIndicator(
                                //     borderSide: const BorderSide(
                                //         width: 3,
                                //         color: ConstColors.appGreen8FColor),
                                //     insets: EdgeInsets.symmetric(
                                //         horizontal: size.width * 0.07),
                                //   ),

                                //   tabs: const [
                                //     Tab(text: "Summary"),
                                //     Tab(text: "Scorecard"),
                                //     Tab(text: "Commentary"),
                                //     Tab(text: "Newsle"),
                                //   ],
                                // ),
                              ],
                            ),

                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                height: size.height * 0.83,
                                width: size.width,
                                child: SummaryScreen(
                                  scoreResult: scoreCardData,
                                  isLive: widget.isLive,
                                ),

                                // Builder(
                                //   builder: (BuildContext context) {
                                //     TabController? tabController =
                                //         DefaultTabController.of(context);
                                //     tabController?.addListener(() {
                                //       setState(() {
                                //         selectedIndex = tabController.index;
                                //       });
                                //     });
                                //     return TabBarView(
                                //       physics: const BouncingScrollPhysics(),
                                //       children: [

                                //         Container(
                                //           alignment: Alignment.center,
                                //           child: const Text("data"),
                                //         ),
                                //         Container(
                                //           alignment: Alignment.center,
                                //           child: const Text("data"),
                                //         ),
                                //         Container(
                                //           alignment: Alignment.center,
                                //           child: const Text("data"),
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget _buildTeamCard(Size size, ScoreResult? scoreResult) {
    return Container(
      margin: EdgeInsets.only(
        top: size.height * 0.012,
        left: size.width * 0.05,
        right: size.width * 0.05,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.width * 0.06, horizontal: size.height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamDetail(
                  image: scoreResult?.inning1?.battingTeam?.image ?? '',
                  teamName: scoreResult?.inning1?.battingTeam?.name ?? '',
                  run:
                      "${scoreResult?.inning1?.battingTeam?.run}-${scoreResult?.inning1?.battingTeam?.wicket}",
                  size: size,
                ),
                Column(
                  children: [
                    Text(
                      "${scoreResult?.inning1?.battingTeam?.name} vs ${scoreResult?.inning2?.battingTeam?.name ?? ''} ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.035, vertical: 5),
                      decoration: BoxDecoration(
                          color: scoreResult?.matchResult != null
                              ? ConstColors.appGreen8FColor
                              : ConstColors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        scoreResult?.matchResult != null ? "Complete" : "Live",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      scoreResult?.matchResult ??
                          "Overs ${scoreResult?.inning1?.battingTeam?.currentOver ?? ''}.${scoreResult?.inning1?.battingTeam?.currentOverBall ?? ''} (${scoreResult?.inning1?.battingTeam?.currentOver ?? ''})",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ConstColors.grayColor95,
                      ),
                    ),
                  ],
                ),
                _buildTeamDetail(
                  image: scoreResult?.inning2?.battingTeam?.image ?? '',
                  teamName: scoreResult?.inning2?.battingTeam?.name ?? '',
                  run:
                      "${scoreResult?.inning2?.battingTeam?.run}-${scoreResult?.inning2?.battingTeam?.wicket}",
                  size: size,
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            color: const Color.fromARGB(255, 219, 219, 219),
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.022),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // const Text(
                //   "CSK1 needs 76 runs from 46 balls to win",
                //   style: TextStyle(
                //       fontSize: 12,
                //       color: ConstColors.appGreen8FColor,
                //       fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   width: size.width * 0.04,
                // ),
                // const Text(
                //   "RR 7.4",
                //   style: TextStyle(
                //       fontSize: 12,
                //       color: ConstColors.grayColor95,
                //       fontWeight: FontWeight.bold),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTeamDetail(
      {required String image,
      required String teamName,
      required String run,
      required Size size}) {
    return Column(
      children: [
        CachedNetworkImageView(
          imageUrl: image,
          username: teamName,
          imageSize: size.height * 0.07,
        ),
        SizedBox(
          height: size.height * 0.005,
        ),
        Text(
          teamName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ConstColors.black,
          ),
        ),
        Text(
          run,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ConstColors.grayColor95,
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(Size size) {
    return Padding(
      padding: EdgeInsets.only(
          top: size.height * 0.075,
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: size.height * 0.02),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SvgPicture.asset(
                ConstImages.backArrowImg,
                color: ConstColors.white,
              ),
            ),
          ),
          Text(
            widget.isLive ? 'Live Match' : "ScoreBoard",
            style: TextStyle(
              color: ConstColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: size.width * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
