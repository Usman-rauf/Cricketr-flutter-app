// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cricketly/constant/colors.dart';
// import 'package:cricketly/constant/images.dart';
// import 'package:cricketly/model/match/match_list_model.dart';
// import 'package:cricketly/model/response_model.dart';
// import 'package:cricketly/model/team/live_match_model.dart';
// import 'package:cricketly/provider/team_controller/list_match_provider.dart';
// import 'package:cricketly/provider/update_score/update_score_controller.dart';
// import 'package:cricketly/view/live_match/learder_board_screen.dart';
// import 'package:cricketly/widgtes/lists.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';



// class LiveMatchScreen extends StatefulWidget {
//   final TeamList teamList;
//   const LiveMatchScreen({Key? key, required this.teamList}) : super(key: key);

//   @override
//   State<LiveMatchScreen> createState() => _LiveMatchScreenState();
// }

// class _LiveMatchScreenState extends State<LiveMatchScreen> {
//   int selectBatsman = 0;
//   int selectPlayer = 0;
//   MatchController matchController = MatchController();
//   UpdateScoreBloc updateScoreBloc = UpdateScoreBloc();
//   bool isSelectedBatsmen = false;
//   dynamic teamBattingPlayer;
//   bool player1onStrike = true;
//   List<TeamBattingPlayer> teamBattingPlayerss = [];
//   @override
//   void initState() {
//     updateScoreBloc.getMatchDetailController(
//         matchId: widget.teamList.sId ?? '');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HomeScreen(),
//           ),
//         );
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: ConstColors.black,
//         appBar: _buildAppBar(context),
//         body: StreamBuilder<ResponseModel<LiveMatchDataModel>>(
//           stream: updateScoreBloc.updateScoreDataStream,
//           builder: (context, snapshot) {
//             if (snapshot.data?.data?.matchData == null) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               print(widget.teamList.sId);

//               var matchData = snapshot.data?.data?.matchData;

