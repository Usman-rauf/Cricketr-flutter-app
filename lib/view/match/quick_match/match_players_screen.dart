import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/view/match/quick_match/match_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant/colors.dart';
import '../../../constant/images.dart';
import '../../../widgtes/image_view.dart';

class MatchPlayersScreen extends StatefulWidget {
  const MatchPlayersScreen(
      {super.key, required this.teamA, required this.teamB});
  final TeamInfo teamA;
  final TeamInfo teamB;

  @override
  State<MatchPlayersScreen> createState() => _MatchPlayersScreenState();
}

class _MatchPlayersScreenState extends State<MatchPlayersScreen> {
  //TeamController teamController = TeamController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppbar(size),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTeamA(size, text: "Team A"),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildTeamB(size, text: "Team B"),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  _buildContinueBtn(size),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContinueBtn(Size size) {
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VenuesScreen(
                teamA: widget.teamA,
                teamB: widget.teamB,
              ),
            ),
          );
        },
        minWidth: size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "Continue",
          style: TextStyle(
            color: ConstColors.white,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamA(Size size, {required String text}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 2,
                  width: size.width * 0.3,
                  color: ConstColors.black.withOpacity(0.1),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstColors.appGreen8FColor,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 2,
                  width: size.width * 0.3,
                  color: ConstColors.black.withOpacity(0.1),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.025,
        ),
        SizedBox(
          height: size.height * 0.25,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 2.7),
              itemCount: widget.teamA.players?.length,
              itemBuilder: (BuildContext context, int index) {
                var teamData = widget.teamA.players?[index];
                return Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: CachedNetworkImageView(
                        imageUrl: teamData?.profileImage ?? '',
                        username: teamData?.username ?? '',
                        imageSize: size.height * 0.05,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      teamData?.username.toString() ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.teamA.caption == widget.teamA.players?[index].id
                        ? playerTypeCont(text: "C")
                        : const SizedBox(),
                    widget.teamA.wicketKeeper == widget.teamA.players?[index].id
                        ? playerTypeCont(text: "W")
                        : const SizedBox()
                  ],
                );
              }),
        )
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

  Widget _buildTeamB(Size size, {required String text}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 2,
                  width: size.width * 0.3,
                  color: ConstColors.black.withOpacity(0.1),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstColors.appGreen8FColor,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 2,
                  width: size.width * 0.3,
                  color: ConstColors.black.withOpacity(0.1),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.025,
        ),
        SizedBox(
          height: size.height * 0.25,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 2.7),
              itemCount: widget.teamB.players?.length,
              itemBuilder: (BuildContext context, int index) {
                var playerData = widget.teamB.players?[index];
                return Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: CachedNetworkImageView(
                        imageUrl: playerData?.profileImage ?? '',
                        username: playerData?.username ?? '',
                        imageSize: size.height * 0.05,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      playerData?.username.toString() ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.teamB.caption == widget.teamB.players?[index].id
                        ? playerTypeCont(text: "C")
                        : const SizedBox(),
                    widget.teamB.wicketKeeper == widget.teamB.players?[index].id
                        ? playerTypeCont(text: "W")
                        : const SizedBox()
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget _buildAppbar(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ConstColors.whiteColorF9,
                    border: Border.all(
                      color: ConstColors.boardColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    ConstImages.backArrowImg,
                    color: ConstColors.black,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.05,
              ),
              Text(
                'Team A vs Team B',
                style: TextStyle(
                  color: ConstColors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                  fontSize: size.width * 0.07,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
