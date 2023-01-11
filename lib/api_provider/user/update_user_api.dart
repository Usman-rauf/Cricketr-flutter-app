import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/auth/login_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class UpdateUserApi {
  Future<ResponseModel<LoginModel>> updateUserApi({
    required Map<String, dynamic> updateUserData,
    required int id,
  }) async {
    final repsonse = await http.post(
      Uri.parse("${ApiUrl.userUpdateUrl}/$id"),
      body: updateUserData,
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<LoginModel>(
        status: true,
        data: LoginModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
