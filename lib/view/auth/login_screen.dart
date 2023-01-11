import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/constant/strings.dart';
import 'package:cricketly/controller/auth/login_controller.dart';
import 'package:cricketly/view/auth/create_player_profile_screen.dart';
import 'package:cricketly/view/auth/login_otp_screen.dart';
import 'package:cricketly/view/auth/login_with_email.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  LoginController loginController = LoginController();
  TextEditingController phoneNumberController = TextEditingController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  String selectedCountryCode = '';
  final _formKey = GlobalKey<FormState>();
  String? deviceToken;
  //--------------------------------------------------------------------- UI ---------------------------------------------------------------------//

  @override
  void initState() {
    super.initState();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      deviceToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstColors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Image.asset(
                ConstImages.loginBackground,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ConstColors.black.withOpacity(0.5),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.15,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          ConstImages.logo,
                          height: size.height * 0.2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _buildPhoneFiled(size),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _buildContinueButton(size, context),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    _buildOrView(),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _buildSocialButton(size),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// Phone filed
  Widget _buildPhoneFiled(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: ConstColors.white,
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
            // countryFilter: const ['IN'],
            showCountryOnly: false,
            hideSearch: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
            showFlag: true,
            flagWidth: 20.0,
            initialSelection: "US",
            showDropDownButton: true,
            textStyle: const TextStyle(
              color: ConstColors.black,
            ),

            searchDecoration: InputDecoration(
              hintText: 'Search country',
              hintStyle: TextStyle(color: ConstColors.black.withOpacity(0.5)),
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
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: phoneNumberController,
              cursorColor: ConstColors.black,
              autofillHints: const [AutofillHints.telephoneNumber],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid 10 digit phone number';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: ConstStrings.enterPhoneNumberStr,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: ConstColors.black,
                ),
                errorMaxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Or View
  Widget _buildOrView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: ConstColors.white,
            height: 1,
          ),
        ),
        const SizedBox(width: 5),
        const Text(
          'OR',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            color: ConstColors.white,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(Size size) {
    return Platform.isAndroid
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEmailButton(size),
              _buildGoogleButton(size),
              _buildFacebookButton(size),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEmailButton(size),
              _buildGoogleButton(size),
              _buildFacebookButton(size),
              _buildAppleButton(size),
            ],
          );
  }

  //------------------------------------------------------------------ Buttons -----------------------------------------------------------------//
  Widget _buildContinueButton(Size size, BuildContext context) {
    return MaterialButton2(
      minWidth: size.width,
      buttonText: 'Continue'.toUpperCase(),
      onPressed: () async {
        preferences.setString(Keys.loginType, "mobile");
        if (_formKey.currentState!.validate()) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return LoginOTPScreen(
                  phoneNumber: phoneNumberController.text.trim(),
                  selectedCountryCode: selectedCountryCode,
                  deviceToken: deviceToken ?? '',
                );
              },
            ),
          );
        }
      },
    );
  }

  // Apple Button
  Widget _buildAppleButton(Size size) {
    return GestureDetector(
      onTap: () async {
        preferences.setString(Keys.loginType, "social");
        showLoader(context);
        var appleResponse = await loginController.signInWithAppleController();
        if (appleResponse.status == true) {
          final loginResponse = await loginController.socialSink(
            uuid: appleResponse.data?.user?.uid ?? '',
            deviceToken: deviceToken ?? '',
          );
          if (loginResponse.data?.isRegister == false) {
            if (!mounted) return;
            hideLoader(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePlayerProfileScreen(
                  email: appleResponse.data?.user?.email,
                  userProfile: appleResponse.data?.user?.photoURL,
                  isEmailAccount: false,
                  uuid: appleResponse.data?.user?.uid,
                  moileNumber: appleResponse.data?.user?.phoneNumber ?? '',
                ),
              ),
            );
          } else {
            if (loginResponse.data?.isRegister ?? false) {
              if (!mounted) return;
              hideLoader(context);
              preferences.setString(
                  Keys.userID, loginResponse.data?.result?.id.toString() ?? '');
              preferences.setString(
                  Keys.token, 'token ${loginResponse.data?.result?.token}');
              Navigator.pushReplacement(
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
                message: loginResponse.message ?? '',
              );
            }
          }
        } else {
          if (!mounted) return;
          hideLoader(context);
          showTostMessage(message: ConstStrings.accountNotExistStr);
        }
      },
      child: CircleAvatar(
        radius: size.height * 0.035,
        backgroundColor: ConstColors.white,
        child: Image.asset(
          ConstImages.appleLogo,
          height: size.height * 0.04,
        ),
      ),
    );
  }

  // Google Button
  Widget _buildGoogleButton(Size size) {
    return GestureDetector(
      onTap: () async {
        preferences.setString(Keys.loginType, "social");
        showLoader(context);
        var googleResponse = await loginController.signInWithGoogleController();
        if (googleResponse.status == true) {
          final loginResponse = await loginController.socialSink(
            uuid: googleResponse.data?.user?.uid ?? '',
            deviceToken: deviceToken ?? '',
          );
          if (loginResponse.data?.isRegister == false) {
            if (!mounted) return;
            hideLoader(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePlayerProfileScreen(
                  email: googleResponse.data?.user?.email,
                  userProfile: googleResponse.data?.user?.photoURL,
                  userProfileUrl: googleResponse.data?.user?.photoURL,
                  isEmailAccount: false,
                  uuid: googleResponse.data?.user?.uid,
                  moileNumber: googleResponse.data?.user?.phoneNumber ?? '',
                ),
              ),
            );
          } else {
            if (loginResponse.data?.isRegister ?? false) {
              if (!mounted) return;
              hideLoader(context);
              preferences.setString(
                  Keys.userID, loginResponse.data?.result?.id.toString() ?? '');
              preferences.setString(
                  Keys.token, 'token ${loginResponse.data?.result?.token}');
              Navigator.pushReplacement(
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
                message: loginResponse.message ?? '',
              );
            }
          }
        } else {
          if (!mounted) return;
          hideLoader(context);
          showTostMessage(
            message: ConstStrings.accountNotExistStr,
          );
        }
      },
      child: CircleAvatar(
        radius: size.height * 0.035,
        backgroundColor: ConstColors.white,
        child: SvgPicture.asset(
          ConstImages.googleLogoImage,
          height: size.height * 0.03,
        ),
      ),
    );
  }

  Widget _buildEmailButton(Size size) {
    return GestureDetector(
      onTap: () {
        preferences.setString(Keys.loginType, "normal");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginWithEmailScreen(),
          ),
        );
      },
      child: CircleAvatar(
        radius: size.height * 0.035,
        backgroundColor: ConstColors.white,
        child: SvgPicture.asset(
          ConstImages.emailIcon,
          height: size.height * 0.03,
          color: ConstColors.black,
        ),
      ),
    );
  }

  Widget _buildFacebookButton(Size size) {
    return GestureDetector(
      onTap: () async {
        preferences.setString(Keys.loginType, "social");
        // showLoader(context);
        // var faceBookResponse =
        //     await loginController.signInWithFacebookController();
        // if (faceBookResponse.status == true) {
        //   final loginResponse = await loginController.socialSink(
        //     uuid: faceBookResponse.data?.user?.uid ?? '',
        //     deviceToken: deviceToken ?? '',
        //   );
        //   if (loginResponse.data?.isRegister == false) {
        //     if (!mounted) return;
        //     hideLoader(context);
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => CreatePlayerProfileScreen(
        //           email: faceBookResponse.data?.user?.email,
        //           userProfile: faceBookResponse.data?.user?.photoURL,
        //           isEmailAccount: false,
        //           uuid: faceBookResponse.data?.user?.uid,
        //           moileNumber: faceBookResponse.data?.user?.phoneNumber ?? '',
        //         ),
        //       ),
        //     );
        //   } else {
        //     if (loginResponse.data?.isRegister ?? false) {
        //       if (!mounted) return;
        //       hideLoader(context);
        //       preferences.setString(
        //           Keys.userID, loginResponse.data?.result?.id.toString() ?? '');
        //       preferences.setString(
        //           Keys.token, 'token ${loginResponse.data?.result?.token}');
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => BottomBarScreen(
        //             selectedIndex: 0,
        //           ),
        //         ),
        //       );
        //     } else {
        //       if (!mounted) return;
        //       hideLoader(context);
        //       showTostMessage(
        //         message: loginResponse.message ?? '',
        //       );
        //     }
        //   }
        // } else {
        //   if (!mounted) return;
        //   hideLoader(context);
        //   showTostMessage(
        //     message: ConstStrings.accountNotExistStr,
        //   );
        // }
      },
      child: CircleAvatar(
        radius: size.height * 0.035,
        backgroundColor: ConstColors.white,
        child: SvgPicture.asset(
          ConstImages.fbLogoImg,
          height: size.height * 0.03,
        ),
      ),
    );
  }
}
