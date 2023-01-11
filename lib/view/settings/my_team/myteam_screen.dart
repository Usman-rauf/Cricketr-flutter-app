import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constant/colors.dart';
import '../../../constant/images.dart';
import '../../../controller/team/team_controller.dart';
import '../../../model/response_model.dart';
import '../../../model/team/team_list_model.dart';
import '../../../widgtes/appbar.dart';
import '../../../widgtes/image_view.dart';
import '../../../widgtes/loader.dart';

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  TeamController teamController = TeamController();
  @override
  void initState() {
    teamController.getTeamList();
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
              title: 'My Teams',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            StreamBuilder<ResponseModel<TeamListModel>>(
                stream: teamController.teamListStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                        height: size.height / 1.3,
                        child: const CommanCircular());
                  } else {
                    var teamList = snapshot.data?.data?.result;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: teamList?.length,
                        itemBuilder: (context, index) {
                          // return const Text("data");
                          return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => UpdateScreen(
                              //         playerList: teamList![index].player ?? [],
                              //         teamName: teamList[index].teamName ?? "",
                              //         caption: teamList[index].caption ?? 0,
                              //         wicketKeeper:
                              //             teamList[index].wicketKeeper ?? 0,
                              //         id: teamList[index].id ?? 0),
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: ConstColors.boardColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03,
                                      vertical: size.height * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CachedNetworkImageView(
                                            imageUrl:
                                                teamList?[index].teamImage ??
                                                    '',
                                            username:
                                                teamList?[index].teamName ?? '',
                                            imageSize: size.height * 0.06,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                teamList?[index].teamName ?? "",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.height * 0.02,
                                                ),
                                              ),
                                              // Text(
                                              //   "Total Player: ${teamList![index].player!.length.toString()}",
                                              //   style: TextStyle(
                                              //     color: Colors.black,
                                              //     fontWeight: FontWeight.w500,
                                              //     fontSize: size.height * 0.02,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: SvgPicture.asset(
                                          ConstImages.forwordIcon,
                                          color: ConstColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
