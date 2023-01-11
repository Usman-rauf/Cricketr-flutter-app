import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/view/leader_board/leader_board_screen.dart';
import 'package:cricketly/widgtes/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {super.key,
      required this.imageUrl,
      required this.email,
      required this.userName});

  String imageUrl;
  String email;
  String userName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isButtonActive = false;
  TextEditingController msgController = TextEditingController();
  List msgList = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
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
                  const SizedBox(
                    width: 15,
                  ),
                  _buildUserImageView(size),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(fontSize: 13),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.4,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 227, 227, 227),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Center(
                    child: Text("December 16, 2022"),
                  ),
                ),
              ),
              buildListMessage(size),
              buildInput(size),
              const SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput(Size size) {
    return Container(
      height: 45,
      width: size.width,
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color.fromARGB(255, 227, 227, 227),
        // border: Border.all(
        //   color: ConstColors.appGreen8FColor,
        // ),
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: msgController,
              onChanged: (value) {
                // setState(() {
                //   if (msgController.text == value) {
                //     isButtonActive = false;
                //   } else {
                //     isButtonActive = true;
                //   }
                // });
              },
              onSubmitted: (value) {},
              style: const TextStyle(fontSize: 15),
              cursorColor: Colors.green,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                contentPadding: EdgeInsets.only(left: 3),
                fillColor: Color.fromARGB(255, 227, 227, 227),
              ),
            ),
          ),
          Container(
            height: 45,
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Color.fromARGB(255, 227, 227, 227),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (msgController.text.isNotEmpty) {
                    msgList.add(msgController.text);
                    log(msgList.toString());
                    msgController.clear();
                  }
                });
              },
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Send",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  // Widget buildListMessage(Size size) {
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: msgList.length,
  //       shrinkWrap: true,
  //       itemBuilder: (context, index) {
  //         // if (msgList[index] == 1) {
  //         //   return _buildSenderListItem();
  //         // } else {
  //         //   return _buidReciverListItem(size);
  //         // }

  //         return _buildSenderListItem();
  //       },
  //     ),
  //   );
  // }
  // Widget buildListMessage(Size size) {
  //   return Expanded(
  //     child: _buildSenderListItem(size),
  //   );
  // }

  Widget buildListMessage(Size size) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: ListView.builder(
          itemCount: msgList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "10:20",
                    style:
                        TextStyle(fontSize: 10, color: ConstColors.grayColor95),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),

                    //width: 200,
                    decoration: const BoxDecoration(
                        color: ConstColors.appGreen8FColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      msgList[index].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //_buildUserImageView(size),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "10:20",
                          style: TextStyle(
                              fontSize: 10, color: ConstColors.grayColor95),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 227, 227, 227),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            msgList[index].toString(),
                            style: const TextStyle(color: ConstColors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buidReciverListItem(Size size) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
            itemCount: msgList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserImageView(size),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Edad,22/08 10:20",
                        style: TextStyle(
                            fontSize: 10, color: ConstColors.grayColor95),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 227, 227, 227),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          msgList[index].toString(),
                          style: const TextStyle(color: ConstColors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget _buildUserImageView(Size size) {
    return Container(
      height: 33,
      width: 33,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.red,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CachedNetworkImage(
            imageUrl:
                'https://pickaface.net/gallery/avatar/76473249_170606_0108_2q6380z.png',
            imageBuilder: (context, imageProvider) => Container(
              width: size.height * 0.035,
              height: size.height * 0.035,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: size.height * 0.02,
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
                      fontSize: size.height * 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
}
