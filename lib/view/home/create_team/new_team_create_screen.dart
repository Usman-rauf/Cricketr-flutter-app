import 'dart:io';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/view/home/create_team/player_list_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class NewTeamCreateScreen extends StatefulWidget {
  const NewTeamCreateScreen({super.key});

  @override
  State<NewTeamCreateScreen> createState() => _NewTeamCreateScreenState();
}

class _NewTeamCreateScreenState extends State<NewTeamCreateScreen> {
  final _teamFormKey = GlobalKey<FormState>();
  TextEditingController teamController = TextEditingController();
  File? imageFile;

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
                  title: 'Create New Team',
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
                          if (_teamFormKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerListScreen(
                                  teamName: teamController.text.trim(),
                                ),
                              ),
                            );
                          }
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
        controller: teamController,
        cursorColor: ConstColors.black,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Enter Team Name',
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
              title: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Select profile Picture',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: size.height * 0.047,
                      child: MaterialButton2(
                        minWidth: size.width * 0.07,
                        buttonText: 'camera'.toUpperCase(),
                        onPressed: () async {
                          await _getFromCamera();
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.047,
                      child: MaterialButton2(
                        minWidth: size.width * 0.07,
                        buttonText: 'gallery'.toUpperCase(),
                        onPressed: () async {
                          await _getFromGallery();
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
