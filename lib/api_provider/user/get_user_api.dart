import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/user/get_user_info_model.dart';
import 'package:http/http.dart' as http;

class GetUserInfoApi {
  Future<ResponseModel<GetUserInfoModel>> getUserInfoApi(
      {required String userId}) async {
    final repsonse = await http.get(
      Uri.parse("${ApiUrl.getUserUrl}/$userId"),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      preferences.setString(Keys.userData, repsonse.body);
      return ResponseModel<GetUserInfoModel>(
        status: true,
        data: GetUserInfoModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
