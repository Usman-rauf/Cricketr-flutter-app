import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/user/leaderboard_model.dart';
import 'package:cricketly/model/user/world_leadserboard.dart';
import 'package:http/http.dart' as http;

class LeaderBoardApi {
  Future<ResponseModel<LeaderBoardModel>> laderBoardApi() async {
    final repsonse = await http.get(
      Uri.parse(ApiUrl.leaderBoardCountryUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      preferences.setString(Keys.userData, repsonse.body);
      return ResponseModel<LeaderBoardModel>(
        status: true,
        data: LeaderBoardModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }

  Future<ResponseModel<WorldLeaderBoardModel>> worldLeadrBoard() async {
    final repsonse = await http.get(
      Uri.parse(ApiUrl.worldLeaderBoardUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      preferences.setString(Keys.userData, repsonse.body);
      return ResponseModel<WorldLeaderBoardModel>(
        status: true,
        data: WorldLeaderBoardModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
