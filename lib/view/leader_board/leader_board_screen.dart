import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/user/leaderboard_model.dart';
import 'package:cricketly/model/user/world_leadserboard.dart';
import 'package:cricketly/view/leader_board/country_leaderboard/country_leaderboard_screen.dart';
import 'package:cricketly/view/leader_board/world_leaderboard/world_leaderboard_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  UserController userController = UserController();
  final List<String> _playerTypeList = [
    'BATSMAN',
    'BOWLER',
    'WICKET-KEEPER',
    'ALL-ROUNDER'
  ];
  String? _selectedPlayerType;
  @override
  void initState() {
    userController.leaderBoardSink();
    userController.worldLeadrBoard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BuildAppBar(
              title: 'Leaderboard',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // _buildSelectedDropDown(),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        Material(
                          elevation: 7,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Container(
                            // padding: EdgeInsets.symmetric(vertical: ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            constraints: BoxConstraints.expand(
                                height: size.height * 0.09),
                            child: TabBar(
                              indicatorColor: ConstColors.appGreen8FColor,
                              indicatorWeight: 5,
                              labelColor: ConstColors.black,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              tabs: [
                                Tab(
                                  text: "World",
                                  icon: SvgPicture.asset(ConstImages.worldIcon,
                                      height: size.height * 0.025),
                                ),
                                Tab(
                                  text: "Country",
                                  icon: Text(
                                    '',
                                    // '🇧🇭',
                                    style: TextStyle(
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height / 1.8,
                          child: TabBarView(
                            children: [
                              StreamBuilder<
                                      ResponseModel<WorldLeaderBoardModel>>(
                                  stream: userController.worldLeaderBoardStream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox(
                                          height: size.height / 1.3,
                                          child: const CommanCircular());
                                    } else {
                                      var worldLeaerBoardData =
                                          snapshot.data?.data?.result;
                                      return WorldLeaderBoaderScreen(
                                        result: worldLeaerBoardData,
                                      );
                                    }
                                  }),
                              StreamBuilder<ResponseModel<LeaderBoardModel>>(
                                  stream: userController.leaderBoardStream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox(
                                          height: size.height / 1.3,
                                          child: const CommanCircular());
                                    } else {
                                      var leaerBoardData =
                                          snapshot.data?.data?.result;
                                      return CountryLeaderBoaderScreen(
                                        result: leaerBoardData,
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDropDown() {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: ConstColors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          dropdownMaxHeight: size.height * 0.2,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: ConstColors.black,
          ),
          hint: Text(
            'Select Player Type',
            style: TextStyle(
              color: ConstColors.black.withOpacity(0.5),
            ),
          ),
          value: _selectedPlayerType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedPlayerType = newValue ?? '';
            });
          },
          items: _playerTypeList.map((location) {
            return DropdownMenuItem(
              value: location,
              child: Text(
                location,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
