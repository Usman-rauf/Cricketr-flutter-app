import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class ChangeInningApi {
  Future<ResponseModel> changeInningApi(
      {required Map<String, dynamic> changeInningData}) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.changeInningUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: changeInningData,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel(
        status: true,
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
