import 'package:cricketly/api_provider/auth/login_provider.dart';
import 'package:cricketly/model/auth/check_email_model.dart';
import 'package:cricketly/model/auth/check_phone_model.dart';
import 'package:cricketly/model/auth/login_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  //------------------------------------------------------------------ Api Instant -----------------------------------------------------------------//
  LoginApiProvider loginApiProvider = LoginApiProvider();

  //------------------------------------------------------------------ Sink -----------------------------------------------------------------//

  //Email Controller
  Future<ResponseModel<LoginModel>> loginSink(
      Map<String, dynamic> loginPostData) async {
    ResponseModel<LoginModel> loginData =
        await loginApiProvider.loginApi(loginPostData);
    return loginData;
  }

  //check Mobile Number Controller
  Future<ResponseModel<CheckMobileModel>> checkMobileSink({
    required String mobileNumber,
  }) async {
    ResponseModel<CheckMobileModel> checkMobileModel =
        await loginApiProvider.checkPhoneApi(mobileNumber: mobileNumber);
    return checkMobileModel;
  }

  //Check Phone Auth Controller

  //check Email Controller
  Future<ResponseModel<CheckEmailModel>> checkEmailSink({
    required String email,
  }) async {
    ResponseModel<CheckEmailModel> loginData =
        await loginApiProvider.checkEmailApi(email: email);
    return loginData;
  }

  //Social controller
  Future<ResponseModel<LoginModel>> socialSink({
    required String uuid,
    required String deviceToken,
  }) async {
    ResponseModel<LoginModel> loginData = await loginApiProvider.socialLoginApi(
      uuid: uuid,
      deviceToken: deviceToken,
    );
    return loginData;
  }

  //------------------------------------------------------------------ Firebase Controller -----------------------------------------------------------------//

  // Phone login
  Future<ResponseModel<UserCredential>> phoneController(
      {required String verificationId, required String otpText}) async {
    ResponseModel<UserCredential> phoneResponse = await loginApiProvider
        .phoneSignIn(otpText: otpText, verificationId: verificationId);
    return phoneResponse;
  }

  // Google Login
  Future<ResponseModel<UserCredential>> signInWithGoogleController() async {
    ResponseModel<UserCredential> googleRepsonse =
        await loginApiProvider.signInWithGoogle();
    return googleRepsonse;
  }

  // //Facebook Login
  // Future<ResponseModel<UserCredential>> signInWithFacebookController() async {
  //   ResponseModel<UserCredential> facebookResponse =
  //       await loginApiProvider.signInWithFacebook();
  //   return facebookResponse;
  // }

  //Apple Login
  Future<ResponseModel<UserCredential>> signInWithAppleController() async {
    ResponseModel<UserCredential> appleResponse =
        await loginApiProvider.signInWithApple();
    return appleResponse;
  }
}
