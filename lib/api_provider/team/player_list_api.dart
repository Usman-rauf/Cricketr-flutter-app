import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/player_list_model.dart';
import 'package:http/http.dart' as http;

class PlayerListApi {
  Future<ResponseModel<PlayerListModel>> playerListApi() async {
    final repsonse = await http.get(Uri.parse(ApiUrl.playerListUrl),
        headers: {'Authorization': preferences.getString(Keys.token) ?? ''});
    if (repsonse.statusCode == 200) {
      return ResponseModel<PlayerListModel>(
        status: true,
        data: PlayerListModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
      );
    }
  }
}
