import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/matchlist_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class MatchListApi {
  Future<ResponseModel<MatchListModel>> getMatchListApi() async {
    final repsonse = await http.get(
      Uri.parse(ApiUrl.matchListUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<MatchListModel>(
        status: true,
        data: MatchListModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
