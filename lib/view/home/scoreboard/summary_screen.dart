import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/model/match/score_board_model.dart';
import 'package:cricketly/widgtes/user_card.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  ScoreResult? scoreResult;
  final bool isLive;
  SummaryScreen({super.key, this.scoreResult, required this.isLive});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with TickerProviderStateMixin {
  TabController? _teamATabController;
  TabController? _teamBTabController;
  bool teamAOpen = false;
  bool teamBOpen = false;
  int selectedBallOrBat = 0;

  @override
  void initState() {
    _teamATabController = TabController(length: 2, vsync: this);
    _teamBTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var innig1Data = widget.scoreResult?.inning1;
    var innig2Data = widget.scoreResult?.inning2;

    return Stack(
      fit: StackFit.loose,
      children: [
        // team 1
        _buildTeam1Score(size, innig1Data, innig2Data),

        // team 2
        _buildTeam2Score(size, innig2Data),
      ],
    );
  }

  Widget _buildTeam1Score(Size size, Inning1? innig1Data, Inning1? innig2Data) {
    return Positioned(
      bottom: size.height * 0.06,
      child: GestureDetector(
        onTap: () {
          setState(() {
            teamAOpen = !teamAOpen;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          alignment: Alignment.center,
          height: teamAOpen
              ? size.height * 0.75
              : widget.isLive
                  ? size.height * 0.43
                  : size.height * 0.48,
          width: size.width,
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 10,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            gradient: LinearGradient(
              colors: [
                Color(0xff0CAB65),
                Color(0xff3BB78F),
                Color(0xff3BB78F),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                // //  image
                // leading: CachedNetworkImageView(
                //   imageUrl: innig1Data?.battingTeam?.image ?? '',
                //   username: innig1Data?.battingTeam?.name ?? '',
                //   imageSize: size.height * 0.06,
                // ),

                // title
                title: Text(
                  innig1Data?.battingTeam?.name ?? '',
                  style: const TextStyle(
                      color: ConstColors.white, fontWeight: FontWeight.bold),
                ),

                // batting bowling tab view
                trailing: SizedBox(
                  height: 30,
                  width: size.width * 0.5,
                  child: Row(
                    children: [
                      TabBar(
                        controller: _teamATabController,
                        indicator: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                side: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(80, 255, 255, 255))),
                            color: Color.fromARGB(50, 255, 255, 255)),
                        isScrollable: true,
                        labelColor: ConstColors.white,
                        unselectedLabelColor:
                            const Color.fromARGB(118, 255, 255, 255),
                        indicatorColor: ConstColors.white,
                        tabs: const [
                          Tab(text: "Batting"),
                          Tab(text: "Bowling"),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        teamAOpen == false
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: ConstColors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // divider
              const Divider(
                thickness: 1,
                endIndent: 30,
                indent: 10,
                color: Color.fromARGB(50, 255, 255, 255),
              ),

              Expanded(
                child: TabBarView(
                  controller: _teamATabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // list view

                    _buildBattingInning1Tabview(size, innig1Data),
                    _buildBowlingInning1Tabview(size, innig1Data),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeam2Score(Size size, Inning1? innig2Data) {
    return Positioned(
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            teamBOpen = !teamBOpen;
            teamAOpen = false;
          });
        },
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 10,
          ),
          duration: const Duration(milliseconds: 600),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            color: Colors.white,
          ),
          height: teamAOpen == true
              ? size.height * 0.1
              : teamBOpen
                  ? size.height * 0.81
                  : widget.isLive
                      ? size.height * 0.4
                      : size.height * 0.46,
          width: size.width,
          child: Column(
            children: [
              ListTile(
                // //  image
                // leading: CachedNetworkImageView(
                //   imageUrl: innig2Data?.battingTeam?.image ?? '',
                //   username: innig2Data?.battingTeam?.name ?? '',
                //   imageSize: size.height * 0.06,
                // ),

                // title
                title: Text(
                  innig2Data?.battingTeam?.name ?? '',
                  style: const TextStyle(
                      color: Color(0xff0CAB65), fontWeight: FontWeight.bold),
                ),
                // batting bowling tab view
                trailing: SizedBox(
                  // color: Colors.green,
                  height: 30,
                  width: size.width * 0.5,
                  child: Row(
                    children: [
                      TabBar(
                        controller: _teamBTabController,
                        indicator: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              side: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(80, 255, 255, 255))),
                          color: Color(0xff0CAB65),
                        ),
                        isScrollable: true,
                        labelColor: ConstColors.white,
                        unselectedLabelColor:
                            const Color(0xff0CAB65).withOpacity(0.6),
                        indicatorColor: ConstColors.white,
                        onTap: (value) {
                          setState(() {
                            selectedBallOrBat = value;
                          });
                        },
                        tabs: const [
                          Tab(text: "Batting"),
                          Tab(text: "Bowling"),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        teamBOpen == false
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xff0CAB65),
                      ),
                    ],
                  ),
                ),
              ),

              // divider
              const Divider(
                thickness: 1,
                endIndent: 30,
                indent: 10,
                color: Color(0xff0CAB65),
              ),

              // list view
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _teamBTabController,
                  children: [
                    _buildBattingInning2Tabview(size, innig2Data),
                    _buildBowlingInning2Tabview(size, innig2Data),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBattingInning1Tabview(
    Size size,
    Inning1? inning1,
  ) {
    return ListView.builder(
      itemCount: inning1?.battingTeam?.playerList?.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var inni1BatsmanData = inning1?.battingTeam?.playerList?[index];
        return ListTile(
          title: Text(
            capitalizeAllWord(inni1BatsmanData?.playerName ?? ""),
            style: const TextStyle(color: ConstColors.white),
          ),
          subtitle: Text(
            '${inni1BatsmanData?.run ?? ''} (${inni1BatsmanData?.ballFaced ?? ''})',
            style: const TextStyle(color: ConstColors.white),
          ),
          // trailing: const Text(
          //   "c Fran Wilson b Marsh",
          //   style: TextStyle(color: Color(0xff0CAB65)),
          // ),
        );
      },
    );
  }

  Widget _buildBowlingInning1Tabview(Size size, Inning1? inning1) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.1,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(color: ConstColors.white),
                ),
                SizedBox(
                  width: size.width / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'O',
                        style: TextStyle(
                          color: ConstColors.white,
                        ),
                      ),
                      Text(
                        'M',
                        style: TextStyle(
                          color: ConstColors.white,
                        ),
                      ),
                      Text(
                        'R',
                        style: TextStyle(
                          color: ConstColors.white,
                        ),
                      ),
                      Text(
                        'W',
                        style: TextStyle(
                          color: ConstColors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            itemCount: inning1?.bowingTeam?.playerList?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var inni1BowlerData = inning1?.bowingTeam?.playerList?[index];
              return ListTile(
                title: Text(
                  capitalizeAllWord(inni1BowlerData?.playerName ?? ""),
                  style: const TextStyle(color: ConstColors.white),
                ),
                trailing: SizedBox(
                  width: size.width / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${inni1BowlerData?.over}",
                        style: const TextStyle(color: ConstColors.white),
                      ),
                      Text(
                        "${inni1BowlerData?.maiden}",
                        style: const TextStyle(color: ConstColors.white),
                      ),
                      Text(
                        "${inni1BowlerData?.run}",
                        style: const TextStyle(color: ConstColors.white),
                      ),
                      Text(
                        "${inni1BowlerData?.wicket}",
                        style: const TextStyle(color: ConstColors.white),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingInning2Tabview(Size size, Inning1? inning2) {
    return teamAOpen == true
        ? const SizedBox()
        : SizedBox(
            width: size.width,
            height: size.height * 0.1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(color: ConstColors.appGreen8FColor),
                      ),
                      SizedBox(
                        width: size.width / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'O',
                              style: TextStyle(
                                color: ConstColors.appGreen8FColor,
                              ),
                            ),
                            Text(
                              'M',
                              style: TextStyle(
                                color: ConstColors.appGreen8FColor,
                              ),
                            ),
                            Text(
                              'R',
                              style: TextStyle(
                                color: ConstColors.appGreen8FColor,
                              ),
                            ),
                            Text(
                              'W',
                              style: TextStyle(
                                color: ConstColors.appGreen8FColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: ListView.builder(
                    itemCount: inning2?.bowingTeam?.playerList?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var inni2BowlerData =
                          inning2?.bowingTeam?.playerList?[index];
                      return ListTile(
                        title: Text(
                          capitalizeAllWord(inni2BowlerData?.playerName ?? ""),
                          style: const TextStyle(
                              color: ConstColors.appGreen8FColor),
                        ),
                        trailing: SizedBox(
                          width: size.width / 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${inni2BowlerData?.over}",
                                style: const TextStyle(
                                    color: ConstColors.appGreen8FColor),
                              ),
                              Text(
                                "${inni2BowlerData?.maiden}",
                                style: const TextStyle(
                                    color: ConstColors.appGreen8FColor),
                              ),
                              Text(
                                "${inni2BowlerData?.run}",
                                style: const TextStyle(
                                    color: ConstColors.appGreen8FColor),
                              ),
                              Text(
                                "${inni2BowlerData?.wicket}",
                                style: const TextStyle(
                                    color: ConstColors.appGreen8FColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildBattingInning2Tabview(Size size, Inning1? inning2) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.1,
      child: ListView.builder(
        itemCount: inning2?.battingTeam?.playerList?.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var inning2Batting = inning2?.battingTeam?.playerList?[index];
          return ListTile(
            title: Text(
              capitalizeAllWord(inning2Batting?.playerName ?? ""),
              style: const TextStyle(color: ConstColors.appGreen8FColor),
            ),
            subtitle: Text(
              '${inning2Batting?.run ?? ''} (${inning2Batting?.ballFaced ?? ''})',
              style: const TextStyle(
                color: ConstColors.appGreen8FColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
