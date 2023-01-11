import 'dart:convert';
import 'dart:io';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/model/auth/login_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

import '../../constant/prefrance.dart';

class CreateUserApi {
  Future<ResponseModel<LoginModel>> createUserApi({
    required Map<String, dynamic> createUserPostData,
    required File profileImage,
  }) async {
    if (profileImage.path == "") {
      var bodayData = createUserPostData;
      final repsonse = await http.post(
        Uri.parse(ApiUrl.registerUrl),
        body: bodayData,
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
          message: json.decode(repsonse.body)['message'].toString(),
        );
      }
    } else {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.registerUrl));

      request.fields.addAll({
        'username': createUserPostData['username'],
        'email': createUserPostData['email'],
        'password': createUserPostData['password'],
        'profile_image_url': createUserPostData['profile_image_url'],
        'player_type': createUserPostData['player_type'],
        'batsman_type': createUserPostData['batsman_type'],
        'bowler_type': createUserPostData['bowler_type'],
        'country': createUserPostData['country'],
        'uuid': createUserPostData['uuid'],
        'mobile_no': createUserPostData['mobile_no'],
        "jersey_no": createUserPostData['jersey_no'],
      });
      request.files.add(await http.MultipartFile.fromPath(
          'profile_image', profileImage.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        return ResponseModel(
          status: true,
          data: LoginModel.fromJson(
            json.decode(data),
          ),
        );
      } else {
        var data = await response.stream.bytesToString();

        return ResponseModel(
          status: false,
          message: json.decode(data)["message"],
        );
      }
    }
  }
}
