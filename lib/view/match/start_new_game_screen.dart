import 'dart:async';

import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/controller/team/team_controller.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/check_duplicate_team_model.dart';
import 'package:cricketly/model/team/team_list_model.dart';
import 'package:cricketly/view/home/create_team/new_team_create_screen.dart';
import 'package:cricketly/view/match/match_start/toss_screen.dart';
import 'package:cricketly/view/match/quick_match/select_player_screen.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:cricketly/widgtes/user_card.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class StartNewGameScreen extends StatefulWidget {
  const StartNewGameScreen({super.key});

  @override
  State<StartNewGameScreen> createState() => _StartNewGameScreenState();
}

class _StartNewGameScreenState extends State<StartNewGameScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  TextEditingController venuController = TextEditingController();
  final TextEditingController _overController = TextEditingController();
  TeamController teamController = TeamController();
  MatchController matchController = MatchController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  TeamInfo? _selectTeamA;
  TeamInfo? _selectTeamB;
  LatLng? currentPostion;
  List<CheckTeamData> teamsList = [];
  String selectedDate = '';
  String selectedTime = '';
  bool isOpen = false;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LocationPermission? permission;

  _selectDate() async {
    DateTime now = DateTime.now();
    var picked = await showDatePicker(
      context: context,
      initialDate: now,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: now,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ConstColors.appGreen8FColor,
            ),
            textButtonTheme: const TextButtonThemeData(),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      selectedDate = DateFormat("yyyy-MM-dd").format(picked!);
    });
  }

  Future<void> _selectTime() async {
    var pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ConstColors.appGreen8FColor,
            ),
            textButtonTheme: const TextButtonThemeData(),
          ),
          child: child!,
        );
      },
    );

    DateTime parsedTime =
        DateFormat.jm().parse(pickedTime?.format(context).toString() ?? '');

    String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

    setState(() {
      selectedTime = formattedTime;
    });
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    teamController.getTeamList();
    _getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Center(
                    child: Text(
                      "Start New Game",
                      style: TextStyle(
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w600,
                        fontSize: size.height * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
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
                          return Column(
                            children: [
                              const HeaderPlayerCard(),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildQuickButton(size),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildDivider(size, 'Teams'),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              _buildSelectedTeamA(teamList, size),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildSelectedTeamB(teamList, size),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildDivider(size, 'Venue'),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              _buildVenuField(size),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        await _selectDate();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                              color: ConstColors.boardColor),
                                          color: ConstColors.whiteColorF9,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Text(
                                            selectedDate != ''
                                                ? selectedDate.toString()
                                                : 'Select Date',
                                            style: TextStyle(
                                              color: selectedDate != ''
                                                  ? ConstColors.black
                                                  : ConstColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        await _selectTime();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ConstColors.boardColor),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: ConstColors.whiteColorF9,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Text(
                                            selectedTime != ''
                                                ? selectedTime.toString()
                                                : 'Select time',
                                            style: TextStyle(
                                              color: selectedTime != ''
                                                  ? ConstColors.black
                                                  : ConstColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              _buildSelectOver(size),
                              SizedBox(height: size.height * 0.01),
                              _buildLetsStartButton(size, context),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildQuickButton(Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectPlayersScreen(),
          ),
        );
      },
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: ConstColors.appGreen8FColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ConstColors.boardColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Match',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ConstColors.white,
                ),
              ),
              Image.asset(ConstImages.quickMatchICon)
            ],
          ),
        ),
      ),
    );
  }

  //Select Team A
  Widget _buildSelectedTeamA(List<TeamInfo>? teamList, Size size) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ConstColors.whiteColorF9,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: DropdownButtonHideUnderline(
              child: GestureDetector(
                onTap: () {
                  if (teamList?.isEmpty ?? true) {
                    showTostMessage(message: "Please create a team first.");
                  }
                },
                child: DropdownButton2<TeamInfo>(
                  isExpanded: true,
                  dropdownMaxHeight: size.height * 0.2,
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: ConstColors.grayColor95,
                    ),
                  ),
                  hint: Text(
                    'Select team A',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ConstColors.black.withOpacity(0.5),
                    ),
                  ),
                  value: _selectTeamA,
                  onChanged: (TeamInfo? newValue) async {
                    // showLoader(context);
                    setState(() {
                      _selectTeamA = newValue;
                    });
                    print(_selectTeamA);
                    // var response =
                    //     await teamController.checkDuplicateTeamContoller(
                    //         team1: _selectTeamA?.id.toString() ?? '');
                    // setState(() {
                    //   teamsList.addAll(response.data!.checkTeamsData!);
                    // });
                  },
                  items: teamList?.map((teamListData) {
                    return DropdownMenuItem(
                      value: teamListData,
                      enabled: teamListData != _selectTeamB,
                      child: Text(
                        teamListData.teamName.toString(),
                        style: TextStyle(
                          color: teamListData != _selectTeamB
                              ? ConstColors.black
                              : ConstColors.grayF4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewTeamCreateScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            color: ConstColors.appGreen8FColor,
          ),
        )
      ],
    );
  }

  //Select Team B
  Widget _buildSelectedTeamB(List<TeamInfo>? teamList, Size size) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ConstColors.whiteColorF9,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: DropdownButtonHideUnderline(
                child: GestureDetector(
              onTap: () {
                if (teamList?.isEmpty ?? true) {
                  showTostMessage(message: "Please create a team first.");
                }
              },
              child: DropdownButton2<TeamInfo>(
                isExpanded: true,
                dropdownMaxHeight: size.height * 0.2,
                icon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ConstColors.grayColor95,
                  ),
                ),
                hint: Text(
                  'Select team B',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ConstColors.black.withOpacity(0.5),
                  ),
                ),
                value: _selectTeamB,
                onChanged: (newValue) {
                  setState(() {
                    _selectTeamB = newValue;
                  });
                },
                items: teamList?.map((teamListData) {
                  return DropdownMenuItem(
                    value: teamListData,
                    // enabled: teamListData.isDuplicated == true ? false : true,
                    child: Row(
                      children: [
                        Text(
                          teamListData.teamName.toString(),
                          style: TextStyle(
                            color: teamListData != _selectTeamA
                                ? ConstColors.black
                                : ConstColors.grayF4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        // CircleAvatar(
                        //   maxRadius: 3,
                        //   backgroundColor: teamListData.isDuplicated == true
                        //       ? ConstColors.red
                        //       : ConstColors.appGreen8FColor,
                        // )
                      ],
                    ),
                  );
                }).toList(),
              ),
            )),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewTeamCreateScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            color: ConstColors.appGreen8FColor,
          ),
        )
      ],
    );
  }

  Widget _buildVenuField(Size size) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black,
      ),
      controller: venuController,
      cursorColor: ConstColors.black,
      keyboardType: TextInputType.name,
      maxLines: 3,
      // onTap: () async {
      //   permission = await Geolocator.checkPermission();
      //   if (permission == LocationPermission.denied) {
      //     permission = await Geolocator.requestPermission();
      //     if (permission == LocationPermission.denied) {
      //       // Permissions are denied, next time you could try
      //       // requesting permissions again (this is also where
      //       // Android's shouldShowRequestPermissionRationale
      //       // returned true. According to Android guidelines
      //       // your App should show an explanatory UI now.
      //       return Future.error('Location permissions are denied');
      //     }
      //   }
      //   _getUserLocation();
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Column(
      //           children: [
      //             SearchMapPlaceWidget(
      //               apiKey: 'AIzaSyDxP5I2RnMzVHrPK2oTLJEzj3X1XubCYOI',

      //               // The language of the autocompletion
      //               language: 'en',
      //               location: currentPostion,
      //               radius: 30000,
      //               onSelected: (Place place) async {
      //                 final geolocation = await place.geolocation;

      //                 final GoogleMapController controller =
      //                     await _controller.future;
      //                 controller.animateCamera(
      //                     CameraUpdate.newLatLng(geolocation?.coordinates));
      //                 controller.animateCamera(
      //                     CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
      //               },
      //             )
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // },
      // readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a venue';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Enter venue',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: ConstColors.black.withOpacity(0.5),
        ),
        filled: true,
        fillColor: ConstColors.whiteColorF9,
      ),
    );
  }

  Widget _buildSelectOver(Size size) {
    return Column(
      children: [
        TextFormField(
          style: const TextStyle(color: ConstColors.black),
          controller: _overController,
          decoration: const InputDecoration(
              hintText: 'Select Over',
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: ConstColors.ofwhite,
              )),
          onChanged: (value) {
            setState(() {
              isOpen = false;
            });
          },
          onTap: () {
            setState(() {
              isOpen = true;
            });
          },
        ),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }

  //------------------------------------------------------------------ Helper Widgtes -----------------------------------------------------------------//
  Widget _buildDivider(Size size, String title) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: ConstColors.grayF4,
            height: 1,
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: ConstColors.darkGray7C,
            fontSize: 14,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Expanded(
          child: Container(
            color: ConstColors.grayF4,
            height: 1,
          ),
        ),
      ],
    );
  }

  //------------------------------------------------------------------ Buttons -----------------------------------------------------------------//
  Widget _buildLetsStartButton(Size size, BuildContext context) {
    return MaterialButton2(
      minWidth: size.width,
      buttonText: 'Let’s Start',
      onPressed: () async {
        if (_selectTeamA != null &&
            _selectTeamB != null &&
            venuController.text.isNotEmpty &&
            selectedDate != '' &&
            selectedTime != '' &&
            _overController.text.isNotEmpty) {
          showLoader(context);
          if (selectedDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
            Map<String, dynamic> matchInfo = {
              'date': selectedDate,
              'venue': venuController.text.trim(),
              'time': selectedTime,
              'umpire': preferences.getString(Keys.userID),
              'over': _overController.text.trim(),
            };
            showLoader(context);
            final response = await matchController.checkPlayerSink(teamData: {
              'team1': _selectTeamA?.id.toString(),
              'team2': _selectTeamB?.id.toString(),
            });
            if (response.status ?? false) {
              if (!mounted) return;
              hideLoader(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TossScreen(
                    teamA: _selectTeamA!,
                    teamB: _selectTeamB!,
                    matchInfo: matchInfo,
                    isUpdate: false,
                  ),
                ),
              );
            } else {
              if (!mounted) return;
              hideLoader(context);
              showTostMessage(message: response.message ?? '');
            }
          } else {
            Map<String, dynamic> mapData = {
              'team1': _selectTeamA?.id.toString(),
              'team2': _selectTeamB?.id.toString(),
              'tose_winner': '',
              'toss_decision': '',
              'opener': '',
              'is_toss': "0",
              'bowler': '',
              'bowing_team': '',
              'batting_team': '',
              'date': selectedDate,
              'venue': venuController.text.trim(),
              'time': selectedTime,
              'umpire': preferences.getString(Keys.userID),
              'over': _overController.text.trim(),
            };
            final createMatchResponse =
                await matchController.createMatchSink(createMatchInfo: mapData);
            if (createMatchResponse.data?.status == 200) {
              if (!mounted) return;
              hideLoader(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(selectedIndex: 0),
                ),
              );
            } else {
              if (!mounted) return;
              hideLoader(context);
              showTostMessage(message: createMatchResponse.message.toString());
            }
          }
        } else {
          Fluttertoast.showToast(msg: 'Please Enter valid input');
        }
      },
    );
  }
}
