import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/create_team_model.dart';
import 'package:http/http.dart' as http;

class CreateTeamApi {
  Future<ResponseModel<CreateTeamModel>> createTeamApi({
    required Map<String, dynamic> teamPostData,
  }) async {
    var bodyData = teamPostData;
    final repsonse = await http.post(
      Uri.parse(ApiUrl.createTeamUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: bodyData,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<CreateTeamModel>(
        status: true,
        data: CreateTeamModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
