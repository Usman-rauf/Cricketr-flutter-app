import 'dart:io';

import 'package:cricketly/view/settings/my_team/update_player_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/colors.dart';
import '../../../constant/images.dart';
import '../../../widgtes/appbar.dart';
import '../../../widgtes/button.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen(
      {super.key,
      required this.playerList,
      required this.teamName,
      required this.caption,
      required this.wicketKeeper,
      required this.id});
  List playerList = [];
  String teamName;
  int caption;
  int wicketKeeper;
  int id;
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _teamFormKey = GlobalKey<FormState>();
  TextEditingController txtteamController = TextEditingController();
  File? imageFile;
  @override
  void initState() {
    txtteamController.text = widget.teamName;
    super.initState();
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.of(context).pop();
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _teamFormKey,
            child: Column(
              children: [
                BuildAppBar(
                  title: 'Update Team',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      _buildImageView(size),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      _buildTeamANameField(),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      MaterialButton2(
                        minWidth: size.width,
                        buttonText: 'Continue'.toUpperCase(),
                        onPressed: () {
                          // if (_teamFormKey.currentState!.validate()) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => PlayerListScreen(
                          //         teamName: teamController.text.trim(),
                          //       ),
                          //     ),
                          //   );
                          // }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePlayerList(
                                selectedPlayerList: widget.playerList,
                                teamName: txtteamController.text.trim(),
                                caption: widget.caption,
                                wicketKeeper: widget.wicketKeeper,
                                id: widget.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamANameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        style: const TextStyle(
          color: ConstColors.black,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter team name';
          }
          return null;
        },
        controller: txtteamController,
        cursorColor: ConstColors.black,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          hintText: 'Enter team name',
        ),
      ),
    );
  }

  Widget _buildImageView(Size size) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Select profile Picture',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              actions: [
                MaterialButton2(
                  buttonText: 'camera'.toUpperCase(),
                  onPressed: () async {
                    await _getFromCamera();
                  },
                ),
                MaterialButton2(
                  buttonText: 'gallery'.toUpperCase(),
                  onPressed: () async {
                    await _getFromGallery();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Stack(
        children: [
          imageFile != null
              ? Container(
                  height: size.height * 0.15,
                  width: size.width * 0.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ConstColors.ofwhite,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: size.height * 0.2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ConstColors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: SvgPicture.asset(
                    ConstImages.userIcon,
                    fit: BoxFit.cover,
                    color: ConstColors.white,
                    height: size.height * 0.2,
                  ),
                ),
          Positioned(
            bottom: size.height * 0.015,
            right: size.width * 0.02,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ConstColors.appGreen8FColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.edit,
                  color: ConstColors.white,
                  size: size.height * 0.02,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
