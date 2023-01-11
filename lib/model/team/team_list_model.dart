import 'package:cricketly/model/match/get_team_player_model.dart';

class TeamListModel {
  int? status;
  bool? error;
  String? message;
  List<TeamInfo>? result;

  TeamListModel({this.status, this.error, this.message, this.result});

  TeamListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['result'] != null) {
      result = <TeamInfo>[];
      json['result'].forEach((v) {
        result!.add(TeamInfo.fromJson(v));
      });
    }
  }
}
