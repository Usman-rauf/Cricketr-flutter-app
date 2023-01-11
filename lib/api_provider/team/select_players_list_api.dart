import 'dart:convert';
import 'package:cricketly/constant/prefrance.dart';
import '../../constant/api_url.dart';
import '../../model/response_model.dart';
import '../../model/team/select_players_model.dart';
import 'package:http/http.dart' as http;

class SelectPlayersListApi {
  Future<ResponseModel<SelectPlayersListModel>> selectPlayersListApi({
    required Map<String, dynamic> teamPostData,
  }) async {
    final repsonse = await http.post(Uri.parse(ApiUrl.selectPlayerUrl),
        body: teamPostData,
        headers: {'Authorization': preferences.getString(Keys.token) ?? ''});
    if (repsonse.statusCode == 200) {
      return ResponseModel<SelectPlayersListModel>(
        status: true,
        data: SelectPlayersListModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
