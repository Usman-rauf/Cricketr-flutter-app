import 'package:flutter/material.dart';

import '../../../bottom_bar_screen.dart';
import '../../../constant/colors.dart';
import '../../../constant/images.dart';
import '../../../controller/team/team_controller.dart';
import '../../../model/response_model.dart';
import '../../../model/team/player_list_model.dart';
import '../../../widgtes/appbar.dart';
import '../../../widgtes/loader.dart';

class UpdatePlayerList extends StatefulWidget {
  UpdatePlayerList(
      {super.key,
      required this.selectedPlayerList,
      required this.teamName,
      required this.caption,
      required this.wicketKeeper,
      required this.id});
  List selectedPlayerList = [];
  String teamName;
  int caption;
  int wicketKeeper;
  int id;
  @override
  State<UpdatePlayerList> createState() => _UpdatePlayerListState();
}

class _UpdatePlayerListState extends State<UpdatePlayerList> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  TeamController teamController = TeamController();
  TextEditingController searchController = TextEditingController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  List<BATSMAN> battingSelectedPlayer = [];
  List<BATSMAN> ballingSelectedPlayer = [];
  List<BATSMAN> totalSelectedPlayer = [];

  @override
  void initState() {
    teamController.getPlayerList();
    getdata();
    super.initState();
  }

  getdata() async {
    ResponseModel<PlayerListModel> apiData =
        await teamController.getPlayerList();

    for (int i = 0; i < apiData.data!.playerListData!.bOWLER!.length; i++) {
      for (int j = 0; j < widget.selectedPlayerList.length; j++) {
        if (apiData.data!.playerListData!.bOWLER![i].id ==
            widget.selectedPlayerList[j].id) {
          apiData.data!.playerListData!.bOWLER![i].isPlayerSelected = true;
          ballingSelectedPlayer.add(apiData.data!.playerListData!.bOWLER![i]);
        }
      }
    }
    for (int i = 0; i < apiData.data!.playerListData!.bATSMAN!.length; i++) {
      for (int j = 0; j < widget.selectedPlayerList.length; j++) {
        if (apiData.data!.playerListData!.bATSMAN![i].id ==
            widget.selectedPlayerList[j].id) {
          apiData.data!.playerListData!.bATSMAN![i].isPlayerSelected = true;
          battingSelectedPlayer.add(apiData.data!.playerListData!.bATSMAN![i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BuildAppBar(
              title: 'Update Team',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SingleChildScrollView(
              child: StreamBuilder<ResponseModel<PlayerListModel>>(
                  stream: teamController.getPlayerListStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CommanCircular();
                    } else {
                      var playerList = snapshot.data?.data?.playerListData;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                        ),
                        child: Column(
                          children: [
                            DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  _buildTabBarView(size),
                                  SizedBox(
                                    height: size.height * 0.015,
                                  ),
                                  _buildSearchField(),
                                  SizedBox(
                                    height: size.height * 0.015,
                                  ),
                                  SizedBox(
                                    height: size.height / 1.8,
                                    child: TabBarView(
                                      children: [
                                        _battingPlayerList(size, playerList),
                                        _ballingPlayerList(size, playerList),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildContiuneButton(size)
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ],
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
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.search,
        ),
        hintText: 'Search Player',
      ),
    );
  }

  Widget _buildContiuneButton(Size size) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0CAB65),
              Color(0xff3BB78F),
              Color(0xff3BB78F),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: MaterialButton(
        onPressed: () async {
          totalSelectedPlayer.clear();
          totalSelectedPlayer.addAll(ballingSelectedPlayer);
          totalSelectedPlayer.addAll(battingSelectedPlayer);

          List updateList = [];
          for (int i = 0; i < totalSelectedPlayer.length; i++) {
            updateList.add(totalSelectedPlayer[i].id);
          }
          await teamController.updateTeamList(
              caption: widget.caption,
              id: widget.id,
              player: updateList,
              teamImage: "",
              teamName: widget.teamName,
              wicketKeeper: widget.wicketKeeper);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  BottomBarScreen(selectedIndex: 3),
            ),
          );
          // if (ballingSelectedPlayer.length < 2 ||
          //     battingSelectedPlayer.length < 2) {
          //   Fluttertoast.showToast(
          //       msg: "Please select min 2 player",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.CENTER,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.red,
          //       textColor: Colors.white,
          //       fontSize: 16.0);
          // } else if (totalSelectedPlayer.length > 11) {
          //   Fluttertoast.showToast(
          //       msg: "Alredy select 11 player",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.CENTER,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.red,
          //       textColor: Colors.white,
          //       fontSize: 16.0);
          // } else {
          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(
          //   //     builder: (context) => TeamOverViewScreen(
          //   //       selectedPlayerList: totalSelectedPlayer,
          //   //       teamName: widget.teamName,
          //   //     ),
          //   //   ),
          //   // );
          // }
        },
        minWidth: size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(12),
        child: Text(
          'Continue'.toUpperCase(),
          style: const TextStyle(
            color: ConstColors.white,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                Row(
                  children: [
                    // CachedNetworkImageView(
                    //   imageUrl: batsmanData?.profileImage ?? '',
                    //   username: batsmanData?.username ?? '',
                    //   imageSize: size.height * 0.04,
                    // ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      batsmanData?.username ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.015,
                      ),
                    ),
                    Image.asset(
                      batsmanData?.playerType == 'BATSMAN'
                          ? ConstImages.batIcon
                          : batsmanData?.playerType == 'ALL-ROUNDER'
                              ? ConstImages.allRounderIcon
                              : ConstImages.batIcon,
                    ),
                  ],
                ),
                batsmanData?.isPlayerSelected ?? false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            batsmanData?.isPlayerSelected =
                                !batsmanData.isPlayerSelected;
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
                              battingSelectedPlayer.add(batsmanData!);
                            } else {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                Row(
                  children: [
                    // CachedNetworkImageView(
                    //   imageUrl: bowlerData?.profileImage ?? '',
                    //   username: bowlerData?.username ?? '',
                    //   imageSize: size.height * 0.04,
                    // ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      bowlerData?.username ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.015,
                      ),
                    ),
                    Image.asset(
                      bowlerData?.playerType == 'BOWLER'
                          ? ConstImages.ballIcon
                          : bowlerData?.playerType == 'ALL-ROUNDER'
                              ? ConstImages.allRounderIcon
                              : ConstImages.ballIcon,
                    ),
                  ],
                ),
                bowlerData?.isPlayerSelected ?? false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            bowlerData?.isPlayerSelected =
                                !bowlerData.isPlayerSelected;

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
                                ballingSelectedPlayer.add(bowlerData!);
                              } else {
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
          ),
        );
      },
    );
  }
}
