class ScoreBoardModel {
  int? status;
  bool? error;
  String? message;
  ScoreResult? result;

  ScoreBoardModel({this.status, this.error, this.message, this.result});

  ScoreBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    result =
        json['result'] != null ? ScoreResult.fromJson(json['result']) : null;
  }
}

class ScoreResult {
  String? currentInning;
  String? matchResult;
  Inning1? inning1;
  Inning1? inning2;

  ScoreResult(
      {this.currentInning, this.matchResult, this.inning1, this.inning2});

  ScoreResult.fromJson(Map<String, dynamic> json) {
    currentInning = json['current_inning'];
    matchResult = json['match_result'];
    inning1 =
        json['inning1'] != null ? Inning1.fromJson(json['inning1']) : null;
    inning2 =
        json['inning2'] != null ? Inning1.fromJson(json['inning2']) : null;
  }
}

class Inning1 {
  BattingTeamInning1? battingTeam;
  BowingTeamInning1? bowingTeam;

  Inning1({this.battingTeam, this.bowingTeam});

  Inning1.fromJson(Map<String, dynamic> json) {
    battingTeam = json['batting_team'] != null
        ? BattingTeamInning1.fromJson(json['batting_team'])
        : null;
    bowingTeam = json['bowing_team'] != null
        ? BowingTeamInning1.fromJson(json['bowing_team'])
        : null;
  }
}

class BattingTeamInning1 {
  String? name;
  String? image;
  int? run;
  int? wicket;
  int? currentOver;
  int? currentOverBall;
  List<PlayerList>? playerList;

  BattingTeamInning1(
      {this.name,
      this.image,
      this.run,
      this.wicket,
      this.currentOver,
      this.currentOverBall,
      this.playerList});

  BattingTeamInning1.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    run = json['run'];
    wicket = json['wicket'];
    currentOver = json['current_over'];
    currentOverBall = json['current_over_ball'];
    if (json['player_list'] != null) {
      playerList = <PlayerList>[];
      json['player_list'].forEach((v) {
        playerList!.add(PlayerList.fromJson(v));
      });
    }
  }
}

class PlayerList {
  String? playerName;
  String? playerImage;
  int? run;
  int? ballFaced;
  bool? out;
  String? outBy;
  String? kind;

  PlayerList(
      {this.playerName,
      this.playerImage,
      this.run,
      this.ballFaced,
      this.out,
      this.outBy,
      this.kind});

  PlayerList.fromJson(Map<String, dynamic> json) {
    playerName = json['player_name'];
    playerImage = json['player_image'];
    run = json['run'];
    ballFaced = json['ball_faced'];
    out = json['out'];
    outBy = json['out_by'];
    kind = json['kind'];
  }
}

class BowingTeamInning1 {
  List<BowlerPlayerInfo>? playerList;
  BowingTeamInning1({this.playerList});
  BowingTeamInning1.fromJson(Map<String, dynamic> json) {
    if (json['player_list'] != null) {
      playerList = <BowlerPlayerInfo>[];
      json['player_list'].forEach((v) {
        playerList!.add(BowlerPlayerInfo.fromJson(v));
      });
    }
  }
}

class BowlerPlayerInfo {
  String? playerName;
  String? playerImage;
  int? over;
  int? ball;
  int? maiden;
  int? run;
  int? wicket;

  BowlerPlayerInfo(
      {this.playerName,
      this.playerImage,
      this.over,
      this.ball,
      this.maiden,
      this.run,
      this.wicket});

  BowlerPlayerInfo.fromJson(Map<String, dynamic> json) {
    playerName = json['player_name'];
    playerImage = json['player_image'];
    over = json['over'];
    ball = json['ball'];
    maiden = json['maiden'];
    run = json['run'];
    wicket = json['wicket'];
  }
}
