import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class GetTeamPlayerListApi {
  Future<ResponseModel<GetTeamPlayerListModel>> getTeamPlayerListApi(
      {required String matchId}) async {
    final repsonse = await http.get(
      Uri.parse("${ApiUrl.getTeamPlayerUrl}/$matchId"),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<GetTeamPlayerListModel>(
        status: true,
        data: GetTeamPlayerListModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
