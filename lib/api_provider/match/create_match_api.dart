import 'dart:convert';
import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/create_match_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class CreateMatchApi {
  //
  Future<ResponseModel<CreateMatchModel>> createMatchApi(
      {required Map<String, dynamic> createMatchInfo}) async {
    var bodyData = createMatchInfo;
    final repsonse = await http.post(
      Uri.parse(ApiUrl.createMatchUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: bodyData,
    );

    print(bodyData);
    if (repsonse.statusCode == 200) {
      return ResponseModel<CreateMatchModel>(
        status: true,
        data: CreateMatchModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
