import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/controller/auth/login_controller.dart';
import 'package:cricketly/view/auth/create_player_profile_screen.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginOTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String selectedCountryCode;
  final String deviceToken;
  const LoginOTPScreen({
    Key? key,
    required this.phoneNumber,
    required this.selectedCountryCode,
    required this.deviceToken,
  }) : super(key: key);

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
//------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  LoginController loginController = LoginController();
  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//
  TextEditingController otpController = TextEditingController();
  String? _verificationCode;

  @override
  void initState() {
    // _verifyPhone();
    super.initState();
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.selectedCountryCode}${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential).then(
            (value) async {
              if (value.user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBarScreen(
                      selectedIndex: 0,
                    ),
                  ),
                );
              }
            },
          );
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ConstColors.black,
                  ),
                ),
                Text(
                  'Enter OTP'.toUpperCase(),
                  style: TextStyle(
                    color: ConstColors.black,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.w600,
                    fontSize: size.height * 0.04,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  _buildPinTextField(),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  _buildVerifyOtpButton(size),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//-------------------------------------------------------------- Helper Functions --------------------------------------------------------------//
  Widget _buildPinTextField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      controller: otpController,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        borderWidth: 1,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 46,
        fieldWidth: 45,
        disabledColor: Colors.black,
        inactiveFillColor: ConstColors.black.withOpacity(0.2),
        activeFillColor: ConstColors.black.withOpacity(0.2),
        selectedFillColor: Colors.transparent,
        errorBorderColor: Colors.transparent,
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedColor: Colors.green,
      ),
      textStyle: const TextStyle(
        color: ConstColors.black,
        fontSize: 12,
      ),
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      onCompleted: (v) {
        setState(() {
          otpController.text = v;
        });
      },
      onChanged: (value) {},
      appContext: context,
    );
  }

  // Login button
  Widget _buildVerifyOtpButton(Size size) {
    return MaterialButton2(
      onPressed: () async {
        if (otpController.text.length < 6) {
          showTostMessage(message: 'Please enter OTP first');
        } else {
          showLoader(context);
          final phoneAuthResponse = await loginController.phoneController(
            otpText: otpController.text,
            verificationId: _verificationCode ?? "",
          );
          if (phoneAuthResponse.status == true) {
            var checkMobileResponse = await loginController.checkMobileSink(
                mobileNumber: widget.phoneNumber);
            if (checkMobileResponse.data?.status == 200) {
              if (!mounted) return;
              hideLoader(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePlayerProfileScreen(
                    email: phoneAuthResponse.data?.user?.photoURL ?? '',
                    userProfile: '',
                    isEmailAccount: false,
                    uuid: phoneAuthResponse.data?.user?.uid,
                    moileNumber: widget.phoneNumber,
                  ),
                ),
              );
            } else {
              Map<String, dynamic> loginPostData = {
                'mobile_no': widget.phoneNumber,
                'device_token': widget.deviceToken,
                // 'login_type': 'normal',
                'login_type': preferences.getString(Keys.loginType) ?? "normal",
                'uuid': phoneAuthResponse.data?.user?.uid,
              };
              var loginResponse =
                  await loginController.loginSink(loginPostData);
              if (loginResponse.data?.status == 200) {
                if (!mounted) return;
                hideLoader(context);
                preferences.setString(Keys.userID,
                    loginResponse.data?.result?.id.toString() ?? '');
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
                  message: loginResponse.data?.message ?? '',
                );
              }
            }
          } else {
            if (!mounted) return;
            hideLoader(context);
            showTostMessage(
              message: 'Please enter valid OTP',
            );
          }
        }
      },
      buttonText: 'Verify Code',
      minWidth: size.width,
    );
  }
}
