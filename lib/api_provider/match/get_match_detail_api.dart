import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/match_detail_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class GetMatchDetailApi {
  Future<ResponseModel<GetMatchDetailModel>> getMatchDetailApi(
      {required String matchId}) async {
    final repsonse = await http.get(
      Uri.parse("${ApiUrl.getMatchDetailUrl}/$matchId"),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<GetMatchDetailModel>(
        status: true,
        data: GetMatchDetailModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
