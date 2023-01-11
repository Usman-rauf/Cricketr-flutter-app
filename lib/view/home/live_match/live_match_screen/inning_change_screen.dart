import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/model/match/match_detail_model.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IningChangeScreen extends StatefulWidget {
  final MacthDetailResult? macthDetailResult;
  final String matchId;
  const IningChangeScreen(
      {super.key, required this.macthDetailResult, required this.matchId});

  @override
  State<IningChangeScreen> createState() => _IningChangeScreenState();
}

class _IningChangeScreenState extends State<IningChangeScreen> {
  MatchController matchController = MatchController();
  PlayerList? opener1Player;
  PlayerList? opener2Player;
  PlayerList? bowlerPlayer;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          BuildAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Change Inning',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                _buildSelectedOpner1(),
                SizedBox(
                  height: size.height * 0.03,
                ),
                _buildSelectedOpner2(),
                SizedBox(
                  height: size.height * 0.03,
                ),
                _buildSelectedBolwer(),
                SizedBox(
                  height: size.height * 0.1,
                ),
                MaterialButton2(
                  buttonText: 'Continue',
                  minWidth: size.width,
                  onPressed: () async {
                    if (opener1Player != null ||
                        opener2Player != null ||
                        bowlerPlayer != null) {
                      showLoader(context);
                      Map<String, dynamic> changeInningData = {
                        "match": widget.matchId,
                        'inning': '2',
                        'opener': '${[
                          opener1Player?.playerId,
                          opener2Player?.playerId,
                        ]}',
                        'batting_team':
                            widget.macthDetailResult?.bowingTeam?.id.toString(),
                        'bowing_team': widget.macthDetailResult?.battingTeam?.id
                            .toString(),
                        'bowler': bowlerPlayer?.playerId.toString(),
                      };
                      var response = await matchController.changeInningSink(
                        changeInningData: changeInningData,
                      );
                      if (response.status == true) {
                        if (!mounted) return;
                        // hideLoader(context);
                        await matchController
                            .getMatchSink(matchId: widget.matchId)
                            .then((value) {
                          hideLoader(context);
                          Navigator.pop(context);
                        });
                      } else {
                        if (!mounted) return;
                        hideLoader(context);

                        showTostMessage(message: response.message.toString());
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please Enter Required Details.');
                    }
                  },
                ),
              ],
            ),
          )
        ],
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
          'Select Opener 1*',
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
            child: DropdownButton2<PlayerList>(
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
                onChanged: (PlayerList? newValue) {
                  setState(() {
                    opener1Player = newValue;
                  });
                },
                items: widget.macthDetailResult?.bowingTeam?.playerList?.map(
                  (selectOpener1) {
                    return DropdownMenuItem(
                      value: selectOpener1,
                      enabled: selectOpener1 != opener2Player,
                      child: Text(
                        selectOpener1.playerName ?? '',
                        style: TextStyle(
                          color: selectOpener1 != opener2Player
                              ? ConstColors.black
                              : ConstColors.grayF4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ).toList()),
          ),
        ),
      ],
    );
  }

  // Opener 2
  Widget _buildSelectedOpner2() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Opener 2*',
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
            child: DropdownButton2<PlayerList>(
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
                onChanged: (PlayerList? newValue) {
                  setState(() {
                    opener2Player = newValue;
                  });
                },
                items: widget.macthDetailResult?.bowingTeam?.playerList?.map(
                  (selectOpener1) {
                    return DropdownMenuItem(
                      value: selectOpener1,
                      enabled: selectOpener1 != opener1Player,
                      child: Text(
                        selectOpener1.playerName ?? '',
                        style: TextStyle(
                          color: selectOpener1 != opener1Player
                              ? ConstColors.black
                              : ConstColors.grayF4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ).toList()),
          ),
        ),
      ],
    );
  }

  // Bolwer
  Widget _buildSelectedBolwer() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Bowler*',
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
            child: DropdownButton2<PlayerList>(
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
                onChanged: (PlayerList? newValue) {
                  setState(() {
                    bowlerPlayer = newValue;
                  });
                },
                items: widget.macthDetailResult?.battingTeam?.playerList?.map(
                  (bolwer) {
                    return DropdownMenuItem(
                      value: bolwer,
                      child: Text(
                        bolwer.playerName ?? '',
                        style: const TextStyle(
                          color: ConstColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ).toList()),
          ),
        ),
      ],
    );
  }
}
