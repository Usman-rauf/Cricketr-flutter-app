import 'dart:convert';

import 'package:cricketly/constant/api_url.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/model/match/create_match_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:http/http.dart' as http;

class UpdateScoreApi {
  Future<ResponseModel> updateScoreAPi(
      {required Map<String, dynamic> updateScoreData}) async {
    var bodyData = updateScoreData;
    final repsonse = await http.post(
      Uri.parse(ApiUrl.updateScoreUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: bodyData,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel(
        status: true,
      );
    } else {
      return ResponseModel(
        status: false,
      );
    }
  }

  //Undo Score Api
  Future<ResponseModel> undoScrore({required String matchId}) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.undoScoreUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: {'match': matchId},
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel(
        status: true,
      );
    } else {
      return ResponseModel(
        status: false,
      );
    }
  }

//Update Bolwer Api
  Future<ResponseModel> updateBolwerApi(
      {required Map<String, dynamic> updateBolwer}) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.updateBolwerUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: updateBolwer,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel(
        status: true,
      );
    } else {
      return ResponseModel(
        status: false,
      );
    }
  }

//Update Bolwer Api
  Future<ResponseModel> updateBatManApi(
      {required Map<String, dynamic> updateBatsman}) async {
    final repsonse = await http.post(
      Uri.parse(ApiUrl.updateBatsmanUrl),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: updateBatsman,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel(
        status: true,
      );
    } else {
      return ResponseModel(
        status: false,
      );
    }
  }

  //Update Match
  Future<ResponseModel<CreateMatchModel>> updateMatchApi(
      {required Map<String, dynamic> updateMatchInfo,
      required String macthId}) async {
    var bodyData = updateMatchInfo;
    final repsonse = await http.post(
      Uri.parse("${ApiUrl.updateMatchUrl}/$macthId"),
      headers: {'Authorization': preferences.getString(Keys.token) ?? ''},
      body: bodyData,
    );
    if (repsonse.statusCode == 200) {
      return ResponseModel<CreateMatchModel>(
        status: true,
        // data: CreateMatchModel.fromJson(json.decode(repsonse.body)),
      );
    } else {
      return ResponseModel(
        status: false,
        message: json.decode(repsonse.body)['message'],
      );
    }
  }
}
