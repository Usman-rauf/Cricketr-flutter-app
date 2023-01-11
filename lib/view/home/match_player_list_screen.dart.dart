import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant/colors.dart';
import '../../../constant/images.dart';

class MatchPlayerList extends StatefulWidget {
  const MatchPlayerList({super.key});

  @override
  State<MatchPlayerList> createState() => _MatchPlayerListState();
}

class _MatchPlayerListState extends State<MatchPlayerList> {
  List batterList = [
    {
      "image":
          "https://m.cricbuzz.com/a/img/v1/192x192/i1/c171064/yuvraj-singh.jpg",
      "name": "Muhammad Ali",
    },
    {
      "image":
          "https://m.cricbuzz.com/a/img/v1/192x192/i1/c171064/yuvraj-singh.jpg",
      "name": "Riskameesh",
    },
    {
      "image":
          "https://m.cricbuzz.com/a/img/v1/192x192/i1/c171064/yuvraj-singh.jpg",
      "name": "Riskameesh",
    },
    {
      "image":
          "https://m.cricbuzz.com/a/img/v1/192x192/i1/c171064/yuvraj-singh.jpg",
      "name": "Riskameesh",
    },
    {
      "image":
          "https://m.cricbuzz.com/a/img/v1/192x192/i1/c171064/yuvraj-singh.jpg",
      "name": "Riskameesh",
    },
    {
      "image":
          "https://m.cricbuzz.com/a/img/v1/192x192/i1/c171064/yuvraj-singh.jpg",
      "name": "Muhammad Ali",
    },
  ];
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
                  _buildTeam(size, text: "Team A"),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildTeam(size, text: "Team B"),
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
        onPressed: () {},
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

  Widget _buildTeam(Size size, {required String text}) {
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
                color: Colors.green,
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
              itemCount: batterList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: batterList[index]["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      batterList[index]["name"],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
                'CSK1 vs CSK2',
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