//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     children: [
//                       _buildHeaderView(size, matchData),
//                       SizedBox(
//                         height: size.height * 0.02,
//                       ),
//                       Container(
//                         width: size.width,
//                         decoration: const BoxDecoration(
//                           color: ConstColors.ofwhite,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 15),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildBatsmanView(size, matchData),
//                               SizedBox(
//                                 height: size.height * 0.02,
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: const [
//                                       Text(
//                                         'Bowler',
//                                         style: TextStyle(
//                                           color: ConstColors.white,
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Over',
//                                         style: TextStyle(
//                                           color: ConstColors.white,
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: size.height * 0.01,
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     child: _buildBatterName(
//                                       image: matchData?.teamBolwerPlayer?[0]
//                                               .playerId?.avatar ??
//                                           '',
//                                       name: matchData?.teamBolwerPlayer?[0]
//                                               .playerId?.username ??
//                                           '',
//                                       run: matchData?.teamBolwerPlayer?[0].ball
//                                               .toString() ??
//                                           '',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: size.height * 0.02,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Over ${matchData?.totalRun?[0].over.toString() ?? ''}(0.${matchData?.totalRun?[0].ball.toString() ?? ''})'
//                                         .toUpperCase(),
//                                     style: const TextStyle(
//                                       color: ConstColors.white,
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   // SizedBox(
//                                   //   height: size.height * 0.03,
//                                   //   child: ListView.builder(
//                                   //     itemCount: 6,
//                                   //     shrinkWrap: true,
//                                   //     physics:
//                                   //         const NeverScrollableScrollPhysics(),
//                                   //     scrollDirection: Axis.horizontal,
//                                   //     itemBuilder: (context, index) {
//                                   //       return Padding(
//                                   //         padding: const EdgeInsets.symmetric(
//                                   //             horizontal: 2),
//                                   //         child: CircleAvatar(
//                                   //           maxRadius: 12,
//                                   //           backgroundColor: index == 4
//                                   //               ? ConstColors.red
//                                   //               : ConstColors.black,
//                                   //           child: Text(
//                                   //             index == 4
//                                   //                 ? 'W'
//                                   //                 : index.toString(),
//                                   //             style: const TextStyle(
//                                   //               color: ConstColors.white,
//                                   //               fontWeight: FontWeight.w600,
//                                   //               fontSize: 14,
//                                   //             ),
//                                   //           ),
//                                   //         ),
//                                   //       );
//                                   //     },
//                                   //   ),
//                                   // ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: size.height * 0.02,
//                       ),
//                       GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           childAspectRatio: 1.3,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                           crossAxisCount: 3,
//                         ),
//                         itemCount: ConstList().scoreList.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () async {
//                               if (index == 0 || index == 3) {
//                                 setState(() {
//                                   player1onStrike = true;
//                                 });
//                               } else if (index == 4 || index == 5) {
//                                 if (player1onStrike) {
//                                   setState(() {
//                                     player1onStrike = true;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     player1onStrike = false;
//                                   });
//                                 }
//                               } else if (index == 1 || index == 2) {
//                                 setState(() {
//                                   player1onStrike = false;
//                                 });
//                               }

//                               print(teamBattingPlayerss);
//                               await _buildRunTap(index, matchData, size);
//                             },
//                             child: CircleAvatar(
//                               radius: size.height * 0.05,
//                               backgroundColor: ConstColors.ofwhite,
//                               child: Text(
//                                 ConstList().scoreList[index]['run'],
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: ConstColors.white,
//                                   fontWeight: FontWeight.w500,
//                                   letterSpacing: 0.5,
//                                   fontSize: size.height * 0.02,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> _buildRunTap(int index, MatchData? matchData, Size size) async {
//     if (index < 6) {
//       var runData = int.parse(
//           ConstList().scoreList[index]['run'].toString().split(' ')[0]);
//       final respose = await updateScoreBloc.updateScoreSink(
//         matchId: widget.teamList.sId ?? '',
//         battingTeamId: matchData?.teamBattingPlayer?[0].teamId?.sId ?? '',
//         bowlerTeamId: matchData?.teamBolwerPlayer?[0].teamId?.sId ?? '',
//         battingPlayerId1: matchData?.teamBattingPlayer?[1].playerId?.sId ?? '',
//         bowlerPlayerId: matchData?.teamBolwerPlayer?[0].playerId?.sId ?? '',
//         run: runData,
//       );
//       if (respose.data?.statusCode == 200) {
//         await updateScoreBloc.getMatchDetailController(
//             matchId: widget.teamList.sId ?? '');
//       }
//     } else if (index == 6 || index == 7 || index == 8) {
//       final respose = await updateScoreBloc.updateScoreSink(
//         matchId: widget.teamList.sId ?? '',
//         battingTeamId: matchData?.teamBattingPlayer?[0].teamId?.sId ?? '',
//         bowlerTeamId: matchData?.teamBolwerPlayer?[0].teamId?.sId ?? '',
//         battingPlayerId1: teamBattingPlayer.playerId?.sId ?? '',
//         bowlerPlayerId: matchData?.teamBolwerPlayer?[0].playerId?.sId ?? '',
//         out: true,
//         outBatsmanId: teamBattingPlayer.playerId?.sId ?? '',
//       );
//       if (respose.data?.statusCode == 200) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return Container(
//               child: const Text('data'),
//             );

//             // AlertDialog(
//             //   title: Text(
//             //     'Select Batsman',
//             //     style: TextStyle(fontSize: size.width * 0.04),
//             //   ),
//             //   shape: RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.circular(15),
//             //   ),
//             //   content: SizedBox(
//             //     height: size.height / 2,
//             //     width: size.width,
//             //     child: ListView.builder(
//             //       itemCount: matchData?.teamA?.player?.length,
//             //       shrinkWrap: true,
//             //       physics: const NeverScrollableScrollPhysics(),
//             //       itemBuilder: (context, index) {
//             //         var batsmanValue = matchData?.teamA?.player?[index];
//             //         return GestureDetector(
//             //           onTap: () {
//             //             setState(() {
//             //               selectPlayer = index;
//             //             });
//             //           },
//             //           child: GestureDetector(
//             //             child: SizedBox(
//             //               width: size.width,
//             //               child: Padding(
//             //                 padding: const EdgeInsets.all(5),
//             //                 child: Container(
//             //                   decoration: BoxDecoration(
//             //                     borderRadius: BorderRadius.circular(15),
//             //                     color: ConstColors.black.withOpacity(0.2),
//             //                   ),
//             //                   padding: const EdgeInsets.all(10),
//             //                   child: Row(
//             //                     mainAxisAlignment:
//             //                         MainAxisAlignment.spaceBetween,
//             //                     children: [
//             //                       Text(batsmanValue?.username ?? ''),
//             //                       // _buildPlayerInfo(
//             //                       //     image: batsmanValue?.avatar ?? '',
//             //                       //     playerName:
//             //                       //         batsmanValue?.username ?? '',
//             //                       //     size: size),
//             //                       selectPlayer == index
//             //                           ? Container(
//             //                               decoration: const BoxDecoration(
//             //                                 shape: BoxShape.circle,
//             //                                 color: ConstColors.black,
//             //                               ),
//             //                               child: Padding(
//             //                                 padding: const EdgeInsets.all(8.0),
//             //                                 child: SvgPicture.asset(
//             //                                   ConstImages.rightArrowImg,
//             //                                   color: ConstColors.white,
//             //                                 ),
//             //                               ),
//             //                             )
//             //                           : const SizedBox()
//             //                     ],
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //           ),
//             //         );
//             //       },
//             //     ),
//             //   ),
//             //   actions: [
//             //     Padding(
//             //       padding: const EdgeInsets.all(8.0),
//             //       child: MaterialButton(
//             //         minWidth: size.width,
//             //         padding: const EdgeInsets.all(15),
//             //         onPressed: () async {
//             //           // await updateScoreBloc.updateBatsmanController(
//             //           //   matchId: widget.teamList.sId ?? '',
//             //           //   battingTeamId:
//             //           //       matchData?.teamBattingPlayer?[0].teamId?.sId ??
//             //           //           '',
//             //           //   bowlerTeamId:
//             //           //       matchData?.teamBolwerPlayer?[0].teamId?.sId ??
//             //           //           '',
//             //           //   battingPlayerId1: respose.data?.matchData?.teamA
//             //           //           ?.player?[selectPlayer].sId ??
//             //           //       '',
//             //           //   bowlerPlayerId:
//             //           //       matchData?.teamBolwerPlayer?[0].playerId?.sId ??
//             //           //           '',
//             //           // )
//             //           Navigator.of(context).pop();
//             //           Navigator.of(context).pop();
//             //         },
//             //         color: ConstColors.black,
//             //         child: const Text(
//             //           'OK',
//             //           style: TextStyle(
//             //             fontWeight: FontWeight.w500,
//             //             color: ConstColors.white,
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // );
//           },
//         );
//         await updateScoreBloc.getMatchDetailController(
//             matchId: widget.teamList.sId ?? '');
//       } else {}
//     } else {}
//   }

//   Widget _buildHeaderView(Size size, MatchData? matchData) {
//     return Container(
//       width: size.width,
//       decoration: const BoxDecoration(
//         color: ConstColors.ofwhite,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Padding(
//         padding:
//             EdgeInsets.symmetric(horizontal: 10, vertical: size.height * 0.02),
//         child: Column(
//           children: [
//             _buildTeamRunView(
//               teamName: matchData?.totalRun?[0].teamId?.name ?? '',
//               totalOver:
//                   '${matchData?.totalRun?[0].over.toString() ?? ''}(0.${matchData?.totalRun?[0].ball.toString() ?? ''})',
//               totalRun:
//                   "${matchData?.totalRun?[0].run.toString() ?? ''} - ${matchData?.totalRun?[0].wicket.toString() ?? ''} ",
//             ),
//             SizedBox(
//               height: size.height * 0.01,
//             ),
//             _buildTeamRunView(
//               teamName: matchData?.teamB?.name ?? '',
//               totalOver:
//                   // '${matchData?.totalRun?[1].over.toString() ?? ''}(0.${matchData?.totalRun?[1].ball.toString() ?? ''})',
//                   '',
//               totalRun:
//                   // matchData?.totalRun?[1].run.toString() ??
//                   '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTeamRunView({
//     required String teamName,
//     required String totalRun,
//     required String totalOver,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           teamName,
//           style: const TextStyle(
//             color: ConstColors.white,
//             fontWeight: FontWeight.w500,
//             fontSize: 18,
//           ),
//         ),
//         Row(
//           children: [
//             Text(
//               totalRun,
//               style: const TextStyle(
//                 color: ConstColors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Text(
//               totalOver,
//               style: const TextStyle(
//                 color: ConstColors.white,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 18,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Column _buildBatsmanView(Size size, MatchData? matchData) {
//     for (int i = 0; i < matchData!.teamBattingPlayer!.length; i++) {
//       if (matchData.teamBattingPlayer![i].out == false) {
//         if (player1onStrike) {
//           teamBattingPlayerss.insert(0, matchData.teamBattingPlayer![i]);
//         } else {
//           teamBattingPlayerss.insert(1, matchData.teamBattingPlayer![i]);
//         }
//       }
//     }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text(
//               'Batter',
//               style: TextStyle(
//                 color: ConstColors.white,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               'Run',
//               style: TextStyle(
//                 color: ConstColors.white,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: size.height * 0.01,
//         ),
//         SizedBox(
//           height: size.height * 0.1,
//           child: ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: teamBattingPlayerss.length,
//             itemBuilder: (context, index) {
//               var battingPlayerList = teamBattingPlayerss[index];

//               if (battingPlayerList.out == false) {
//                 //   battingPlayerList?.isSelectedBatsmen =
//                 //       matchData?.teamBattingPlayer?.first.isSelectedBatsmen == false
//                 //           ? true
//                 //           : false;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           // Container(
//                           //   height: 20,
//                           //   decoration: const BoxDecoration(
//                           //     shape: BoxShape.circle,
//                           //     color: ConstColors.ofwhite,
//                           //   ),
//                           //   clipBehavior: Clip.hardEdge,
//                           //   child: CachedNetworkImage(
//                           //     fit: BoxFit.fill,
//                           //     imageUrl:
//                           //         battingPlayerList?.playerId?.avatar ?? '',
//                           //   ),
//                           // ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             battingPlayerList.playerId?.username ?? '',
//                             style: const TextStyle(
//                               color: ConstColors.white,
//                               fontWeight: FontWeight.w400,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           index == 0 && player1onStrike
//                               ? const Icon(
//                                   Icons.star,
//                                   color: Colors.white,
//                                   size: 15,
//                                 )
//                               : index == 1 && !player1onStrike
//                                   ? const Icon(
//                                       Icons.star,
//                                       color: Colors.white,
//                                       size: 15,
//                                     )
//                                   : const SizedBox()
//                         ],
//                       ),
//                       Text(
//                         '${battingPlayerList.run} (${battingPlayerList.ballfaced})',
//                         style: const TextStyle(
//                           color: ConstColors.white,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 return const SizedBox(
//                   height: 1,
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget _buildRunView(Size size , matchData) {
//   //   return ;
//   // }

//   // Widget _buildPlayerInfo({
//   //   required Size size,
//   //   required String image,
//   //   required String playerName,
//   // }) {
//   //   return Row(
//   //     children: [
//   //       NetworkImageView(
//   //         imageSize: size.height * 0.03,
//   //         imageUrl: image,
//   //       ),
//   //       SizedBox(width: size.width * 0.03),
//   //       Text(
//   //         playerName,
//   //       ),
//   //     ],
//   //   );
//   // }

//   //-------------------------------------------------------------- Helper Functions --------------------------------------------------------------//

//   // Widget _buildScoreCard(Size size, MatchData? matchData) {
//   //   return Container(
//   //     width: size.width,
//   //     decoration: const BoxDecoration(
//   //       color: ConstColors.ofwhite,
//   //       borderRadius: BorderRadius.all(
//   //         Radius.circular(10),
//   //       ),
//   //     ),
//   //     child: Padding(
//   //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           _buildBatterView(size),
//   //           SizedBox(
//   //             height: size.height * 0.03,
//   //           ),
//   //           _buildBowlerView(size),
//   //           SizedBox(
//   //             height: size.height * 0.02,
//   //           ),
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: [
//   //               Text(
//   //                 'Over 15'.toUpperCase(),
//   //                 style: const TextStyle(
//   //                   color: ConstColors.white,
//   //                   fontWeight: FontWeight.w400,
//   //                   fontSize: 16,
//   //                 ),
//   //               ),
//   //               SizedBox(
//   //                 height: size.height * 0.03,
//   //                 child: ListView.builder(
//   //                   itemCount: 6,
//   //                   shrinkWrap: true,
//   //                   physics: const NeverScrollableScrollPhysics(),
//   //                   scrollDirection: Axis.horizontal,
//   //                   itemBuilder: (context, index) {
//   //                     return Padding(
//   //                       padding: const EdgeInsets.symmetric(horizontal: 2),
//   //                       child: CircleAvatar(
//   //                         maxRadius: 12,
//   //                         backgroundColor:
//   //                             index == 4 ? ConstColors.red : ConstColors.black,
//   //                         child: Text(
//   //                           index == 4 ? 'W' : index.toString(),
//   //                           style: const TextStyle(
//   //                             color: ConstColors.white,
//   //                             fontWeight: FontWeight.w600,
//   //                             fontSize: 14,
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     );
//   //                   },
//   //                 ),
//   //               ),
//   //             ],
//   //           )
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildBowlerView(Size size) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text(
//               'Bowler',
//               style: TextStyle(
//                 color: ConstColors.white,
//                 // letterSpacing: 0.7,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               'Over',
//               style: TextStyle(
//                 color: ConstColors.white,
//                 // letterSpacing: 0.7,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: size.height * 0.01,
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: 1,
//           itemBuilder: (context, index) {
//             var battingPlayerList = widget.teamList.teamB?.player?[index];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: _buildBatterName(
//                 image: battingPlayerList?.avatar ?? '',
//                 name: battingPlayerList?.username ?? '',
//                 run: '70',
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildBatterName({
//     required String name,
//     required String image,
//     required String run,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               height: 20,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: ConstColors.ofwhite,
//               ),
//               clipBehavior: Clip.hardEdge,
//               child: CachedNetworkImage(
//                 fit: BoxFit.fill,
//                 imageUrl: image,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Text(
//               name,
//               style: const TextStyle(
//                 color: ConstColors.white,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         Text(
//           run,
//           style: const TextStyle(
//             color: ConstColors.white,
//             fontWeight: FontWeight.w400,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }

//   // Appbar

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: ConstColors.black,
//       elevation: 0.0,
//       centerTitle: true,
//       leading: IconButton(
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const HomeScreen(),
//             ),
//           );
//         },
//         icon: const Icon(
//           Icons.arrow_back,
//         ),
//       ),
//       title: Text(
//         'Live match'.toUpperCase(),
//         style: const TextStyle(
//           color: ConstColors.white,
//           fontWeight: FontWeight.w800,
//           fontSize: 15,
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return LeardBoardScreen(
//                       teamList: widget.teamList,
//                     );
//                   },
//                 ),
//               );
//             },
//             child: SvgPicture.asset(
//               ConstImages.scoreBoardImage,
//               color: ConstColors.white,
//               height: 25,
//               width: 15,
//             ),
//           ),
//         ),
//         // IconButton(onPressed: () {}, icon: Icon(Icons.scr))
//       ],
//     );
//   }
// }
