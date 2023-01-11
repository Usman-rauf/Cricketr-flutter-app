class UpdateTeamModel {
  int? status;
  bool? error;
  String? message;
  Result? result;

  UpdateTeamModel({this.status, this.error, this.message, this.result});

  UpdateTeamModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  int? id;
  String? teamName;
  String? teamImage;
  String? caption;
  String? wicketKeeper;
  List<String>? player;

  Result(
      {this.id,
      this.teamName,
      this.teamImage,
      this.caption,
      this.wicketKeeper,
      this.player});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    teamImage = json['team_image'];
    caption = json['caption'];
    wicketKeeper = json['wicket_keeper'];
    player = json['player'].cast<String>();
  }
}
