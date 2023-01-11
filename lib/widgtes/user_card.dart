import 'dart:convert';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/view/leader_board/leader_board_screen.dart';
import 'package:cricketly/view/settings/player_profile_screen.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderPlayerCard extends StatefulWidget {
  const HeaderPlayerCard({super.key});

  @override
  State<HeaderPlayerCard> createState() => _HeaderPlayerCardState();
}

class _HeaderPlayerCardState extends State<HeaderPlayerCard> {
  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    userInfo = json.decode(preferences.getString(Keys.userData) ?? '');
    super.initState();
  }

//--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 10, vertical: size.height * 0.005),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  CachedNetworkImageView(
                    imageUrl: userInfo['result']['profile_image'] ?? '',
                    username: userInfo['result']['username'],
                    imageSize: size.height * 0.07,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeAllWord(userInfo['result']['username']),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.02,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   userInfo['result']['email'],
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: size.height * 0.013,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  color: Colors.grey,
                  height: size.height * 0.09,
                  width: 1,
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaderBoardScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    ConstImages.scoreBoardIcon,
                    height: size.height * 0.025,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                SvgPicture.asset(
                  ConstImages.notificationIcon,
                  height: size.height * 0.025,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}
