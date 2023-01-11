class MatchListModel {
  int? status;
  bool? error;
  String? message;
  MatchListData? matchResult;

  MatchListModel({this.status, this.error, this.message, this.matchResult});

  MatchListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    matchResult =
        json['result'] != null ? MatchListData.fromJson(json['result']) : null;
  }
}

class MatchListData {
  List<Previous>? previous;
  List<Previous>? live;
  List<Upcomming>? upcomming;

  MatchListData({this.previous, this.live, this.upcomming});

  MatchListData.fromJson(Map<String, dynamic> json) {
    if (json['previous'] != null) {
      previous = <Previous>[];
      json['previous'].forEach((v) {
        previous!.add(Previous.fromJson(v));
      });
    }
    if (json['live'] != null) {
      live = <Previous>[];
      json['live'].forEach((v) {
        live!.add(Previous.fromJson(v));
      });
    }
    if (json['upcomming'] != null) {
      upcomming = <Upcomming>[];
      json['upcomming'].forEach((v) {
        upcomming!.add(Upcomming.fromJson(v));
      });
    }
  }
}

class Previous {
  int? matchId;
  String? result;
  int? totalOver;
  String? battingTeam;
  int? ball;
  BattingTeamPlayers? battingTeamPlayers;
  BattingTeamPlayers? bowingTeamPlayers;
  int? umpireId;

  Previous({
    this.matchId,
    this.result,
    this.totalOver,
    this.battingTeam,
    this.ball,
    this.battingTeamPlayers,
    this.bowingTeamPlayers,
    this.umpireId,
  });

  Previous.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'];
    result = json['result'];
    totalOver = json['total_over'];
    battingTeam = json['batting_team'];
    ball = json['ball'];
    battingTeamPlayers = json['batting_team_players'] != null
        ? BattingTeamPlayers.fromJson(json['batting_team_players'])
        : null;
    bowingTeamPlayers = json['bowing_team_players'] != null
        ? BattingTeamPlayers.fromJson(json['bowing_team_players'])
        : null;
    umpireId = json['umpire_id'];
  }
}

class BattingTeamPlayers {
  String? name;
  String? image;
  int? run;
  int? wicket;
  int? over;
  int? ballNumber;

  BattingTeamPlayers(
      {this.name,
      this.image,
      this.run,
      this.wicket,
      this.over,
      this.ballNumber});

  BattingTeamPlayers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    run = json['run'];
    wicket = json['wicket'];
    over = json['over'];
    ballNumber = json['ball_number'];
  }
}

class Upcomming {
  int? id;
  String? result;
  int? team1Id;
  String? team1Name;
  String? team1Image;
  int? team2Id;
  String? team2Name;
  String? team2Image;
  String? date;
  String? time;
  int? umpireId;
  int? over;
  String? venue;

  Upcomming({
    this.id,
    this.result,
    this.team1Id,
    this.team1Name,
    this.team1Image,
    this.team2Id,
    this.team2Name,
    this.team2Image,
    this.date,
    this.umpireId,
    this.time,
    this.over,
    this.venue,
  });

  Upcomming.fromJson(Map<String, dynamic> json) {
    id = json['match_id'];
    result = json['result'];
    team1Id = json['team1_id'];
    team1Name = json['team1_name'];
    team1Image = json['team1_image'];
    team2Id = json['team2_id'];
    team2Name = json['team2_name'];
    team2Image = json['team2_image'];
    date = json['date'];
    time = json['time'];
    umpireId = json['umpire_id'];
    over = json['over'];
    venue = json['venue'];
  }
}
