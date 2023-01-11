class CheckDuplicateModel {
  int? status;
  bool? error;
  String? message;
  List<CheckTeamData>? checkTeamsData;

  CheckDuplicateModel(
      {this.status, this.error, this.message, this.checkTeamsData});

  CheckDuplicateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['result'] != null) {
      checkTeamsData = <CheckTeamData>[];
      json['result'].forEach((v) {
        checkTeamsData!.add(CheckTeamData.fromJson(v));
      });
    }
  }
}

class CheckTeamData {
  int? id;
  String? teamName;
  String? teamImage;
  bool? isDuplicated;

  CheckTeamData({this.id, this.teamName, this.teamImage, this.isDuplicated});

  CheckTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    teamImage = json['team_image'];
    isDuplicated = json['is_duplicated'];
  }
}
