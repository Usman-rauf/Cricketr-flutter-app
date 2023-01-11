import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/view/match/match_start/toss_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:flutter/material.dart';

class TeamPlayerListScreen extends StatefulWidget {
  final String teamAName;
  final String teamBName;
  final String matchId;
  final Map<String, dynamic> matchInfo;
  const TeamPlayerListScreen({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.matchId,
    required this.matchInfo,
  });

  @override
  State<TeamPlayerListScreen> createState() => _TeamPlayerListScreenState();
}

class _TeamPlayerListScreenState extends State<TeamPlayerListScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  MatchController matchController = MatchController();

  @override
  void initState() {
    matchController.getTeamPlayerController(matchId: widget.matchId);
    super.initState();
  }

//--------------------------------------------------------------------- UI ---------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BuildAppBar(
              title: '${widget.teamAName}  vs  ${widget.teamBName}',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            StreamBuilder<ResponseModel<GetTeamPlayerListModel>>(
              stream: matchController.getTeamPlayersStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: size.height / 1.5,
                    child: const CommanCircular(),
                  );
                } else {
                  var getTeamsPlayerData = snapshot.data?.data?.playersInfo;
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      children: [
                        _buildTeamA(getTeamsPlayerData!, size),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        _buildTeamB(getTeamsPlayerData, size),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        widget.matchInfo['umpire'].toString() ==
                                preferences.getString(Keys.userID)
                            ? _buildContinueButton(
                                size, context, getTeamsPlayerData)
                            : const SizedBox(),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(
      Size size, BuildContext context, List<TeamInfo> getTeamsPlayerData) {
    return MaterialButton2(
      minWidth: size.width,
      buttonText: 'Continue',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text('Are you sure?'),
              content: const Text('You want to start match now?'),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                MaterialButton2(
                  buttonText: 'Yes',
                  minWidth: size.width / 3.5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TossScreen(
                          matchInfo: widget.matchInfo,
                          teamA: getTeamsPlayerData[0],
                          teamB: getTeamsPlayerData[1],
                          isUpdate: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

// Team A Player List
  Widget _buildTeamA(List<TeamInfo> getTeamsPlayerData, Size size) {
    return Column(
      children: [
        _buildDividerView(
          teamName: getTeamsPlayerData[0].teamName ?? '',
          size: size,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        SizedBox(
          height: size.height / 4,
          width: size.width,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              childAspectRatio: 3,
            ),
            itemCount: getTeamsPlayerData[0].players?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var playerInfo = getTeamsPlayerData[0].players?[index];
              return Row(
                children: [
                  CachedNetworkImageView(
                    imageUrl: playerInfo?.profileImage ?? "",
                    username: playerInfo?.username ?? '',
                    imageSize: size.height * 0.06,
                    textSize: size.height * 0.02,
                  ),
                  SizedBox(width: size.width * 0.01),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.2,
                          child: Text(
                            playerInfo?.username ?? '',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        getTeamsPlayerData[0].caption == playerInfo?.id
                            ? playerTypeCont(text: 'C')
                            : const SizedBox(),
                        getTeamsPlayerData[0].wicketKeeper == playerInfo?.id
                            ? playerTypeCont(text: 'W')
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

// Team B Player List
  Widget _buildTeamB(List<TeamInfo> getTeamsPlayerData, Size size) {
    return Column(
      children: [
        _buildDividerView(
          teamName: getTeamsPlayerData[1].teamName ?? '',
          size: size,
        ),
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height / 4,
          width: size.width,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              childAspectRatio: 3,
            ),
            itemCount: getTeamsPlayerData[1].players?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var playerInfo = getTeamsPlayerData[1].players?[index];
              return Row(
                children: [
                  CachedNetworkImageView(
                    imageUrl: playerInfo?.profileImage ?? "",
                    username: playerInfo?.username ?? '',
                    imageSize: size.height * 0.06,
                    textSize: size.height * 0.02,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.2,
                          child: Text(
                            playerInfo?.username ?? '',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        getTeamsPlayerData[1].caption == playerInfo?.id
                            ? playerTypeCont(text: 'C')
                            : const SizedBox(),
                        getTeamsPlayerData[1].wicketKeeper == playerInfo?.id
                            ? playerTypeCont(text: 'W')
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget playerTypeCont({required String text}) {
    return Container(
      alignment: Alignment.center,
      width: 17,
      height: 17,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: ConstColors.appGreen8FColor,
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
      ),
    );
  }

  Widget _buildDividerView({
    required String teamName,
    required Size size,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: ConstColors.appGreen8FColor,
            height: 1,
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Text(
          teamName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: size.height * 0.022,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Expanded(
          child: Container(
            color: ConstColors.appGreen8FColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}
