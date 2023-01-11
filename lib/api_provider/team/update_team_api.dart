import 'dart:convert';

import '../../constant/api_url.dart';
import '../../model/response_model.dart';
import '../../model/team/update_team_model.dart';
import 'package:http/http.dart' as http;

class UpdateTeamListApi {
  Future<ResponseModel<UpdateTeamModel>> updateTeamListApi(
      {required int id,
      required String teamName,
      required String teamImage,
      required int caption,
      required int wicketKeeper,
      required List player}) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.teamUpdateUrl + id.toString()),
      body: {
        "team_name": teamName,
        "team_image": teamImage,
        "caption": caption.toString(),
        "wicket_keeper": wicketKeeper.toString(),
        "player": player.toString(),
      },
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<UpdateTeamModel>(
        status: true,
        data: UpdateTeamModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
