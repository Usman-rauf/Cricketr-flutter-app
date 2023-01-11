import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/create_match_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class CheckPlayerApi {
  Future<ResponseModel<CreateMatchModel>> checkPlayerApi(
      {required Map<String, dynamic> checkPlayerData}) async {
    var bodyData = checkPlayerData;
    final repsonse = await http.post(
      Uri.parse(ApiUrl.checkPlayerUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: bodyData,
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
