import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/bakground.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordScreen({super.key, required this.email});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const CommanBackGround(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  CommanAppBar(
                    title: 'Change Password',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.2,
                          ),
                          _buildNewPasswordField(),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          _buildConfirmPasswordField(),
                          SizedBox(
                            height: size.height * 0.06,
                          ),
                          MaterialButton2(
                            buttonText: 'Continue'.toUpperCase(),
                            minWidth: size.width,
                            onPressed: () async {
                              // if (_formKey.currentState!.validate()) {
                              //   showLoader(context);
                              //   final changePasswordResponse =
                              //       await loginController
                              //           .forgotPasswordController(
                              //     email: widget.email,
                              //     password: newPasswordController.text,
                              //     confimPassword:
                              //         confirmPasswordController.text,
                              //   );
                              //   if (changePasswordResponse.data?.statusCode ==
                              //       200) {
                              //     // ignore: use_build_context_synchronously
                              //     hideLoader(context);
                              //     Fluttertoast.showToast(
                              //       msg: 'Change Password successfully!',
                              //     );
                              //     // ignore: use_build_context_synchronously
                              //     Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => const LoginScreen(),
                              //       ),
                              //     );
                              //   } else {
                              //     // ignore: use_build_context_synchronously
                              //     hideLoader(context);
                              //     showCommanDialogs(
                              //       context: context,
                              //       message:
                              //           changePasswordResponse.message ?? '',
                              //     );
                              //   }
                              // }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: newPasswordController,
      cursorColor: ConstColors.white,
      // obscureText: true,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 5) {
          return 'Please enter 6 character password';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: 'Enter new password',
        prefixIcon: Icon(
          Icons.lock,
          color: ConstColors.ofwhite,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: confirmPasswordController,
      cursorColor: ConstColors.white,
      // obscureText: true,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please confirm password';
        }
        if (value != newPasswordController.text) {
          return 'password & confirm password is not match';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: 'Enter Confirm password',
        prefixIcon: Icon(
          Icons.lock,
          color: ConstColors.ofwhite,
        ),
      ),
      onChanged: (value) {},
    );
  }
}
