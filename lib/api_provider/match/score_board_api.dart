import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/score_board_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class ScoreBoardApi {
  Future<ResponseModel<ScoreBoardModel>> scoreBoardApi(
      {required String matchId}) async {
    final repsonse = await http.get(
      Uri.parse("${ApiUrl.scoreCardUrl}/$matchId"),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<ScoreBoardModel>(
        status: true,
        data: ScoreBoardModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
