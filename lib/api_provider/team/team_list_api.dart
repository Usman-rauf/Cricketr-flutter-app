import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/team_list_model.dart';
import 'package:http/http.dart' as http;

class TeamListApi {
  Future<ResponseModel<TeamListModel>> teamListApi() async {
    final repsonse = await http.get(Uri.parse(ApiUrl.teamListUrl),
        headers: {'Authorization': preferences.getString(Keys.token) ?? ''});
    if (repsonse.statusCode == 200) {
      return ResponseModel<TeamListModel>(
        status: true,
        data: TeamListModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
