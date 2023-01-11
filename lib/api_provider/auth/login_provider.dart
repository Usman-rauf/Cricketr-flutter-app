import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/constant/strings.dart';
import 'package:cricketly/model/auth/check_email_model.dart';
import 'package:cricketly/model/auth/check_phone_model.dart';
import 'package:cricketly/model/auth/login_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginApiProvider {
  FirebaseAuth auth = FirebaseAuth.instance;
  late GoogleSignInAuthentication googleSignInAuthentication;
  // FacebookLogin facebookLogin = FacebookLogin();

  //------------------------------------------------------------------ Phone Auth -----------------------------------------------------------------//

  Future<ResponseModel<UserCredential>> phoneSignIn(
      {required String verificationId, required String otpText}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otpText));
      if (userCredential.user != null) {
        return ResponseModel<UserCredential>(
            status: true, data: userCredential);
      } else {
        return ResponseModel(status: false, message: 'Something want wrong');
      }
    } catch (e) {
      return ResponseModel(status: false, message: e.toString());
    }
  }

  Future<ResponseModel<CheckMobileModel>> checkPhoneApi({
    required String mobileNumber,
  }) async {
    final bodyData = {"mobile_no": mobileNumber};
    final response =
        await http.post(Uri.parse(ApiUrl.checkMobileUrl), body: bodyData);

    if (response.statusCode == 200) {
      return ResponseModel(
        status: true,
        data: CheckMobileModel.fromJson(
          json.decode(response.body),
        ),
      );
    } else {
      return ResponseModel(
        status: false,
        data: CheckMobileModel.fromJson(
          json.decode(response.body),
        ),
      );
    }
  }

  //------------------------------------------------------------------ Email & Username Login -----------------------------------------------------------------//
  Future<ResponseModel<LoginModel>> loginApi(
      Map<String, dynamic> loginPostData) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.loginUrl),
      body: loginPostData,
    );
    if (repsonse.statusCode == 200) {
      preferences.setString(Keys.userData, repsonse.body);
      return ResponseModel<LoginModel>(
        status: true,
        data: LoginModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        data: LoginModel.fromJson(json.decode(repsonse.body)),
      );
    }
  }

// Check Email Api
  Future<ResponseModel<CheckEmailModel>> checkEmailApi({
    required String email,
  }) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.checkEmailUrl),
      body: {'email': email},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<CheckEmailModel>(
        status: true,
        data: CheckEmailModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }

//------------------------------------------------------------------ Social Login -----------------------------------------------------------------//

  Future<ResponseModel<LoginModel>> socialLoginApi({
    required String uuid,
    required String deviceToken,
  }) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.loginUrl),
      body: {'uuid': uuid, 'login_type': 'social', 'device_token': deviceToken},
    );
    if (repsonse.statusCode == 200) {
      preferences.setString(Keys.userData, repsonse.body);
      return ResponseModel<LoginModel>(
        status: true,
        data: LoginModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        data: LoginModel.fromJson(json.decode(repsonse.body)),
      );
    }
  }

  //------------------------------------------------------------------ Firebase Login -----------------------------------------------------------------//

  // Google Login
  Future<ResponseModel<UserCredential>> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return ResponseModel<UserCredential>(status: true, data: userCredential);
    } else {
      return ResponseModel<UserCredential>(
          status: false, message: "Something want wrong");
    }
  }

  // // Facebook login
  // Future<ResponseModel<UserCredential>> signInWithFacebook() async {
  //   try {
  //     final FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(
  //         permissions: [
  //           FacebookPermission.publicProfile,
  //           FacebookPermission.email
  //         ]);
  //     if (facebookLoginResult.status.name == 'success') {
  //       final AuthCredential facebookCredential =
  //           FacebookAuthProvider.credential(
  //               facebookLoginResult.accessToken!.token);
  //       final userCredential =
  //           await auth.signInWithCredential(facebookCredential);
  //       return ResponseModel<UserCredential>(
  //           status: true, data: userCredential);
  //     } else {
  //       return ResponseModel(
  //           status: false, message: ConstStrings.somethingWorngMessage);
  //     }
  //   } on FirebaseAuthException {
  //     return ResponseModel<UserCredential>(
  //       status: false,
  //       message: ConstStrings.somethingWorngMessage,
  //     );
  //   }
  // }

  // Apple login
  Future<ResponseModel<UserCredential>> signInWithApple() async {
    AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );
    final appleCredential = OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
    final userCredential = await auth.signInWithCredential(appleCredential);
    if (credential.userIdentifier != null) {
      return ResponseModel(data: userCredential, status: true);
    } else {
      return ResponseModel(
          status: false, message: ConstStrings.somethingWorngMessage);
    }
  }
}
