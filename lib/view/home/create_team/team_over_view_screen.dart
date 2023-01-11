import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/controller/team/team_controller.dart';
import 'package:cricketly/model/team/player_list_model.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:flutter/material.dart';

class TeamOverViewScreen extends StatefulWidget {
  final String teamName;
  final List<BATSMAN> selectedPlayerList;
  const TeamOverViewScreen({
    super.key,
    required this.selectedPlayerList,
    required this.teamName,
  });

  @override
  State<TeamOverViewScreen> createState() => _TeamOverViewScreenState();
}

class _TeamOverViewScreenState extends State<TeamOverViewScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  TeamController teamController = TeamController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  int wicketKeeper = 0;
  int selectedCaptain = 0;
  List<int> selectedPlayersId = [];

  @override
  void initState() {
    super.initState();
    widget.selectedPlayerList.map((e) {
      selectedPlayersId.add(e.id ?? 0);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BuildAppBar(
                title: widget.teamName,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildListView(size),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    MaterialButton2(
                      minWidth: size.width,
                      buttonText: 'Save Team',
                      onPressed: () async {
                        Map<String, dynamic> teamPostData = {
                          'team_name': widget.teamName,
                          'team_image': '',
                          'caption': widget
                              .selectedPlayerList[selectedCaptain].id
                              .toString(),
                          'wicket_keeper': widget
                              .selectedPlayerList[wicketKeeper].id
                              .toString(),
                          'player': selectedPlayersId.toString(),
                        };
                        showLoader(context);
                        var teamCreateResponse = await teamController
                            .createTeamController(teamPostData: teamPostData);

                        // showLoader(context);
                        // var teamCreateResponse =
                        //     await teamController.createTeamController(
                        //   teamName: widget.teamName,
                        //   teamImage: '',
                        //   captaionId:
                        //       widget.selectedPlayerList[selectedCaptain].id ??
                        //           0,
                        //   wicketKepperId:
                        //       widget.selectedPlayerList[wicketKeeper].id ?? 0,
                        //   players: selectedPlayersId,
                        // );
                        if (teamCreateResponse.data?.status == 200) {
                          if (!mounted) return;
                          hideLoader(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomBarScreen(
                                selectedIndex: 1,
                              ),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          hideLoader(context);
                          showTostMessage(
                            message: teamCreateResponse.message ?? '',
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(Size size) {
    return ListView.builder(
      itemCount: widget.selectedPlayerList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var playerData = widget.selectedPlayerList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImageView(
                    imageUrl: playerData.profileImage ?? '',
                    username: playerData.username ?? '',
                    imageSize: size.height * 0.05,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    playerData.username ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.018,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCaptain = index;
                      });
                    },
                    child: Container(
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedCaptain == index
                            ? ConstColors.appGreen8FColor
                            : ConstColors.black.withOpacity(0.2),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: selectedCaptain == index
                                  ? ConstColors.white
                                  : ConstColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        wicketKeeper = index;
                      });
                    },
                    child: Container(
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: wicketKeeper == index
                            ? ConstColors.appGreen8FColor
                            : ConstColors.black.withOpacity(0.2),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'W',
                            style: TextStyle(
                              color: wicketKeeper == index
                                  ? ConstColors.white
                                  : ConstColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
