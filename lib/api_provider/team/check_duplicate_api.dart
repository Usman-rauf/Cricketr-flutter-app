import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/check_duplicate_team_model.dart';
import 'package:http/http.dart' as http;

class CheckDuplicateTeamApi {
  Future<ResponseModel<CheckDuplicateModel>> checkDuplicateTeamApi({
    required String team1,
  }) async {
    var bodyData = {'team1': team1};
    final repsonse = await http.post(
      Uri.parse(ApiUrl.checkDuplicteUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: bodyData,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<CheckDuplicateModel>(
        status: true,
        data: CheckDuplicateModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
