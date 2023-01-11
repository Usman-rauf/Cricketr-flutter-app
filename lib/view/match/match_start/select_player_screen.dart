import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SelectPlayerScreen extends StatefulWidget {
  final TeamInfo teamA;
  final TeamInfo teamB;
  final Map<String, dynamic> matchInfo;
  final bool isUpdate;
  const SelectPlayerScreen({
    super.key,
    required this.matchInfo,
    required this.teamA,
    required this.teamB,
    required this.isUpdate,
  });

  @override
  State<SelectPlayerScreen> createState() => _SelectPlayerScreenState();
}

class _SelectPlayerScreenState extends State<SelectPlayerScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  MatchController matchController = MatchController();
  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//

  bool isSelectTeam = true;
  bool isSelectBatting = true;
  String? selectedBattingTeam;
  String? selectedBalingTeam;
  Player? opener1Player;
  Player? opener2Player;
  Player? bowlerPlayer;

  //--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BuildAppBar(
                title: 'Select Players',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  children: [
                    _buildDivider(size, 'Select Toss Winning Team'),
                    SizedBox(height: size.height * 0.02),
                    _selectTeamView(size),
                    SizedBox(height: size.height * 0.02),
                    _buildDivider(size, 'Select Batting Or Bowling'),
                    SizedBox(height: size.height * 0.02),
                    _selectBattingOrBowlingView(size),
                    SizedBox(height: size.height * 0.02),
                    _buildDivider(size, 'Openers'),
                    SizedBox(height: size.height * 0.02),
                    _buildSelectedOpner1(),
                    SizedBox(height: size.height * 0.02),
                    _buildSelectedOpner2(),
                    SizedBox(height: size.height * 0.02),
                    _buildDivider(size, 'Bowlers'),
                    SizedBox(height: size.height * 0.02),
                    _buildSelectBowlers(),
                    SizedBox(height: size.height * 0.04),
                    _buildStartMatchButton(size, context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Opener 1
  Widget _buildSelectedOpner1() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Opener 1',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ConstColors.darkGray7C,
            fontSize: 14,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: ConstColors.whiteColorF9,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: ConstColors.boardColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<Player>(
              isExpanded: true,
              dropdownMaxHeight: size.height * 0.2,
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: ConstColors.colorA1,
                ),
              ),
              hint: Text(
                'Select opener',
                style: TextStyle(
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: opener1Player,
              onChanged: (Player? newValue) {
                setState(() {
                  opener1Player = newValue;
                });
              },
              items: isSelectTeam && isSelectBatting
                  ? widget.teamA.players?.map((selectOpener1) {
                      return DropdownMenuItem(
                        value: selectOpener1,
                        enabled: selectOpener1 != opener2Player,
                        child: Text(
                          selectOpener1.username ?? '',
                          style: TextStyle(
                            color: selectOpener1 != opener2Player
                                ? ConstColors.black
                                : ConstColors.grayF4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList()
                  : !isSelectTeam && isSelectBatting
                      ? widget.teamB.players?.map((selectOpener1) {
                          return DropdownMenuItem(
                            value: selectOpener1,
                            enabled: selectOpener1 != opener2Player,
                            child: Text(
                              selectOpener1.username ?? '',
                              style: TextStyle(
                                color: selectOpener1 != opener2Player
                                    ? ConstColors.black
                                    : ConstColors.grayF4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList()
                      : isSelectTeam && !isSelectBatting
                          ? widget.teamB.players?.map((selectOpener1) {
                              return DropdownMenuItem(
                                value: selectOpener1,
                                enabled: selectOpener1 != opener2Player,
                                child: Text(
                                  selectOpener1.username ?? '',
                                  style: TextStyle(
                                    color: selectOpener1 != opener2Player
                                        ? ConstColors.black
                                        : ConstColors.grayF4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList()
                          : widget.teamA.players?.map(
                              (selectOpener1) {
                                return DropdownMenuItem(
                                  value: selectOpener1,
                                  enabled: selectOpener1 != opener2Player,
                                  child: Text(
                                    selectOpener1.username ?? '',
                                    style: TextStyle(
                                      color: selectOpener1 != opener2Player
                                          ? ConstColors.black
                                          : ConstColors.grayF4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Opener 1
  Widget _buildSelectedOpner2() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Opener 2',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ConstColors.darkGray7C,
            fontSize: 14,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: ConstColors.whiteColorF9,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: ConstColors.boardColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<Player>(
              isExpanded: true,
              dropdownMaxHeight: size.height * 0.2,
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: ConstColors.colorA1,
                ),
              ),
              hint: Text(
                'Select opener',
                style: TextStyle(
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: opener2Player,
              onChanged: (Player? newValue) {
                setState(() {
                  opener2Player = newValue;
                });
              },
              items: isSelectTeam && isSelectBatting
                  ? widget.teamA.players?.map((selectOpener1) {
                      return DropdownMenuItem(
                        value: selectOpener1,
                        enabled: selectOpener1 != opener1Player,
                        child: Text(
                          selectOpener1.username ?? '',
                          style: TextStyle(
                            color: selectOpener1 != opener1Player
                                ? ConstColors.black
                                : ConstColors.grayF4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList()
                  : !isSelectTeam && isSelectBatting
                      ? widget.teamB.players?.map((selectOpener1) {
                          return DropdownMenuItem(
                            value: selectOpener1,
                            enabled: selectOpener1 != opener1Player,
                            child: Text(
                              selectOpener1.username ?? '',
                              style: TextStyle(
                                color: selectOpener1 != opener1Player
                                    ? ConstColors.black
                                    : ConstColors.grayF4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList()
                      : isSelectTeam && !isSelectBatting
                          ? widget.teamB.players?.map((selectOpener1) {
                              return DropdownMenuItem(
                                value: selectOpener1,
                                enabled: selectOpener1 != opener1Player,
                                child: Text(
                                  selectOpener1.username ?? '',
                                  style: TextStyle(
                                    color: selectOpener1 != opener1Player
                                        ? ConstColors.black
                                        : ConstColors.grayF4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList()
                          : widget.teamA.players?.map(
                              (selectOpener1) {
                                return DropdownMenuItem(
                                  value: selectOpener1,
                                  enabled: selectOpener1 != opener1Player,
                                  child: Text(
                                    selectOpener1.username ?? '',
                                    style: TextStyle(
                                      color: selectOpener1 != opener1Player
                                          ? ConstColors.black
                                          : ConstColors.grayF4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Bolwer
  Widget _buildSelectBowlers() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Bowler',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ConstColors.darkGray7C,
            fontSize: 14,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: ConstColors.whiteColorF9,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: ConstColors.boardColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<Player>(
              isExpanded: true,
              dropdownMaxHeight: size.height * 0.2,
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: ConstColors.colorA1,
                ),
              ),
              hint: Text(
                'Select Bowler',
                style: TextStyle(
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: bowlerPlayer,
              onChanged: (Player? newValue) {
                setState(() {
                  bowlerPlayer = newValue;
                });
              },
              items: isSelectTeam && isSelectBatting
                  ? widget.teamB.players?.map((selectOpener1) {
                      return DropdownMenuItem(
                        value: selectOpener1,
                        child: Text(
                          selectOpener1.username ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList()
                  : !isSelectTeam && isSelectBatting
                      ? widget.teamA.players?.map((selectOpener1) {
                          return DropdownMenuItem(
                            value: selectOpener1,
                            child: Text(
                              selectOpener1.username ?? '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList()
                      : isSelectTeam && !isSelectBatting
                          ? widget.teamA.players?.map((selectOpener1) {
                              return DropdownMenuItem(
                                value: selectOpener1,
                                child: Text(
                                  selectOpener1.username ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList()
                          : widget.teamB.players?.map(
                              (selectOpener1) {
                                return DropdownMenuItem(
                                  value: selectOpener1,
                                  child: Text(
                                    selectOpener1.username ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  //------------------------------------------------------------------ Helper Widgtes -----------------------------------------------------------------//

  // select batting or bowling view
  Widget _selectBattingOrBowlingView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            selectBattingCommanContainer(
              teamName: "Batting",
              forMatch: isSelectBatting,
              isTap: true,
              onPressed: () {
                setState(() {
                  isSelectBatting = true;
                  selectedBattingTeam = isSelectBatting && isSelectTeam
                      ? widget.teamA.teamName
                      : isSelectBatting && !isSelectTeam
                          ? widget.teamB.teamName
                          : !isSelectBatting && !isSelectTeam
                              ? widget.teamA.teamName
                              : widget.teamB.teamName;
                  opener1Player = null;
                  opener2Player = null;
                  bowlerPlayer = null;
                  isSelectTeam = isSelectTeam;
                });
              },
            ),
            SizedBox(width: size.width * 0.02),
            selectBattingCommanContainer(
              teamName: "Fielding",
              forMatch: isSelectBatting,
              isTap: false,
              onPressed: () {
                setState(() {
                  isSelectBatting = false;
                  selectedBattingTeam = isSelectBatting && isSelectTeam
                      ? widget.teamA.teamName
                      : isSelectBatting && !isSelectTeam
                          ? widget.teamB.teamName
                          : !isSelectBatting && !isSelectTeam
                              ? widget.teamA.teamName
                              : widget.teamB.teamName;
                  opener1Player = null;
                  opener2Player = null;
                  bowlerPlayer = null;
                  isSelectTeam = isSelectTeam;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  // select batting or bowling view
  Widget _selectTeamView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            selectTeamCommanContainer(
              teamName: widget.teamA.teamName ?? '',
              forMatch: isSelectTeam,
              isTap: true,
              teamImage: widget.teamA.teamImage ?? '',
              onPressed: () {
                setState(() {
                  isSelectTeam = true;
                  opener1Player = null;
                  opener2Player = null;
                  bowlerPlayer = null;
                  selectedBattingTeam = isSelectBatting && isSelectTeam
                      ? widget.teamA.teamName
                      : isSelectBatting && !isSelectTeam
                          ? widget.teamB.teamName
                          : !isSelectBatting && !isSelectTeam
                              ? widget.teamA.teamName
                              : widget.teamB.teamName;
                });
              },
            ),
            Text(
              'VS',
              style: TextStyle(
                color: ConstColors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.02,
              ),
            ),
            selectTeamCommanContainer(
              teamName: widget.teamB.teamName ?? '',
              forMatch: isSelectTeam,
              isTap: false,
              teamImage: widget.teamB.teamImage ?? '',
              onPressed: () {
                setState(() {
                  isSelectTeam = false;
                  opener1Player = null;
                  opener2Player = null;
                  bowlerPlayer = null;
                  selectedBattingTeam = isSelectBatting && isSelectTeam
                      ? widget.teamA.teamName
                      : isSelectBatting && !isSelectTeam
                          ? widget.teamB.teamName
                          : !isSelectBatting && !isSelectTeam
                              ? widget.teamA.teamName
                              : widget.teamB.teamName;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider(Size size, String title) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: ConstColors.grayF4,
            height: 1,
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: ConstColors.darkGray7C,
            fontSize: 14,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Expanded(
          child: Container(
            color: ConstColors.grayF4,
            height: 1,
          ),
        ),
      ],
    );
  }

  // select team comman container
  Widget selectTeamCommanContainer({
    required bool isTap,
    required void Function()? onPressed,
    required String teamName,
    required bool forMatch,
    required String teamImage,
  }) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: size.width * 0.35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  forMatch == isTap ? ConstColors.ofwhite : ConstColors.grayF4,
              shape: BoxShape.circle,
              border: Border.all(
                color: forMatch == isTap
                    ? ConstColors.grayColor95
                    : Colors.transparent,
                width: forMatch == isTap ? 3 : 1,
              ),
            ),
            child: CachedNetworkImageView(
              imageUrl: teamImage,
              username: teamName,
              imageSize: size.height * 0.09,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            teamName,
            style: const TextStyle(
              color: ConstColors.black,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // select team comman container
  Widget selectBattingCommanContainer({
    required bool isTap,
    required void Function()? onPressed,
    required String teamName,
    required bool forMatch,
  }) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width * 0.35,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.04,
        ),
        decoration: BoxDecoration(
            color: forMatch == isTap ? ConstColors.ofwhite : ConstColors.grayF4,
            shape: BoxShape.circle,
            border: Border.all(
              color: forMatch == isTap
                  ? ConstColors.appGreen8FColor
                  : Colors.transparent,
            )),
        child: Text(
          teamName,
          style: const TextStyle(
            color: ConstColors.black,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  //------------------------------------------------------------------ Buttons -----------------------------------------------------------------//
  //Start Match Button
  Widget _buildStartMatchButton(Size size, BuildContext context) {
    return MaterialButton2(
      minWidth: size.width,
      buttonText: 'Start match',
      onPressed: () async {
        if (opener1Player != null &&
            opener2Player != null &&
            bowlerPlayer != null) {
          showLoader(context);

          widget.matchInfo.addAll(
            {
              'team1': widget.teamA.id.toString(),
              'team2': widget.teamB.id.toString(),
              'tose_winner': isSelectTeam
                  ? widget.teamA.id.toString()
                  : widget.teamB.id.toString(),
              'toss_decision': isSelectBatting ? 'bat' : 'bowl',
              'opener': '${[
                opener1Player?.id.toString(),
                opener2Player?.id.toString()
              ]}',
              'is_toss': "1",
              'bowler': bowlerPlayer?.id.toString(),
              'bowing_team': selectedBattingTeam == widget.teamA.teamName
                  ? widget.teamB.id.toString()
                  : widget.teamA.id.toString(),
              'batting_team': selectedBattingTeam == widget.teamA.teamName
                  ? widget.teamA.id.toString()
                  : widget.teamB.id.toString()
            },
          );
          if (widget.isUpdate) {
            var selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
            var selectedTime = DateFormat('HH:mm:ss').format(DateTime.now());
            widget.matchInfo.update('date', (value) => selectedDate.toString());
            widget.matchInfo.update('time', (value) => selectedTime.toString());

            final createMatchResponse = await matchController.updateMatchSink(
                updateMatchInfo: widget.matchInfo,
                matchId: widget.matchInfo['matchId'].toString());
            if (createMatchResponse.status == true) {
              if (!mounted) return;
              hideLoader(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(selectedIndex: 0),
                ),
              );
            } else {
              if (!mounted) return;
              hideLoader(context);
              showTostMessage(message: createMatchResponse.message.toString());
            }
          } else {
            final createMatchResponse = await matchController.createMatchSink(
                createMatchInfo: widget.matchInfo);
            if (createMatchResponse.data?.status == 200) {
              if (!mounted) return;
              hideLoader(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(selectedIndex: 0),
                ),
              );
            } else {
              if (!mounted) return;
              hideLoader(context);
              showTostMessage(message: createMatchResponse.message.toString());
            }
          }
        } else {
          Fluttertoast.showToast(msg: 'Please select player');
        }
      },
    );
  }
}
