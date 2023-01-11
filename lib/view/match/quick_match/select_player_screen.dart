import 'package:cricketly/controller/team/team_controller.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/player_list_model.dart';
import 'package:cricketly/view/match/quick_match/match_players_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/custom_dialog.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:cricketly/widgtes/user_card.dart';
import 'package:flutter/material.dart';
import '../../../constant/colors.dart';
import '../../../constant/images.dart';
import '../../../widgtes/button.dart';
import '../../../widgtes/dialogs.dart';

class SelectPlayersScreen extends StatefulWidget {
  const SelectPlayersScreen({super.key});

  @override
  State<SelectPlayersScreen> createState() => _SelectPlayersScreenState();
}

class _SelectPlayersScreenState extends State<SelectPlayersScreen> {
//------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  TeamController teamController = TeamController();
  UserController userController = UserController();
  TextEditingController searchController = TextEditingController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  List<BATSMAN> battingSelectedPlayer = [];
  List<BATSMAN> ballingSelectedPlayer = [];
  List<BATSMAN> totalSelectedPlayer = [];
  List<String> selectedPlayerId = [];

  @override
  void initState() {
    teamController.getPlayerList();
    super.initState();
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          _buildTabBarView(size),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          _buildSearchField(),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          StreamBuilder<ResponseModel<PlayerListModel>>(
                            stream: teamController.getPlayerListStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox(
                                  height: size.height / 1.75,
                                  child: const CommanCircular(),
                                );
                              } else {
                                var playerList =
                                    snapshot.data?.data?.playerListData;
                                return SizedBox(
                                  height: size.height / 1.75,
                                  child: TabBarView(
                                    children: [
                                      _battingPlayerList(size, playerList),
                                      _ballingPlayerList(size, playerList),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildContiuneButton(size)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Tabbar View
  Widget _buildTabBarView(Size size) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          size.height * 0.015,
        ),
      ),
      child: Material(
        child: TabBar(
          labelColor: ConstColors.appGreen8FColor,
          unselectedLabelColor: ConstColors.black,
          indicatorColor: ConstColors.appGreen8FColor,
          indicator: const UnderlineTabIndicator(
            borderSide:
                BorderSide(width: 5.0, color: ConstColors.appGreen8FColor),
            insets: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
          ),
          tabs: [
            Tab(
              text: "Batsman (${battingSelectedPlayer.length})",
              icon: Image.asset(
                ConstImages.batIcon,
              ),
            ),
            Tab(
              text: "Bowlers (${ballingSelectedPlayer.length})",
              icon: Image.asset(
                ConstImages.ballIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }

//Search Textfield
  Widget _buildSearchField() {
    return TextFormField(
      onTap: () {},
      controller: searchController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
        ),
        fillColor: Colors.grey[200],
        hintText: 'Search Player',
      ),
    );
  }

  Widget _buildContiuneButton(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: MaterialButton2(
        minWidth: size.width,
        buttonText: 'Continue'.toUpperCase(),
        onPressed: () async {
          totalSelectedPlayer.clear();
          totalSelectedPlayer.addAll(ballingSelectedPlayer);
          totalSelectedPlayer.addAll(battingSelectedPlayer);
          if (totalSelectedPlayer.length < 2) {
            showTostMessage(message: 'Please select min 2 player');
          } else if (totalSelectedPlayer.length > 11) {
            showTostMessage(message: 'You have already selected 11 players.');
          } else {
            showLoader(context);

            var createUserREsponse = await teamController.selectTeamList(
              teamPostData: {'user': selectedPlayerId.toString()},
            );
            if (createUserREsponse.data?.status == 200) {
              if (!mounted) return;
              hideLoader(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchPlayersScreen(
                    teamA: createUserREsponse.data!.result!.team1!,
                    teamB: createUserREsponse.data!.result!.team2!,
                  ),
                ),
              );
            } else {
              if (!mounted) return;
              hideLoader(context);
              showTostMessage(message: createUserREsponse.message ?? '');
            }
          }
        },
      ),
    );
  }

  Widget _battingPlayerList(Size size, PlayerListData? playerListData) {
    return ListView.builder(
      itemCount: playerListData?.bATSMAN?.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var batsmanData = playerListData?.bATSMAN?[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: ConstColors.grayColor95.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final getUserResponse =
                        await userController.getUserInfoSink(
                            userId: batsmanData?.id.toString() ?? '');
                    if (getUserResponse.data?.status == 200) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialogBox(
                            userInfo: getUserResponse.data!.userData!,
                          );
                        },
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImageView(
                            imageUrl: batsmanData?.profileImage ?? '',
                            username: batsmanData?.username ?? '',
                            imageSize: size.height * 0.05,
                            textSize: size.height * 0.02,
                          ),
                          batsmanData?.playerType == 'ALL-ROUNDER' ||
                                  batsmanData?.playerType == 'WICKET-KEEPER'
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset(
                                    ConstImages.allRounderIcon,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Text(
                        capitalizeAllWord(batsmanData?.username ?? ''),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.015,
                        ),
                      ),
                    ],
                  ),
                ),
                batsmanData?.isPlayerSelected ?? false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            batsmanData?.isPlayerSelected =
                                !batsmanData.isPlayerSelected;
                            selectedPlayerId
                                .remove(batsmanData?.id.toString() ?? '');
                            battingSelectedPlayer.remove(batsmanData);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: ConstColors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: const Icon(
                            Icons.remove,
                            color: ConstColors.white,
                          ),
                        ))
                    : InkWell(
                        onTap: () {
                          setState(() {
                            batsmanData?.isPlayerSelected =
                                !batsmanData.isPlayerSelected;
                            if (batsmanData?.isPlayerSelected ?? false) {
                              selectedPlayerId
                                  .add(batsmanData?.id.toString() ?? '');
                              battingSelectedPlayer.add(batsmanData!);
                            } else {
                              selectedPlayerId
                                  .remove(batsmanData?.id.toString() ?? '');
                              battingSelectedPlayer.remove(batsmanData);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: ConstColors.appGreen8FColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: const Icon(
                            Icons.add,
                            color: ConstColors.white,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

// Bowler Player List
  Widget _ballingPlayerList(Size size, PlayerListData? playerListData) {
    return ListView.builder(
      itemCount: playerListData?.bOWLER?.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var bowlerData = playerListData?.bOWLER?[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: ConstColors.grayColor95.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final getUserResponse =
                        await userController.getUserInfoSink(
                            userId: bowlerData?.id.toString() ?? '');
                    if (getUserResponse.data?.status == 200) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialogBox(
                            userInfo: getUserResponse.data!.userData!,
                          );
                        },
                      );
                    }
                  },
                  child: Row(
                    children: [
                      CachedNetworkImageView(
                        imageUrl: bowlerData?.profileImage ?? '',
                        username: bowlerData?.username ?? '',
                        imageSize: size.height * 0.05,
                        textSize: size.height * 0.02,
                      ),
                      bowlerData?.playerType == 'ALL-ROUNDER' ||
                              bowlerData?.playerType == 'WICKET-KEEPER'
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                ConstImages.allRounderIcon,
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Text(
                        capitalizeAllWord(bowlerData?.username ?? ''),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.015,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    bowlerData?.isPlayerSelected ?? false
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                bowlerData?.isPlayerSelected =
                                    !bowlerData.isPlayerSelected;
                                selectedPlayerId
                                    .remove(bowlerData?.id.toString() ?? '');
                                ballingSelectedPlayer.remove(bowlerData);
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: ConstColors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Icon(
                                  Icons.remove,
                                  color: ConstColors.white,
                                )))
                        : InkWell(
                            onTap: () {
                              setState(
                                () {
                                  bowlerData?.isPlayerSelected =
                                      !bowlerData.isPlayerSelected;

                                  if (bowlerData?.isPlayerSelected ?? false) {
                                    selectedPlayerId
                                        .add(bowlerData?.id.toString() ?? '');
                                    ballingSelectedPlayer.add(bowlerData!);
                                  } else {
                                    selectedPlayerId.remove(
                                        bowlerData?.id.toString() ?? '');
                                    ballingSelectedPlayer.remove(bowlerData);
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: ConstColors.appGreen8FColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: const Icon(
                                Icons.add,
                                color: ConstColors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
