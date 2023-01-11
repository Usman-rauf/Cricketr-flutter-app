import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:cricketly/controller/auth/login_controller.dart';
import 'package:cricketly/view/auth/create_player_profile_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:cricketly/widgtes/dialogs.dart';
import 'package:cricketly/widgtes/loader.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//
  LoginController loginController = LoginController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //------------------------------------------------------------------ Variables -----------------------------------------------------------------//

  final _formKey = GlobalKey<FormState>();

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
                  title: 'Create Account',
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
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      _buildConfirmPasswordField(size),
                      SizedBox(
                        height: size.height * 0.06,
                      ),
                      _buildLoginButton(size),
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

  Widget _buildConfirmPasswordField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Password',
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
          controller: confirmPasswordController,
          cursorColor: ConstColors.black,
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please confirm password';
            }
            if (value != passwordController.text) {
              return 'password & confirm password is not match';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter confirm password',
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
          if (!mounted) return;
          showLoader(context);
          var checkEmailResponse = await loginController.checkEmailSink(
              email: emailController.text.trim());
          if (checkEmailResponse.data?.status == 200) {
            if (!mounted) return;
            hideLoader(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePlayerProfileScreen(
                  password: passwordController.text.trim(),
                  email: emailController.text.trim(),
                  isEmailAccount: false,
                  moileNumber: '',
                ),
              ),
            );
          } else {
            if (!mounted) return;
            hideLoader(context);
            showTostMessage(
              message: checkEmailResponse.message ?? '',
            );
          }
        }
      },
      minWidth: size.width,
      buttonText: 'Continue'.toUpperCase(),
    );
  }
}
