import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/end_match_model.dart';
import 'package:http/http.dart' as http;
import '../../model/response_model.dart';

class EndMatchApi {
  Future<ResponseModel<EndMatchModel>> endMatchApi(
      {required String matchId}) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.endMatchUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: {'match': matchId},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<EndMatchModel>(
          status: true,
          data: EndMatchModel.fromJson(json.decode(repsonse.body)));
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
