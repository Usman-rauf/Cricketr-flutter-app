import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/constant/strings.dart';
import 'package:cricketly/controller/auth/login_controller.dart';
import 'package:cricketly/controller/user/user_controller.dart';
import 'package:cricketly/view/auth/create_account_screen.dart';
import 'package:cricketly/view/auth/forgot_password/email_enter_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  LoginController loginController = LoginController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//

  final _formKey = GlobalKey<FormState>();
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      deviceToken = token;
    });
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
                  title: 'Login With Email',
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
                      SizedBox(
                        width: size.width / 1.5,
                        child: Image.asset(
                          ConstImages.applogoImage,
                          color: ConstColors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: size.height * 0.04,
                            color: ConstColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      _buildEmailField(size),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      _buildPasswordField(size),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return EnterEmailScreen();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.06,
                      ),
                      _buildLoginButton(size),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: ConstColors.boardColor),
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.015),
                          child: Center(
                            child: Text(
                              'Create Account'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
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
  Widget _buildEmailField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email or username',
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
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter username or email';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter email or username',
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
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
          controller: passwordController,
          cursorColor: ConstColors.black,
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 5) {
              return 'Please enter 6 character password';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter password',
          ),
        ),
      ],
    );
  }

  //--------------------------------------------------------------- Button actions ---------------------------------------------------------------//

// Login button
  Widget _buildLoginButton(Size size) {
    return MaterialButton2(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          showLoader(context);
          Map<String, dynamic> loginPostData = {
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
            // 'login_type': 'normal',
            'login_type': preferences.getString(Keys.loginType) ?? "normal",
            'device_token': deviceToken,
          };
          var loginResponse = await loginController.loginSink(loginPostData);
          if (loginResponse.data?.status == 200) {
            preferences.setString(
                Keys.userID, loginResponse.data?.result?.id.toString() ?? '');
            preferences.setString(
                Keys.token, 'token ${loginResponse.data?.result?.token}');
            await UserController().getUserInfoSink(
                userId: preferences.getString(Keys.userID) ?? '');
            if (!mounted) return;
            hideLoader(context);
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
            showTostMessage(message: loginResponse.data?.message ?? '');
          }
        }
      },
      minWidth: size.width,
      buttonText: ConstStrings.loginStr.toUpperCase(),
    );
  }
}
