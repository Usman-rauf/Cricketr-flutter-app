import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/model/match/match_detail_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/view/home/live_match/live_match_screen/inning_change_screen.dart';
import 'package:cricketly/view/home/scoreboard/score_board_screen.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'live_match_screen_appbar.dart';

class LiveMatchScreen extends StatefulWidget {
  final String matchId;
  const LiveMatchScreen({super.key, required this.matchId});
  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  MatchController matchController = MatchController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  List runList = [
    {"run": "1"},
    {"run": "2"},
    {"run": "3"},
    {"run": "4"},
    {"run": "6"},
  ];
  List cardList = [
    {"txt": "RUN"},
    {"txt": "OUT"},
    {"txt": "EXTRA"},
    {"txt": "DOT"},
    {"txt": "DEAD"},
    {"txt": "UNDO"},
  ];

  List extraType = [
    {"type": "No Ball"},
    {"type": "White Ball"},
  ];
  List outType = [
    {
      "type": "Stump",
      "image": ConstImages.outIcon,
    },
    {
      "type": "Run",
      "image": ConstImages.runOutIcon,
    },
    {
      "type": "Catch",
      "image": ConstImages.catchIcon,
    },
  ];

  Opener? strickBatsman;
  int selectedNewBolwer = 0;
  int selectedNewBatsman = 0;
  int selectedCatchPlayer = 0;

//------------------------------------------------------------------ InitState -----------------------------------------------------------------//
  @override
  void initState() {
    matchController.getMatchSink(matchId: widget.matchId);
    super.initState();
  }

//--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<ResponseModel<GetMatchDetailModel>>(
          stream: matchController.getMatchStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: size.height / 1.3,
                child: const CommanCircular(),
              );
            } else {
              var getMatchData = snapshot.data?.data?.macthDetailResult;
              if (getMatchData?.isUmpire == false) {
                return ScoreBoardWithTabScreen(
                  matchId: widget.matchId,
                  isLive: true,
                );
              } else {
                if (getMatchData?.matchEnd == true) {
                  Future.delayed(
                    const Duration(milliseconds: 500),
                    () async {
                      final response = await matchController.endMatchController(
                          matchId: widget.matchId);
                      if (response.status == true) {
                        hideLoader(context);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: const Text('Alert!'),
                              content: Text(
                                response.data?.message.toString() ?? '',
                                style:
                                    const TextStyle(color: ConstColors.black),
                              ),
                              actions: [
                                MaterialButton2(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomBarScreen(
                                              selectedIndex: 0)),
                                    );
                                  },
                                  buttonText: 'OK',
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                } else if (getMatchData?.isInning == true) {
                  Future.delayed(
                    const Duration(milliseconds: 500),
                    () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IningChangeScreen(
                            macthDetailResult: getMatchData,
                            matchId: widget.matchId,
                          ),
                        ),
                      ).then((value) async {
                        await matchController.getMatchSink(
                          matchId: widget.matchId,
                        );
                      });
                    },
                  );
                } else if (getMatchData?.isOver == true) {
                  Future.delayed(
                    const Duration(milliseconds: 500),
                    () async {
                      return await _buildSelectNewBolwer(
                        context,
                        size,
                        getMatchData!,
                      );
                    },
                  );
                }
                return _buildUiView(size, getMatchData, context);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildUiView(
    Size size,
    MacthDetailResult? getMatchData,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.2,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(color: Color(0xffF64b60)),
              ),
              Column(
                children: [
                  LiveMatchScreenAppBar(matchId: widget.matchId),
                  SizedBox(
                    // height: size.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildTeamCard(size, getMatchData!),
                          SizedBox(
                            height: size.height * 0.014,
                          ),
                          Column(
                            children: [
                              _buildDetailCard(size, getMatchData),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              _build1ButtonRow(context, size, getMatchData),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _build2RoeButtons(size, getMatchData),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildEndMatchBtn(size),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  Widget _buildDetailTitleCard(
      {required String firstText,
      required String lastText,
      BorderRadiusGeometry? borderRadius,
      required Size size}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 194, 194, 194),
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            firstText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            lastText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildRoundText(
      {required Size size,
      required String run,
      required Color textColor,
      required Color bgcolor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: size.height * 0.03,
        width: size.height * 0.03,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgcolor,
        ),
        child: Center(
          child: Text(
            run,
            style: TextStyle(
              color: textColor,
              fontSize: size.height * 0.01,
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedAlertItems(
      {required String text, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: ConstColors.appGreen8FColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Player Image Circuler
  Widget playerImage({
    required String imageUrl,
    required String username,
    double? imageSize,
    required Size size,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: imageSize ?? size.width * 0.15,
        height: imageSize ?? size.height * 0.15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        alignment: Alignment.center,
        width: imageSize ?? size.height * 0.15,
        height: imageSize ?? size.width * 0.15,
        decoration: const BoxDecoration(
          color: ConstColors.appGreen8FColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          username[0].toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.02,
            color: ConstColors.white,
          ),
        ),
      ),
    );
  }

  //Header Card

  Widget _buildTeamCard(Size size, MacthDetailResult macthDetailResult) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: ConstColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 6,
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
                vertical: size.width * 0.025, horizontal: size.height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamDetail(
                  image: macthDetailResult.battingTeam?.image ?? '',
                  teamName: macthDetailResult.battingTeam?.name ?? '',
                  run:
                      "${macthDetailResult.battingTeam?.run}-${macthDetailResult.battingTeam?.wicket}",
                  size: size,
                ),
                Column(
                  children: [
                    // Text(
                    //   "${macthDetailResult.battingTeam?.name} vs ${macthDetailResult.bowingTeam?.name ?? ''} ",
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.035, vertical: 5),
                      decoration: const BoxDecoration(
                          color: ConstColors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Text(
                        "Live",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      "Overs ${macthDetailResult.battingTeam?.over ?? ''}.${macthDetailResult.battingTeam?.currentOverBall ?? ''}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ConstColors.grayColor95,
                      ),
                    ),
                  ],
                ),
                _buildTeamDetail(
                  image: macthDetailResult.bowingTeam?.image ?? '',
                  teamName: macthDetailResult.bowingTeam?.name ?? '',
                  run:
                      "${macthDetailResult.bowingTeam?.run}-${macthDetailResult.bowingTeam?.wicket}",
                  size: size,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------------ Score Detail Card -----------------------------------------------------------------//

  // Card View
  Widget _buildDetailCard(Size size, MacthDetailResult macthDetailResult) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: ConstColors.itemColor2,
            boxShadow: [
              BoxShadow(
                color: ConstColors.roundbgClolor,
                offset: Offset(0.0, 1.0),
                blurRadius: 10.0,
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              _buildBatsmanView(size, macthDetailResult),
              _buildLastOverItem(size, macthDetailResult),
              _buildBowlerView(size, macthDetailResult)
            ],
          ),
        ),
      ],
    );
  }

// Batsman view
  Widget _buildBatsmanView(Size size, MacthDetailResult macthDetailResult) {
    return Column(
      children: [
        _buildDetailTitleCard(
          size: size,
          firstText: "Batsman",
          lastText: "Run",
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        SizedBox(
          height: size.height * 0.1,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.045, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            playerImage(
                              imageUrl:
                                  macthDetailResult.opener?[0].profileImage ??
                                      '',
                              size: size,
                              username:
                                  macthDetailResult.opener?[0].username ?? '',
                              imageSize: size.height * 0.03,
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              macthDetailResult.opener?[0].username ?? '',
                              style: TextStyle(
                                fontSize: size.height * 0.015,
                                color: ConstColors.appGreen8FColor,
                              ),
                            ),
                            macthDetailResult.onStriker == ''
                                ? Image.asset(ConstImages.batIcon)
                                : macthDetailResult.onStriker ==
                                        macthDetailResult.opener?[0].id
                                            .toString()
                                    ? Image.asset(ConstImages.batIcon)
                                    : const SizedBox()
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${macthDetailResult.opener?[0].run}(${macthDetailResult.opener?[0].ballFaced})',
                      style: const TextStyle(
                          fontSize: 15, color: ConstColors.grayColor95),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.045, vertical: 6),
                color: ConstColors.itemColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            playerImage(
                              imageUrl:
                                  macthDetailResult.opener?[1].profileImage ??
                                      '',
                              size: size,
                              username:
                                  macthDetailResult.opener?[1].username ?? '',
                              imageSize: size.height * 0.03,
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              macthDetailResult.opener?[1].username ?? '',
                              style: TextStyle(
                                fontSize: size.height * 0.015,
                                color: ConstColors.appGreen8FColor,
                              ),
                            ),
                            macthDetailResult.onStriker ==
                                    macthDetailResult.opener?[1].id.toString()
                                ? Image.asset(ConstImages.batIcon)
                                : const SizedBox()
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${macthDetailResult.opener?[1].run}(${macthDetailResult.opener?[1].ballFaced})',
                      style: const TextStyle(
                          fontSize: 15, color: ConstColors.grayColor95),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Last Over View
  Widget _buildLastOverItem(Size size, MacthDetailResult macthDetailResult) {
    var totalRun = ((macthDetailResult.opener?[0].run ?? 0) +
        (macthDetailResult.opener?[1].run ?? 0));
    var totalBall = ((macthDetailResult.opener?[0].ballFaced ?? 0) +
        (macthDetailResult.opener?[1].ballFaced ?? 0));
    print(macthDetailResult.lastOver);
    return Column(
      children: [
        _buildDetailTitleCard(
          size: size,
          firstText: "Patnership runs",
          lastText: "Last over",
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: size.width * 0.045, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$totalRun ($totalBall)",
                style: const TextStyle(color: ConstColors.grayColor95),
              ),
              SizedBox(
                width: size.width / 1.5,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: macthDetailResult.lastOver?.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 8,
                            ),
                            child: _buildRoundText(
                              bgcolor: (e.isWicketDelivery ?? false)
                                  ? const Color.fromARGB(255, 193, 14, 2)
                                  : ConstColors.grayColor95,
                              textColor: (e.isWicketDelivery ?? false)
                                  ? const Color.fromARGB(255, 199, 198, 198)
                                  : ConstColors.black,
                              run: (e.isWicketDelivery ?? false)
                                  ? 'W'
                                  : e.extraType == 'WD'
                                      ? 'WD'
                                      : e.extraType == 'DB'
                                          ? 'DB'
                                          : e.extraType == 'NB'
                                              ? 'NB'
                                              : e.totalRun.toString(),
                              size: size,
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bowler View
  Widget _buildBowlerView(Size size, MacthDetailResult macthDetailResult) {
    return Column(
      children: [
        _buildDetailTitleCard(
          size: size,
          firstText: "Bowlers",
          lastText: "This over",
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.005,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  playerImage(
                    imageUrl: macthDetailResult.bowler?.bowlerImage ?? '',
                    size: size,
                    username: macthDetailResult.bowler?.bowlerName ?? '',
                    imageSize: size.height * 0.03,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    macthDetailResult.bowler?.bowlerName ?? '',
                    style: const TextStyle(
                        fontSize: 13, color: ConstColors.appGreen8FColor),
                  ),
                ],
              ),
              SizedBox(
                width: size.width / 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: macthDetailResult.bowler?.ballLog?.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 8,
                            ),
                            child: _buildRoundText(
                              bgcolor: (e.isWicketDelivery ?? false)
                                  ? const Color.fromARGB(255, 193, 14, 2)
                                  : ConstColors.grayColor95.withOpacity(0.1),
                              textColor: (e.isWicketDelivery ?? false)
                                  ? ConstColors.white
                                  : ConstColors.black,
                              run: (e.isWicketDelivery ?? false)
                                  ? 'W'
                                  : e.extraType == 'WD'
                                      ? 'WD'
                                      : e.extraType == 'DB'
                                          ? 'DB'
                                          : e.extraType == 'NB'
                                              ? 'NB'
                                              : e.totalRun.toString(),
                              size: size,
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonView({
    required Size size,
    required void Function() onTap,
    required String buttonText,
    Widget? widget,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width,
          height: size.height * 0.1,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: ConstColors.appGreen8FColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Image.asset(ConstImages.buttonImage),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: const TextStyle(
                          color: ConstColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    widget ?? const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------------------------------------------------------ Bottom Button -----------------------------------------------------------------//

  Widget _build1ButtonRow(
      BuildContext context, Size size, MacthDetailResult macthDetailResult) {
    return Row(
      children: [
        _buildRunButton(context, size, macthDetailResult),
        SizedBox(
          width: size.width * 0.03,
        ),
        _buildOutButton(size, context, macthDetailResult),
        SizedBox(
          width: size.width * 0.03,
        ),
        _buildExtraButton(size, macthDetailResult),
      ],
    );
  }

  Widget _build2RoeButtons(Size size, MacthDetailResult getMatchData) {
    return Row(
      children: [
        _buildDotButton(size, getMatchData),
        SizedBox(
          width: size.width * 0.03,
        ),
        _buildDeadButton(size, getMatchData),
        SizedBox(
          width: size.width * 0.03,
        ),
        Expanded(
          child: GestureDetector(
            onTap: getMatchData.battingTeam?.currentOverBall == 1
                ? () {}
                : () async {
                    showLoader(context);
                    await matchController.undoScroreSink(
                      matchId: widget.matchId,
                    );
                    await matchController.getMatchSink(
                      matchId: widget.matchId,
                    );
                    hideLoader(context);
                  },
            child: Container(
              width: size.width,
              height: size.height * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: getMatchData.battingTeam?.currentOverBall == 1
                    ? ConstColors.grayF4
                    : ConstColors.appGreen8FColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  getMatchData.battingTeam?.currentOverBall == 1
                      ? const SizedBox()
                      : Image.asset(ConstImages.buttonImage),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "UNDO",
                          style: TextStyle(
                              color: ConstColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // _buildUndoButton(size, getMatchData),
        // SizedBox(
        //   width: size.width * 0.03,
        // ),
      ],
    );
  }

  // Run Button
  Widget _buildRunButton(
      BuildContext context, Size size, MacthDetailResult macthDetailResult) {
    return _buildButtonView(
      buttonText: 'RUN',
      size: size,
      widget: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: ConstColors.white,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: SizedBox(
                height: size.height / 3,
                width: size.width,
                child: Column(
                  children: [
                    Text(
                      'Select Run',
                      style: TextStyle(
                        color: ConstColors.black,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: runList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            showLoader(context);
                            Map<String, dynamic> updateData = {
                              'match': widget.matchId.toString(),
                              'batter': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                              'bowler':
                                  macthDetailResult.bowler?.bowlerId.toString(),
                              'non_striker': macthDetailResult.offStriker != ''
                                  ? macthDetailResult.offStriker
                                  : macthDetailResult.opener?[1].id.toString(),
                              'batsman_run': runList[index]['run'],
                              'extra_type': '',
                              'extras_run': '0',
                              'isWicketDelivery': '0',
                              'player_out': '',
                              'kind': '',
                              'fielders_involved': '',
                              'BattingTeam':
                                  macthDetailResult.battingTeam?.id.toString(),
                              'BowlingTeam':
                                  macthDetailResult.bowingTeam?.id.toString(),
                              'on_striker': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                            };

                            await matchController.updateScoreSink(
                              updateScoreData: updateData,
                            );
                            await matchController.getMatchSink(
                              matchId: widget.matchId,
                            );
                            if (!mounted) return;
                            hideLoader(context);

                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            backgroundColor: ConstColors.appGreen8FColor,
                            maxRadius: size.height * 0.02,
                            child: Text(
                              runList[index]['run'],
                              style: TextStyle(
                                color: ConstColors.white,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

//------------------------------------------------------------------ Select New Bolwer -----------------------------------------------------------------//
  _buildSelectNewBolwer(
      BuildContext context, Size size, MacthDetailResult macthDetailResult) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: SizedBox(
                height: size.height / 2,
                width: size.width,
                child: Column(
                  children: [
                    Text(
                      'Select New Bowler',
                      style: TextStyle(
                        color: ConstColors.black,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      height: size.height / 3,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              macthDetailResult.bowingTeam?.playerList?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: macthDetailResult.bowler?.bowlerId ==
                                      macthDetailResult.bowingTeam
                                          ?.playerList?[index].playerId
                                  ? () {}
                                  : () {
                                      setState(() {
                                        selectedNewBolwer = index;
                                      });
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: macthDetailResult
                                                  .bowler?.bowlerId ==
                                              macthDetailResult.bowingTeam
                                                  ?.playerList?[index].playerId
                                          ? ConstColors.black.withOpacity(0.5)
                                          : ConstColors.grayF4,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        macthDetailResult
                                                .bowingTeam
                                                ?.playerList?[index]
                                                .playerName ??
                                            '',
                                        style: TextStyle(
                                          color: ConstColors.black,
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      selectedNewBolwer == index
                                          ? Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ConstColors.appBlueColor,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SvgPicture.asset(
                                                  ConstImages.rightArrowImg,
                                                  color: ConstColors.white,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    MaterialButton2(
                      minWidth: size.width,
                      buttonText: 'OK',
                      onPressed: () async {
                        showLoader(context);
                        Map<String, dynamic> updateBolwerData = {
                          'match': widget.matchId.toString(),
                          'team': macthDetailResult.bowingTeam?.id.toString(),
                          'bowler': macthDetailResult.bowingTeam
                              ?.playerList?[selectedNewBolwer].playerId
                              .toString(),
                        };
                        await matchController.updateBolwerSink(
                          updateBolwer: updateBolwerData,
                        );
                        await matchController.getMatchSink(
                          matchId: widget.matchId,
                        );
                        hideLoader(context);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

//------------------------------------------------------------------ Select New Batsman -----------------------------------------------------------------//
  _buildSelectNewBatsman(Size size, MacthDetailResult macthDetailResult,
      int index, String involvedPlayer) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: SizedBox(
                height: size.height / 2,
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Select New Batsman',
                        style: TextStyle(
                          color: ConstColors.black,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            macthDetailResult.battingTeam?.playerList?.length,
                        itemBuilder: (context, index) {
                          var batsmanData =
                              macthDetailResult.battingTeam?.playerList?[index];
                          return GestureDetector(
                            onTap: macthDetailResult.opener?[0].id ==
                                        macthDetailResult.battingTeam
                                            ?.playerList?[index].playerId ||
                                    macthDetailResult.opener?[1].id ==
                                        macthDetailResult.battingTeam
                                            ?.playerList?[index].playerId
                                ? () {}
                                : () {
                                    setState(() {
                                      selectedNewBatsman = index;
                                    });
                                  },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: macthDetailResult.opener?[0].id ==
                                              macthDetailResult
                                                  .battingTeam
                                                  ?.playerList?[index]
                                                  .playerId ||
                                          macthDetailResult.opener?[1].id ==
                                              macthDetailResult.battingTeam
                                                  ?.playerList?[index].playerId
                                      ? ConstColors.black.withOpacity(0.5)
                                      : ConstColors.grayF4,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      batsmanData?.playerName ?? '',
                                      style: TextStyle(
                                        color: ConstColors.black,
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    selectedNewBatsman == index
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ConstColors.appBlueColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                ConstImages.rightArrowImg,
                                                color: ConstColors.white,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      MaterialButton2(
                        minWidth: size.width,
                        buttonText: 'OK',
                        onPressed: () async {
                          showLoader(context);
                          String batsmanID = '';
                          if (macthDetailResult.opener?[0].id.toString() ==
                              macthDetailResult.onStriker) {
                            batsmanID =
                                macthDetailResult.opener?[1].id.toString() ??
                                    '';
                          } else {
                            batsmanID =
                                macthDetailResult.opener?[0].id.toString() ??
                                    '';
                          }
                          Map<String, dynamic> updateBatsman = {
                            'match': widget.matchId.toString(),
                            'team': macthDetailResult.bowingTeam?.id.toString(),
                            'opener': "${[
                              macthDetailResult.battingTeam
                                  ?.playerList?[selectedNewBatsman].playerId,
                              batsmanID,
                            ]}",
                          };
                          await matchController
                              .updateBatsmanSink(
                            updateBatsman: updateBatsman,
                          )
                              .then((value) async {
                            Map<String, dynamic> updateData = {
                              'match': widget.matchId.toString(),
                              'batter': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                              'bowler':
                                  macthDetailResult.bowler?.bowlerId.toString(),
                              'non_striker': macthDetailResult.offStriker != ''
                                  ? macthDetailResult.offStriker
                                  : macthDetailResult.opener?[1].id.toString(),
                              'batsman_run': '0',
                              'extra_type': '',
                              'extras_run': '0',
                              'isWicketDelivery': '1',
                              'player_out': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                              'kind': outType[index]['type'],
                              'fielders_involved': involvedPlayer,
                              'BattingTeam':
                                  macthDetailResult.battingTeam?.id.toString(),
                              'BowlingTeam':
                                  macthDetailResult.bowingTeam?.id.toString(),
                              'on_striker': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                            };
                            print(updateData);
                            await matchController.updateScoreSink(
                              updateScoreData: updateData,
                            );
                            if (!mounted) return;
                            hideLoader(context);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await matchController.getMatchSink(
                              matchId: widget.matchId,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  //Out Ball

  Widget _buildOutButton(
      Size size, BuildContext context, MacthDetailResult macthDetailResult) {
    return _buildButtonView(
      buttonText: 'OUT',
      size: size,
      widget: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: ConstColors.white,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: SizedBox(
                height: size.height / 5,
                width: size.width,
                child: Column(
                  children: [
                    Text(
                      'Select Out Type',
                      style: TextStyle(
                        color: ConstColors.black,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: outType.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              if (index == 2) {
                                await _buildCatchPlayerList(
                                    context, size, macthDetailResult, index);
                              } else {
                                _buildSelectNewBatsman(
                                    size, macthDetailResult, index, '');
                              }
                            },
                            child: Container(
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset(
                                    outType[index]['image'],
                                  ),
                                  Text(
                                    outType[index]['type'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ConstColors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )

                            // CircleAvatar(
                            //   backgroundColor: ConstColors.appGreen8FColor,
                            //   maxRadius: size.height * 0.02,
                            //   child: Text(
                            //     outType[index]['type'],
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       color: ConstColors.white,
                            //       fontSize: size.height * 0.02,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
        // }
      },
    );
  }

  _buildCatchPlayerList(BuildContext context, Size size,
      MacthDetailResult macthDetailResult, int index) async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                content: SizedBox(
                  height: size.height / 2,
                  width: size.width,
                  child: Column(
                    children: [
                      Text(
                        'Select Catch Player ',
                        style: TextStyle(
                          color: ConstColors.black,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      SizedBox(
                        height: size.height / 3,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: macthDetailResult
                                .bowingTeam?.playerList?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCatchPlayer = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: size.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: selectedCatchPlayer == index
                                            ? ConstColors.black.withOpacity(0.5)
                                            : ConstColors.grayF4,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          macthDetailResult
                                                  .bowingTeam
                                                  ?.playerList?[index]
                                                  .playerName ??
                                              '',
                                          style: TextStyle(
                                            color: ConstColors.black,
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        selectedCatchPlayer == index
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      ConstColors.appBlueColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    ConstImages.rightArrowImg,
                                                    color: ConstColors.white,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      MaterialButton2(
                        minWidth: size.width,
                        buttonText: 'OK',
                        onPressed: () async {
                          _buildSelectNewBatsman(
                            size,
                            macthDetailResult,
                            index,
                            macthDetailResult.bowingTeam
                                    ?.playerList?[selectedCatchPlayer].playerId
                                    .toString() ??
                                '',
                          );
                          // showLoader(context);
                          // Map<String, dynamic> updateBolwerData = {
                          //   'match': widget.matchId.toString(),
                          //   'team': macthDetailResult.bowingTeam?.id.toString(),
                          //   'bowler': macthDetailResult.bowingTeam
                          //       ?.playerList?[selectedNewBolwer].playerId
                          //       .toString(),
                          // };
                          // await matchController.updateBolwerSink(
                          //   updateBolwer: updateBolwerData,
                          // );
                          // await matchController.getMatchSink(
                          //   matchId: widget.matchId,
                          // );
                          // hideLoader(context);
                          // if (!mounted) return;
                          // Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

//Extra ball
  Widget _buildExtraButton(Size size, MacthDetailResult macthDetailResult) {
    return _buildButtonView(
      buttonText: 'EXTRA',
      size: size,
      widget: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: ConstColors.white,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: SizedBox(
                height: size.height / 4,
                width: size.width,
                child: Column(
                  children: [
                    Text(
                      'Select Extra Run',
                      style: TextStyle(
                        color: ConstColors.black,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: extraType.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            showLoader(context);
                            Map<String, dynamic> updateData = {
                              'match': widget.matchId.toString(),
                              'batter': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                              'bowler':
                                  macthDetailResult.bowler?.bowlerId.toString(),
                              'non_striker': macthDetailResult.offStriker != ''
                                  ? macthDetailResult.offStriker
                                  : macthDetailResult.opener?[1].id.toString(),
                              'batsman_run': '0',
                              'extra_type':
                                  extraType[index]['type'] == 'No Ball'
                                      ? 'NB'
                                      : 'WD',
                              'extras_run': '1',
                              'isWicketDelivery': '0',
                              'player_out': '',
                              'kind': '',
                              'fielders_involved': '',
                              'BattingTeam':
                                  macthDetailResult.battingTeam?.id.toString(),
                              'BowlingTeam':
                                  macthDetailResult.bowingTeam?.id.toString(),
                              'on_striker': macthDetailResult.onStriker != ''
                                  ? macthDetailResult.onStriker
                                  : macthDetailResult.opener?[0].id.toString(),
                            };

                            await matchController.updateScoreSink(
                              updateScoreData: updateData,
                            );
                            await matchController.getMatchSink(
                              matchId: widget.matchId,
                            );
                            if (!mounted) return;
                            hideLoader(context);
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            backgroundColor: ConstColors.appGreen8FColor,
                            maxRadius: size.height * 0.02,
                            child: Text(
                              extraType[index]['type'],
                              style: TextStyle(
                                color: ConstColors.white,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dot Ball
  Widget _buildDotButton(Size size, MacthDetailResult macthDetailResult) {
    return _buildButtonView(
      buttonText: 'DOT',
      size: size,
      onTap: () async {
        showLoader(context);
        Map<String, dynamic> updateData = {
          'match': widget.matchId.toString(),
          'batter': macthDetailResult.onStriker != ''
              ? macthDetailResult.onStriker
              : macthDetailResult.opener?[0].id.toString(),
          'bowler': macthDetailResult.bowler?.bowlerId.toString(),
          'non_striker': macthDetailResult.offStriker != ''
              ? macthDetailResult.offStriker
              : macthDetailResult.opener?[1].id.toString(),
          'batsman_run': '0',
          'extra_type': '',
          'extras_run': '0',
          'isWicketDelivery': '0',
          'player_out': '',
          'kind': '',
          'fielders_involved': '',
          'BattingTeam': macthDetailResult.battingTeam?.id.toString(),
          'BowlingTeam': macthDetailResult.bowingTeam?.id.toString(),
          'on_striker': macthDetailResult.onStriker != ''
              ? macthDetailResult.onStriker
              : macthDetailResult.opener?[0].id.toString(),
        };

        await matchController.updateScoreSink(
          updateScoreData: updateData,
        );
        await matchController.getMatchSink(
          matchId: widget.matchId,
        );
        hideLoader(context);
      },
    );
  }

  // Dead Ball
  Widget _buildDeadButton(Size size, MacthDetailResult macthDetailResult) {
    return _buildButtonView(
      buttonText: 'DEAD',
      size: size,
      onTap: () async {
        showLoader(context);
        Map<String, dynamic> updateData = {
          'match': widget.matchId.toString(),
          'batter': macthDetailResult.onStriker != ''
              ? macthDetailResult.onStriker
              : macthDetailResult.opener?[0].id.toString(),
          'bowler': macthDetailResult.bowler?.bowlerId.toString(),
          'non_striker': macthDetailResult.offStriker != ''
              ? macthDetailResult.offStriker
              : macthDetailResult.opener?[1].id.toString(),
          'batsman_run': '0',
          'extra_type': 'DB',
          'extras_run': '0',
          'isWicketDelivery': '0',
          'player_out': '',
          'kind': '',
          'fielders_involved': '',
          'BattingTeam': macthDetailResult.battingTeam?.id.toString(),
          'BowlingTeam': macthDetailResult.bowingTeam?.id.toString(),
          'on_striker': macthDetailResult.onStriker != ''
              ? macthDetailResult.onStriker
              : macthDetailResult.opener?[0].id.toString(),
        };

        await matchController.updateScoreSink(
          updateScoreData: updateData,
        );
        await matchController.getMatchSink(
          matchId: widget.matchId,
        );
        hideLoader(context);
      },
    );
  }

//------------------------------------------------------------------ Buttons -----------------------------------------------------------------//

//End Match Button
  Widget _buildEndMatchBtn(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Container(
        decoration: const BoxDecoration(
            color: ConstColors.red,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: MaterialButton(
          onPressed: () async {
            showLoader(context);
            final response = await matchController.endMatchController(
                matchId: widget.matchId);
            if (response.status == true) {
              hideLoader(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text('Alert!'),
                    content: Text(
                      response.data?.result?.result.toString() ?? '',
                      style: const TextStyle(color: ConstColors.black),
                    ),
                    actions: [
                      MaterialButton2(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BottomBarScreen(selectedIndex: 0)),
                          );
                        },
                        buttonText: 'OK',
                      )
                    ],
                  );
                },
              );
            } else {
              hideLoader(context);
              Fluttertoast.showToast(msg: 'Please Enter Required Details.');
            }
          },
          minWidth: size.width,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(12),
          child: const Text(
            "End match",
            style: TextStyle(
              color: ConstColors.white,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
