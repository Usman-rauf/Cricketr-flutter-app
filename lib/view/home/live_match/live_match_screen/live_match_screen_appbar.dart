import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/view/home/scoreboard/score_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LiveMatchScreenAppBar extends StatelessWidget {
  final String matchId;
  const LiveMatchScreenAppBar({
    super.key,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          top: size.height * 0.05,
          left: size.width * 0.03,
          right: size.width * 0.05,
          bottom: size.height * 0.02),
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
                  color: const Color(0xffF64b60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: SvgPicture.asset(
                      ConstImages.backArrowImg,
                      color: ConstColors.white,
                    ),
                  ),
                ),
              ),
              Text(
                "Live Match",
                style: TextStyle(
                  color: ConstColors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: size.width * 0.07,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => ScoreBoardWithTabScreen(
                        matchId: matchId,
                        isLive: false,
                      )),
                ),
              );
            },
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "view all",
                    style: TextStyle(
                      color: ConstColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: ConstColors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
