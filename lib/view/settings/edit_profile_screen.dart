import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditProfileScreen extends StatefulWidget {
  String imageUrl;
  String username;
  String email;
  String playerType;
  String batsmanType;
  String country;
  String address;
  String bowlerType;
  String mobileNo;
  int id;
  String jerseyNo;

  EditProfileScreen({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.email,
    required this.address,
    required this.playerType,
    required this.batsmanType,
    required this.bowlerType,
    required this.country,
    required this.mobileNo,
    required this.id,
    required this.jerseyNo,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  TextEditingController userNameController = TextEditingController();
  TextEditingController jerseynoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//

  final _formKey = GlobalKey<FormState>();
  String? _selectedPlayerType;
  String? _selectedBatsmanType;
  String? _selectedBolwerType;
  bool isButtonActive = false;
  String selectedCountryCode = '';
  UserController userController = UserController();
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
    super.initState();
    userNameController.text = widget.username;
    addressController.text = widget.address;
    emailController.text = widget.email;

    phoneNumberController.text = widget.mobileNo;
    _selectedPlayerType = widget.playerType;
    _selectedBatsmanType = 'RIGHT HAND BATSMAN';
    // _selectedBatsmanType = widget.batsmanType;
    selectCountry = widget.country;
    _selectedBolwerType = widget.bowlerType;
    jerseynoController.text = widget.jerseyNo;
  }

  //--------------------------------------------------------------------- UI ---------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstColors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BuildAppBar(
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildImageView(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildUserNameField(size),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _buildJerseyNoField(size),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      widget.email.isNotEmpty
                          ? _buildEmailField(size)
                          : _buildPhoneFiled(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _buildAddressField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _buildSelectedDropDown(),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _selectedPlayerType == 'BATSMAN'
                          ? _buildBatsmanTypeDropDown()
                          : _selectedPlayerType == 'BOWLER'
                              ? _buildBolwerTypeDropDown()
                              : const SizedBox(),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _buildCountryField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _buildUpdateButton(size),
                      SizedBox(
                        height: size.height * 0.03,
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

//-------------------------------------------------------------- Helper Functions --------------------------------------------------------------//
  Widget _buildUserNameField(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Username',
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
          readOnly: true,
          controller: userNameController,
          cursorColor: ConstColors.black,
          keyboardType: TextInputType.name,
          onChanged: (value) {
            // userNameController.text = value;
            setState(() {
              if (widget.username == value) {
                isButtonActive = false;
              } else {
                isButtonActive = true;
              }
            });
          },
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
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

  Widget _buildJerseyNoField(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jersey no',
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
          readOnly: true,
          controller: jerseynoController,
          cursorColor: ConstColors.black,
          keyboardType: TextInputType.name,
          onChanged: (value) {
            // userNameController.text = value;
            setState(() {
              if (jerseynoController.text == value) {
                isButtonActive = false;
              } else {
                isButtonActive = true;
              }
            });
          },
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a jersey no';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter Jersey no',
          ),
        ),
      ],
    );
  }

  Widget _buildCountryField(Size size) {
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
                    if (widget.country == country.name) {
                      isButtonActive = false;
                    } else {
                      isButtonActive = true;
                    }
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
          controller: emailController,
          style: const TextStyle(
            color: Colors.black,
          ),
          readOnly: true,
          cursorColor: ConstColors.black,
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
            hintText: 'Enter email',
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
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
          controller: addressController,
          cursorColor: ConstColors.black,
          keyboardType: TextInputType.name,
          onChanged: (value) {
            // userNameController.text = value;
            setState(() {
              if (widget.address == value) {
                isButtonActive = false;
              } else {
                isButtonActive = true;
              }
            });
          },
          maxLines: 3,
          minLines: 3,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a address';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter address',
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFiled(Size size) {
    return widget.mobileNo.isEmpty
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: ConstColors.black.withOpacity(0.1),
              // color: ConstColors.grayF4,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CountryCodePicker(
                  dialogSize: Size(size.width - 100, size.height / 2),
                  padding: const EdgeInsets.all(0.0),
                  onChanged: (CountryCode code) {
                    selectedCountryCode = code.dialCode ?? "+1";
                  },

                  showCountryOnly: false,
                  hideSearch: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  showFlag: true,
                  flagWidth: 20.0,
                  initialSelection: "US",
                  //showDropDownButton: true,
                  textStyle: const TextStyle(
                    color: ConstColors.black,
                  ),

                  searchDecoration: InputDecoration(
                    hintText: 'Search country',
                    hintStyle:
                        TextStyle(color: ConstColors.black.withOpacity(0.5)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ConstColors.black.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: ConstColors.black.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 2,
                ),
                // Phone Number...
                Expanded(
                  child: TextFormField(
                    controller: phoneNumberController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    readOnly: true,
                    cursorColor: ConstColors.black,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length != 10) {
                        return 'Please enter a valid 10 digit phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter phone number',
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildSelectedDropDown() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Player Type',
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
            color: ConstColors.black.withOpacity(0.1),
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
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: _selectedPlayerType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPlayerType = newValue ?? '';
                  _selectedBatsmanType = null;
                  _selectedBolwerType = null;
                });

                setState(() {
                  if (widget.playerType == newValue) {
                    isButtonActive = false;
                  } else {
                    isButtonActive = true;
                  }
                });
              },
              items: _playerTypeList.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
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
            color: ConstColors.black.withOpacity(0.1),
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
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: _selectedBatsmanType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBatsmanType = newValue ?? '';
                });
                setState(() {
                  if (widget.batsmanType == newValue) {
                    isButtonActive = false;
                  } else {
                    isButtonActive = true;
                  }
                });
              },
              items: batsmanList.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
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
            color: ConstColors.black.withOpacity(0.1),
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
                  color: ConstColors.black.withOpacity(0.5),
                ),
              ),
              value: _selectedBolwerType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBolwerType = newValue ?? '';
                });
                setState(() {
                  if (widget.bowlerType == newValue) {
                    isButtonActive = false;
                  } else {
                    isButtonActive = true;
                  }
                });
              },
              items: ballerList.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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

  Widget _buildImageView(Size size) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Container(
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

  Widget _buildUpdateButton(Size size) {
    return Container(
      decoration: BoxDecoration(
          gradient: !isButtonActive
              ? LinearGradient(
                  colors: [
                    ConstColors.black.withOpacity(0.1),
                    ConstColors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xff0CAB65),
                    Color(0xff3BB78F),
                    Color(0xff3BB78F),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: MaterialButton(
        onPressed: isButtonActive
            ? () async {
                showLoader(context);
                Map<String, dynamic> updateProfileData = {
                  "address": addressController.text.trim(),
                  'profile_image': widget.imageUrl,
                  'player_type': _selectedPlayerType ?? '',
                  'batsman_type': _selectedBatsmanType ?? '',
                  'bowler_type': _selectedBolwerType ?? '',
                  'country': selectCountry.toString(),
                };
                var createUserREsponse = await userController.updateUserSink(
                    id: widget.id, updateUserData: updateProfileData);
                if (createUserREsponse.status ?? false) {
                  if (!mounted) return;
                  hideLoader(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomBarScreen(selectedIndex: 3),
                    ),
                  );
                } else {
                  if (!mounted) return;
                  hideLoader(context);
                  showTostMessage(
                    message: createUserREsponse.message ?? '',
                  );
                }
              }
            : null,
        minWidth: size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(12),
        child: Text(
          "Update".toUpperCase(),
          style: TextStyle(
            color: isButtonActive ? ConstColors.white : ConstColors.black,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
