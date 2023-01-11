import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/model/match/matchlist_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/view/home/history_screen/history_match_list.dart';
import 'package:cricketly/view/home/live_match/live_match_list.dart';
import 'package:cricketly/view/home/upcoming_match/upcoming_match_list.dart';
import 'package:cricketly/view/home/create_team/new_team_create_screen.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgtes/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  MatchController matchController = MatchController();
  UserController userController = UserController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//

  @override
  void initState() {
    matchController.matchListSink();
    _logAppOpen();
    super.initState();
  }

  void _logAppOpen() async {
    await FirebaseAnalytics.instance.logAppOpen();
  }

//--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: _buildAddButton(context, size),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                const HeaderPlayerCard(),
                SizedBox(
                  height: size.height * 0.03,
                ),
                _buildMatchView(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Matches',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.03,
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              _buildTabView(size),
              StreamBuilder<ResponseModel<MatchListModel>>(
                stream: matchController.getMatchListStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: size.height / 2,
                      child: const CommanCircular(),
                    );
                  } else {
                    var getMatchList = snapshot.data?.data?.matchResult;
                    return SizedBox(
                      height: size.height / 1.8,
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: LiveMatchListScreen(
                              liveMatchList: getMatchList?.live ?? [],
                            ),
                          ),
                          SingleChildScrollView(
                            child: UpcomingListScreen(
                              upcomingMatchList: getMatchList?.upcomming ?? [],
                            ),
                          ),
                          SingleChildScrollView(
                            child: HistoryMatchList(
                              previousMatchList: getMatchList?.previous ?? [],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //------------------------------------------------------------------ Helper  Widget -----------------------------------------------------------------//

  Widget _buildTabView(Size size) {
    return Material(
      elevation: 7,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        constraints: BoxConstraints.expand(height: size.height * 0.09),
        child: TabBar(
          indicatorColor: ConstColors.appGreen8FColor,
          indicatorWeight: 5,
          labelColor: ConstColors.black,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              text: "Live",
              icon: SvgPicture.asset(ConstImages.liveIcon),
            ),
            Tab(
              text: "Upcoming",
              icon: SvgPicture.asset(ConstImages.upcommingIcon),
            ),
            Tab(
              text: "Previous",
              icon: SvgPicture.asset(ConstImages.historyIcon),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------- Buttons ---------------------------------------------------------------------//
  Widget _buildAddButton(BuildContext context, Size size) {
    return InkWell(
      onTap: () async {
        await FirebaseAnalytics.instance.logEvent(
          name: 'create New Team',
          parameters: {
            'test': '1',
          },
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NewTeamCreateScreen(),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: ConstColors.red,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(
            Icons.add,
            color: ConstColors.white,
            size: size.height * 0.04,
          ),
        ),
      ),
    );
  }
}
