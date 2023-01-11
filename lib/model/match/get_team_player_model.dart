class GetTeamPlayerListModel {
  int? status;
  bool? error;
  String? message;
  List<TeamInfo>? playersInfo;

  GetTeamPlayerListModel({
    this.status,
    this.error,
    this.message,
    this.playersInfo,
  });

  GetTeamPlayerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['result'] != null) {
      playersInfo = <TeamInfo>[];
      json['result'].forEach((v) {
        playersInfo!.add(TeamInfo.fromJson(v));
      });
    }
  }
}

class TeamInfo {
  int? id;
  String? teamName;
  int? caption;
  int? wicketKeeper;
  String? teamImage;
  List<Player>? players;

  TeamInfo({
    this.id,
    this.teamName,
    this.caption,
    this.wicketKeeper,
    this.teamImage,
    this.players,
  });

  TeamInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    caption = json['caption'];
    wicketKeeper = json['wicket_keeper'];
    teamImage = json['team_image'];
    if (json['player'] != null) {
      players = <Player>[];
      json['player'].forEach((v) {
        players!.add(Player.fromJson(v));
      });
    }
  }
}

class Player {
  int? id;
  String? username;
  String? profileImage;
  String? playerType;

  Player({this.id, this.username, this.profileImage, this.playerType});

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profileImage = json['profile_image'];
    playerType = json['player_type'];
  }
}
