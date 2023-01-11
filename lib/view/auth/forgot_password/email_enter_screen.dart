import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/bakground.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class EnterEmailScreen extends StatefulWidget {
  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.08),
                  CommanAppBar(
                    title: 'Forgot Password',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.2,
                        ),
                        _buildEmailField(),
                        SizedBox(
                          height: size.height * 0.08,
                        ),
                        _buildVerifyEmailButton(size),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------------------------------------- Helper Functions --------------------------------------------------------------//
  Widget _buildEmailField() {
    return Center(
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: emailController,
        cursorColor: ConstColors.white,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter username or email';
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: 'Enter email or username',
          prefixIcon: Icon(
            Icons.email,
            color: ConstColors.ofwhite,
          ),
        ),
      ),
    );
  }

  // Login button
  Widget _buildVerifyEmailButton(Size size) {
    return MaterialButton2(
      onPressed: () async {
        // if (_formKey.currentState!.validate()) {
        //   showLoader(context);
        //   final checkEmilResponse = await loginController.checkEmailController(
        //       email: emailController.text.trim());
        //   if (checkEmilResponse.data?.statusCode == 200) {
        //     hideLoader(context);
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return ForgotPasswordScreen(
        //             email: emailController.text.trim(),
        //           );
        //         },
        //       ),
        //     );
        //   } else {
        //     hideLoader(context);
        //     Fluttertoast.showToast(msg: 'Enter valid email');
        //   }
        // }
      },
      buttonText: 'Continue'.toUpperCase(),
      minWidth: size.width,
    );
  }
}
