import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/user/get_user_info_model.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:cricketly/widgtes/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:screenshot/screenshot.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  ScreenshotController screenshotController = ScreenshotController();
  UserController userController = UserController();

  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    userController.getUserInfoSink(
        userId: preferences.getString(Keys.userID) ?? '');

    userInfo = json.decode(preferences.getString(Keys.userData) ?? '');
    super.initState();
  }

  //--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder<ResponseModel<GetUserInfoModel>>(
          stream: userController.getUserInfoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CommanCircular();
            } else {
              var userData = snapshot.data?.data?.userData;
              var strikeRate = userData?.totalBall == 0
                  ? 0
                  : (userData?.totalRun ?? 0) / (userData?.totalBall ?? 0);
              return Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Image.asset(
                    ConstImages.playerCardBackImage,
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fill,
                  ),
                  Column(
                    children: [
                      _buildImageView(size, context, userData),
                      // SvgPicture.asset('assets/images/svg/profile_cuave.svg'),
                      Container(
                        height: 2,
                        width: size.width,
                        color: ConstColors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildPlayerMain(size, strikeRate, userData),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      _buildPlayerData(size, userData),
                      // Screenshot(
                      //   controller: screenshotController,
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         color: Colors.blue,
                      //         child: Stack(
                      //           children: [
                      //             Stack(
                      //               children: [
                      //                 SizedBox(
                      //                   height: size.height / 1.8,
                      //                   width: size.width,
                      //                   child: ClipPath(
                      //                     clipper: BottomWaveClipper(),
                      //                     child: Image.network(
                      //                       'http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRiII9371KsNrl7NJMJiH1MSBljoseqOwOyce6SHU1D63HY3ay0gowModGJ4DeZ6ZlORYbDeFMI7oKkQGA',
                      //                       fit: BoxFit.cover,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             Positioned(
                      //               bottom: 0,
                      //               left: 0,
                      //               right: 0,
                      //               child: Container(
                      //                 height: MediaQuery.of(context).size.height / 2.5,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   gradient: LinearGradient(
                      //                     begin: FractionalOffset.topCenter,
                      //                     end: FractionalOffset.bottomCenter,
                      //                     colors: <Color>[
                      //                       const Color(0xff47ACF3).withOpacity(0.05),
                      //                       const Color(0xff47ACF3),
                      //                     ],
                      //                     stops: const <double>[0.3, 0.9],
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             _buildPlayerName(size, context),
                      //           ],
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Container(
                      //           color: Colors.blue,
                      //           child: Column(
                      //             children: [
                      //               Container(
                      //                 height: size.height * 0.12,
                      //                 color: Colors.black,
                      //                 padding: const EdgeInsets.symmetric(horizontal: 10),
                      //                 child: Row(
                      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     _buildPlayerInfo(
                      //                       title: 'TOTAL INNINGS',
                      //                       value:
                      //                           widget.userData?.totalInnings.toString() ??
                      //                               '',
                      //                     ),
                      //                     Padding(
                      //                       padding: const EdgeInsets.symmetric(
                      //                           vertical: 20, horizontal: 5),
                      //                       child: Container(
                      //                         color: Colors.white,
                      //                         width: 2,
                      //                       ),
                      //                     ),
                      //                     _buildPlayerInfo(
                      //                       title: 'HIGH SCORE',
                      //                       value:
                      //                           widget.userData?.totalInnings.toString() ??
                      //                               '',
                      //                     ),
                      //                     Padding(
                      //                       padding: const EdgeInsets.symmetric(
                      //                           vertical: 20, horizontal: 5),
                      //                       child: Container(
                      //                         color: Colors.white,
                      //                         width: 2,
                      //                       ),
                      //                     ),
                      //                     _buildPlayerInfo(
                      //                       title: 'Strike Rate',
                      //                       value: '$strikeRate',
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               Expanded(
                      //                 child: Column(
                      //                   children: [
                      //                     SizedBox(
                      //                       height: size.height * 0.06,
                      //                     ),
                      //                     Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Column(
                      //                           children: [
                      //                             _buildPlayerInfo(
                      //                               title: 'TOTAL RUN',
                      //                               value: widget.userData?.totalRun
                      //                                       .toString() ??
                      //                                   '',
                      //                             ),
                      //                             SizedBox(
                      //                               height: size.height * 0.03,
                      //                             ),
                      //                             _buildPlayerInfo(
                      //                               title: 'TOTAL CATCH',
                      //                               value: widget.userData?.totalRun
                      //                                       .toString() ??
                      //                                   '',
                      //                             ),
                      //                           ],
                      //                         ),
                      //                         _buildDivider(size),
                      //                         Column(
                      //                           children: [
                      //                             _buildPlayerInfo(
                      //                               title: 'TOTAL 50',
                      //                               value: widget.userData?.total50
                      //                                       .toString() ??
                      //                                   '',
                      //                             ),
                      //                             SizedBox(
                      //                               height: size.height * 0.03,
                      //                             ),
                      //                             _buildPlayerInfo(
                      //                               title: 'TOTAL WON',
                      //                               value: widget.userData?.total50
                      //                                       .toString() ??
                      //                                   '',
                      //                             ),
                      //                           ],
                      //                         ),
                      //                         _buildDivider(size),
                      //                         Column(
                      //                           children: [
                      //                             _buildPlayerInfo(
                      //                               title: 'TOTAL 100',
                      //                               value: widget.userData?.total100
                      //                                       .toString() ??
                      //                                   '',
                      //                             ),
                      //                             SizedBox(
                      //                               height: size.height * 0.03,
                      //                             ),
                      //                             _buildPlayerInfo(
                      //                               title: 'AVERAGE',
                      //                               value: widget.userData?.total100
                      //                                       .toString() ??
                      //                                   '',
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                ],
              );
            }
          }),
    );
  }

  Widget _buildPlayerMain(Size size, num strikeRate, UserData? userData) {
    return SizedBox(
      height: size.height * 0.12,
      width: size.width,
      child: Stack(
        children: [
          Image.asset(
            ConstImages.backGroundImage,
            fit: BoxFit.fill,
            width: size.width,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlayerInfo(
                      title: 'TOTAL INNINGS',
                      value: userData?.totalInnings.toString() ?? '',
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                      height: size.height * 0.1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlayerInfo(
                      title: 'HIGH SCORE',
                      value: userData?.totalInnings.toString() ?? '',
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                      height: size.height * 0.1,
                    ),
                  ],
                ),
                _buildPlayerInfo(
                  title: 'STRIKE RATE',
                  value: '$strikeRate',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageView(Size size, BuildContext context, UserData? userData) {
    return SizedBox(
      height: size.height / 1.8,
      width: size.width,
      child: Stack(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: size.height / 1.7,
                width: size.width / 1.3,
                child: ClipPath(
                  clipper: BottomWaveClipper(),
                  child: CachedNetworkImage(
                    imageUrl: userInfo['result']['profile_image'] ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      width: size.width * 0.15,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      alignment: Alignment.center,
                      width: size.height * 0.15,
                      height: size.width * 0.15,
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: Text(
                        capitalizeAllWord(userInfo['result']['username'])[0]
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.1,
                          color: ConstColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.08,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.01,
                        ),
                        child: SvgPicture.asset(
                          ConstImages.backArrowImg,
                          color: ConstColors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await screenshotController
                            .capture(delay: const Duration(milliseconds: 10))
                            .then((capturedImage) async {
                          await Share.file('esys image', 'esys.png',
                              capturedImage!, 'image/png');
                        });
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            ConstImages.shareIcon,
                            color: ConstColors.white,
                            height: size.height * 0.029,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Image.network(
                            "https://cdn.britannica.com/97/1597-004-05816F4E/Flag-India.jpg",
                            fit: BoxFit.cover,
                            width: 30,
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: <Color>[
                        const Color(0xff47ACF3).withOpacity(0.05),
                        const Color(0xff47ACF3),
                      ],
                      stops: const <double>[0.3, 0.9],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        capitalizeAllWord(userData?.username ?? ''),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      SvgPicture.asset(ConstImages.verifyIcon)
                    ],
                  ),
                  Text(
                    userData?.playerType ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 0.15,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 14, 31, 123),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        userData?.jerseyNo ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerData(Size size, UserData? userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildPlayerInfo(
              title: 'TOTAL RUN',
              value: userData?.totalRun.toString() ?? '',
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            _buildPlayerInfo(
              title: 'TOTAL CATCH',
              value: userData?.totalRun.toString() ?? '',
            ),
          ],
        ),
        _buildDivider(size),
        Column(
          children: [
            _buildPlayerInfo(
              title: 'TOTAL 50',
              value: userData?.total50.toString() ?? '',
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            _buildPlayerInfo(
              title: 'TOTAL WON',
              value: userData?.total50.toString() ?? '',
            ),
          ],
        ),
        _buildDivider(size),
        Column(
          children: [
            _buildPlayerInfo(
              title: 'TOTAL 100',
              value: userData?.total100.toString() ?? '',
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            _buildPlayerInfo(
              title: 'AVERAGE',
              value: userData?.total100.toString() ?? '',
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildPlayerName(Size size, BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //         horizontal: size.width * 0.06, vertical: size.height * 0.06),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               child: SvgPicture.asset(
  //                 ConstImages.backArrowImg,
  //                 color: ConstColors.white,
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () async {
  //                 await screenshotController
  //                     .capture(delay: const Duration(milliseconds: 10))
  //                     .then((capturedImage) async {
  //                   await Share.file(
  //                       'esys image', 'esys.png', capturedImage!, 'image/png');
  //                 }).catchError((onError) {
  //                   print(onError);
  //                 });
  //               },
  //               child: Column(
  //                 children: [
  //                   SvgPicture.asset(
  //                     ConstImages.shareIcon,
  //                     color: ConstColors.white,
  //                     height: size.height * 0.029,
  //                   ),
  //                   const SizedBox(
  //                     height: 30,
  //                   ),
  //                   Image.network(
  //                     "https://cdn.britannica.com/97/1597-004-05816F4E/Flag-India.jpg",
  //                     fit: BoxFit.cover,
  //                     width: 50,
  //                     height: 25,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: size.height * 0.24,
  //         ),
  //         Stack(
  //           children: [
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       widget.userData?.username ?? '',
  //                       style: const TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 28,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     Image.network(
  //                       "https://www.pngfind.com/pngs/m/555-5552349_this-group-belongs-to-the-verified-members-of.png",
  //                       fit: BoxFit.fill,
  //                       height: 15,
  //                       width: 15,
  //                     )
  //                   ],
  //                 ),
  //                 Text(
  //                   widget.userData?.playerType ?? '',
  //                   style: const TextStyle(color: Colors.white, fontSize: 10),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 Container(
  //                   height: 45,
  //                   width: 45,
  //                   decoration: const BoxDecoration(
  //                       color: Color.fromARGB(255, 14, 31, 123),
  //                       borderRadius: BorderRadius.all(Radius.circular(30))),
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       widget.userData?.jerseyNo ?? '',
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Container _buildDivider(Size size) {
    return Container(
      color: ConstColors.white,
      width: 2,
      height: size.height * 0.2,
    );
  }
}

Widget _buildPlayerInfo({
  required String value,
  required String title,
}) {
  return SizedBox(
    width: 110,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 10);

    var firstControlPoint =
        Offset(size.width - (size.width / 15), size.height - 30);
    var firstEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset((size.width / 3.25), size.height - 65);

    var secondEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final lowPoint = size.height - 10;
    final highPoint = size.height - 10;
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 9 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
