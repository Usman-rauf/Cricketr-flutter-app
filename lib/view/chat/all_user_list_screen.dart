import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/view/chat/chat_screen.dart';
import 'package:cricketly/view/leader_board/leader_board_screen.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:cricketly/widgtes/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/colors.dart';

class AllUserListScreen extends StatefulWidget {
  const AllUserListScreen({super.key});

  @override
  State<AllUserListScreen> createState() => _AllUserListScreenState();
}

class _AllUserListScreenState extends State<AllUserListScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              const HeaderPlayerCard(),
              SizedBox(
                height: size.height * 0.02,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSerchBar(size),
                      SizedBox(
                        height: size.height * 0.002,
                      ),
                      _battingPlayerList(size),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSerchBar(Size size) {
    return SizedBox(
      height: size.height * 0.05,
      child: TextField(
        onTap: () {},
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          prefixIcon: const Icon(
            Icons.search,
          ),
          hintText: 'Search',
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _battingPlayerList(Size size) {
    return ListView.builder(
      itemCount: 20,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            //horizontal: size.width * 0.02,
            vertical: size.height * 0.007,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    imageUrl:
                        "https://pickaface.net/gallery/avatar/76473249_170606_0108_2q6380z.png",
                    userName: "Yousuf122983",
                    email: "janak@gmail.com",
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CachedNetworkImageView(
                                imageUrl:
                                    'https://pickaface.net/gallery/avatar/76473249_170606_0108_2q6380z.png',
                                username: 'Test',
                                imageSize: size.height * 0.075,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yousuf122983',
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'very nice bro',
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: ConstColors.grayColor95),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(
                                //       horizontal: size.width * 0.04),
                                //   child: Text(
                                //     'now',
                                //     style: TextStyle(
                                //         fontSize: size.height * 0.018,
                                //         color: ConstColors.grayColor95),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SvgPicture.asset(ConstImages.camreaIcon),
                    Text(
                      'now',
                      style: TextStyle(
                          fontSize: size.height * 0.018,
                          color: ConstColors.grayColor95),
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

  Widget _buildHeaderContainer(Size size) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 10, vertical: size.height * 0.0002),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const PlayerProfileScreen(),
                //   ),
                // );
              },
              child: Row(
                children: [
                  CachedNetworkImageView(
                    imageUrl: '',
                    username: 'Test',
                    imageSize: size.height * 0.05,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.02,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'test@gmail.com',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: size.height * 0.013,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  color: Colors.grey[300],
                  height: size.height * 0.08,
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
                Stack(
                  children: [
                    SvgPicture.asset(
                      ConstImages.notificationIcon,
                      height: size.height * 0.025,
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 5,
                          minHeight: 5,
                        ),
                      ),
                    )
                  ],
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

  Widget _buildUserImageView(Size size) {
    return CachedNetworkImage(
      imageUrl: '',
      imageBuilder: (context, imageProvider) => Container(
        width: size.height * 0.035,
        height: size.height * 0.035,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: size.height * 0.028,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ConstColors.appGreen8FColor,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Center(
            child: Text(
              'Test'[0].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
