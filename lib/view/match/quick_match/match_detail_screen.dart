import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/match/match_controller.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constant/colors.dart';
import '../../../widgtes/loader.dart';
import '../match_start/toss_screen.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key, required this.teamA, required this.teamB});
  final TeamInfo teamA;
  final TeamInfo teamB;

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  //--------------------------------------------------------------------- Controller ---------------------------------------------------------------------//
  TextEditingController venuController = TextEditingController();
  final TextEditingController _overController = TextEditingController();
  MatchController matchController = MatchController();

//------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  String selectedDate = '';
  String selectedTime = '';
  bool isOpen = false;

  _selectDate() async {
    DateTime now = DateTime.now();
    var picked = await showDatePicker(
        context: context,
        initialDate: now,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: now,
        lastDate: DateTime(2101));
    setState(() {
      selectedDate = DateFormat("yyyy-MM-dd").format(picked!);
    });
  }

  Future<void> _selectTime() async {
    var pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    DateTime parsedTime =
        // ignore: use_build_context_synchronously
        DateFormat.jm().parse(pickedTime?.format(context).toString() ?? '');

    String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

    setState(() {
      selectedTime = formattedTime;
    });
  }

//--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BuildAppBar(
              title: 'Quick Match',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  _buildDivider(size, 'Venue'),
                  SizedBox(
                    height: size.height * 0.02,
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
                            await _selectDate();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date*',
                                style: TextStyle(
                                  color: ConstColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border:
                                      Border.all(color: ConstColors.boardColor),
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _selectTime();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time*',
                                style: TextStyle(
                                  color: ConstColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ConstColors.boardColor),
                                  borderRadius: BorderRadius.circular(7),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _buildSelectOver(size),
                  SizedBox(height: size.height * 0.02),
                  _buildLetsStartButton(size, context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildVenuField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Venue*',
          style: TextStyle(
            color: ConstColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        TextFormField(
          style: const TextStyle(
            color: Colors.black,
          ),
          controller: venuController,
          cursorColor: ConstColors.black,
          keyboardType: TextInputType.name,
          maxLines: 3,
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
        ),
      ],
    );
  }

  Widget _buildSelectOver(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Over*',
          style: TextStyle(
            color: ConstColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        TextFormField(
          style: const TextStyle(color: ConstColors.black),
          controller: _overController,
          decoration: const InputDecoration(
              hintText: 'Enter Over',
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

  Widget _buildLetsStartButton(Size size, BuildContext context) {
    return MaterialButton2(
      minWidth: size.width,
      buttonText: 'Let’s Start',
      onPressed: () async {
        if (venuController.text.isNotEmpty &&
            selectedDate != '' &&
            selectedTime != '' &&
            _overController.text.isNotEmpty) {
          Map<String, dynamic> matchInfo = {
            'date': selectedDate,
            'venue': venuController.text.trim(),
            'time': selectedTime,
            'umpire': preferences.getString(Keys.userID),
            'over': _overController.text.trim(),
          };
          showLoader(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TossScreen(
                teamA: widget.teamA,
                teamB: widget.teamB,
                matchInfo: matchInfo,
                isUpdate: false,
              ),
            ),
          );
        } else {
          showTostMessage(message: 'Please Enter valid input');
        }
      },
    );
  }
}
