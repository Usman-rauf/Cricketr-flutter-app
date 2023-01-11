import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class CreatePlayerProfileScreen extends StatefulWidget {
  String? email;
  String? userProfile;
  String? userProfileUrl;
  String? password;
  bool? isEmailAccount;
  String? uuid;
  String? moileNumber;

  CreatePlayerProfileScreen({
    this.email,
    this.userProfile,
    this.userProfileUrl,
    this.password,
    this.isEmailAccount,
    this.uuid,
    this.moileNumber,
  });
  @override
  State<CreatePlayerProfileScreen> createState() =>
      _CreatePlayerProfileScreenState();
}

class _CreatePlayerProfileScreenState extends State<CreatePlayerProfileScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  UserController userController = UserController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jerseyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  String? _selectedPlayerType;
  String? _selectedBatsmanType;
  String? _selectedBolwerType;
  bool isValidName = false;
  File? imageFile;
  String? selectCountry;

  final List<String> _playerTypeList = [
    'BATSMAN',
    'BOWLER',
    'WICKET-KEEPER',
    'ALL-ROUNDER'
  ];
  final List<String> batsmanList = [
    'RIGHT HAND BATSMAN',
    'LEFT HAND BATSMAN',
  ];
  final List<String> ballerList = [
    'RIGHT ARM PACE/SEAM BOWLING',
    'LEFT ARM PACE/SEAM BOWLING',
    'RIGHT ARM SPIN BOWLING',
    'LEFT ARM SPIN BOWLING'
  ];

  @override
  void initState() {
    emailController.text = widget.email ?? '';
    phoneController.text = widget.moileNumber ?? '';
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ConstColors.white,
        appBar: AppBar(
          backgroundColor: ConstColors.white,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ConstColors.black),
          title: Text(
            'Create Player Profile',
            style: TextStyle(
              color: ConstColors.black,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              fontSize: size.height * 0.025,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildImageView(size),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUserNameField(size),
                        ),
                        SizedBox(
                          width: size.width * 0.04,
                        ),
                        Expanded(
                          child: _buildJerseyNumber(size),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    phoneController.text != ''
                        ? _buildPhoneField(size)
                        : _buildEmailField(size),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    _buildSelectCountry(size, context),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    _buildSelectedDropDown(),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    _selectedPlayerType == 'BATSMAN'
                        ? _buildBatsmanTypeDropDown()
                        : _selectedPlayerType == 'BOWLER'
                            ? _buildBolwerTypeDropDown()
                            : const SizedBox(),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    _buildContiuneButton(size),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectCountry(Size size, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Country*',
          style: TextStyle(
            color: ConstColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            showCountryPicker(
                context: context,
                countryListTheme: CountryListThemeData(
                  flagSize: 25,
                  backgroundColor: Colors.white,
                  textStyle:
                      const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  bottomSheetHeight: 500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  inputDecoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Start typing to search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF8C98A8).withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                onSelect: (Country country) {
                  setState(() {
                    selectCountry =
                        // '${country.flagEmoji} ${country.name}';
                        country.name;
                  });
                });
          },
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              color: ConstColors.whiteColorF9,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.018,
              horizontal: size.width * 0.03,
            ),
            child: Text(
              selectCountry ?? 'Select Country',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ConstColors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageView(Size size) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
          widget.userProfile != null
              ? Container(
                  height: size.height * 0.17,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ConstColors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: widget.userProfile == ''
                      ? Container(
                          height: size.height * 0.12,
                          width: size.width * 0.4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ConstColors.black,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: SvgPicture.asset(
                            ConstImages.userIcon,
                            fit: BoxFit.cover,
                            color: ConstColors.white,
                            height: size.height * 0.17,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.userProfile ?? '',
                          fit: BoxFit.contain,
                          height: size.height * 0.3,
                          width: size.width * 0.3,
                        ),
                )
              : imageFile != null
                  ? Container(
                      height: size.height * 0.17,
                      width: size.width * 0.4,
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
                      height: size.height * 0.17,
                      width: size.width * 0.4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ConstColors.black,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: SvgPicture.asset(
                        ConstImages.userIcon,
                        fit: BoxFit.cover,
                        color: ConstColors.white,
                        height: size.height * 0.17,
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

//-------------------------------------------------------------- Helper Functions --------------------------------------------------------------//
  Widget _buildSelectedDropDown() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Player Type*',
          style: TextStyle(
            color: ConstColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            color: ConstColors.whiteColorF9,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              dropdownMaxHeight: size.height * 0.2,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: ConstColors.black,
              ),
              hint: Text(
                'Select Player Type',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: _selectedPlayerType,
              onChanged: (String? newValue) {
                FocusScope.of(context).unfocus();
                setState(() {
                  _selectedPlayerType = newValue ?? '';
                  _selectedBatsmanType = null;
                  _selectedBolwerType = null;
                });
              },
              items: _playerTypeList.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(
                    location,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ConstColors.black.withOpacity(0.5),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatsmanTypeDropDown() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Batsman Type',
          style: TextStyle(
            color: ConstColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            color: ConstColors.whiteColorF9,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              dropdownPadding:
                  EdgeInsets.symmetric(horizontal: size.width * 0.01),
              isExpanded: true,
              dropdownMaxHeight: size.height * 0.6,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: ConstColors.black,
              ),
              hint: Text(
                'Select Player Type',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: _selectedBatsmanType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBatsmanType = newValue ?? '';
                });
              },
              items: batsmanList.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(
                    location,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ConstColors.black.withOpacity(0.5),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBolwerTypeDropDown() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bowler Type',
          style: TextStyle(
            color: ConstColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            color: ConstColors.whiteColorF9,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              dropdownPadding:
                  EdgeInsets.symmetric(horizontal: size.width * 0.01),
              isExpanded: true,
              dropdownMaxHeight: size.height * 0.6,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: ConstColors.black,
              ),
              hint: Text(
                'Select Player Type',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: _selectedBolwerType,
              onChanged: (String? newValue) {
                FocusScope.of(context).unfocus();
                setState(() {
                  _selectedBolwerType = newValue ?? '';
                });
              },
              items: ballerList.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(
                    location,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ConstColors.black.withOpacity(0.5),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameField(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Username*',
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
          controller: userNameController,
          cursorColor: ConstColors.black,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid Username';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter username',
          ),
        ),
      ],
    );
  }

  Widget _buildJerseyNumber(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jersey*',
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
          controller: jerseyController,
          cursorColor: ConstColors.black,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Jersey Number';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Jersey number',
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
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
          controller: emailController,
          cursorColor: ConstColors.black,
          enabled: !(widget.isEmailAccount ?? false) ? false : true,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            String pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = RegExp(pattern);

            if (!regex.hasMatch(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter email (optional)',
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone No',
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
          controller: phoneController,
          cursorColor: ConstColors.black,
          enabled: false,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  // Login button
  Widget _buildContiuneButton(Size size) {
    return MaterialButton2(
      onPressed: () async {
        if (userNameController.text.isEmpty ||
            selectCountry == '' ||
            jerseyController.text.isEmpty ||
            _selectedPlayerType == '') {
          return showTostMessage(
            message: 'Please Enter Required Details.',
          );
        } else {
          showLoader(context);

          Map<String, dynamic> userPostData = {
            'username': userNameController.text.trim(),
            'email': emailController.text.trim(),
            'password': widget.password?.trim() ?? '',
            'profile_image': preferences.getString(Keys.loginType) == "social"
                ? ""
                : (widget.userProfile ?? ''),
            'profile_image_url':
                preferences.getString(Keys.loginType) != "social"
                    ? ""
                    : (widget.userProfileUrl ?? ''),
            'player_type': _selectedPlayerType ?? '',
            'batsman_type': _selectedBatsmanType ?? '',
            'bowler_type': _selectedBolwerType ?? '',
            'country': selectCountry ?? '',
            'uuid': widget.uuid ?? '',
            'mobile_no': widget.moileNumber,
            "jersey_no": jerseyController.text.trim(),
            // "login_type": "social",
            'login_type': preferences.getString(Keys.loginType) ?? "normal",
          };
          var createUserREsponse = await userController.createUserSink(
            createUserPostData: userPostData,
            profileImage: imageFile ?? File(''),
          );
          if (createUserREsponse.status ?? false) {
            if (createUserREsponse.data?.status == 200) {
              if (!mounted) return;
              hideLoader(context);
              preferences.setString(Keys.userID,
                  createUserREsponse.data?.result?.id.toString() ?? '');
              preferences.setString(Keys.token,
                  'token ${createUserREsponse.data?.result?.token}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(
                    selectedIndex: 0,
                  ),
                ),
              );
            } else {
              if (!mounted) return;
              hideLoader(context);
              showTostMessage(
                message: createUserREsponse.message ?? '',
              );
            }
          } else {
            if (!mounted) return;
            hideLoader(context);
            showTostMessage(
              message: createUserREsponse.message ?? '',
            );
          }
        }
      },
      buttonText: 'Continue'.toUpperCase(),
      minWidth: size.width,
    );
  }
}
