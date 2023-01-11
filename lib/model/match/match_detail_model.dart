class GetMatchDetailModel {
  int? status;
  bool? error;
  String? message;
  MacthDetailResult? macthDetailResult;

  GetMatchDetailModel(
      {this.status, this.error, this.message, this.macthDetailResult});

  GetMatchDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    macthDetailResult = json['result'] != null
        ? MacthDetailResult.fromJson(json['result'])
        : null;
  }
}

class MacthDetailResult {
  bool? isOver;
  bool? isUmpire;
  bool? isInning;
  bool? matchEnd;
  List<LastOver>? lastOver;
  BattingTeam? battingTeam;
  BattingTeam? bowingTeam;
  String? onStriker;
  String? offStriker;
  int? umpireId;
  String? umpireName;
  String? umpireImage;
  String? date;
  String? time;
  int? over;
  int? run;
  int? wicket;
  String? venue;
  String? toseWinner;
  String? tossDecision;
  List<Opener>? opener;
  String? battingTeamName;
  String? bowingTeamName;
  Bowler? bowler;
  int? ball;

  MacthDetailResult(
      {this.isOver,
      this.lastOver,
      this.isInning,
      this.matchEnd,
      this.isUmpire,
      this.onStriker,
      this.offStriker,
      this.battingTeam,
      this.bowingTeam,
      this.umpireId,
      this.umpireName,
      this.umpireImage,
      this.date,
      this.time,
      this.over,
      this.run,
      this.wicket,
      this.venue,
      this.toseWinner,
      this.tossDecision,
      this.opener,
      this.battingTeamName,
      this.bowingTeamName,
      this.bowler,
      this.ball});

  MacthDetailResult.fromJson(Map<String, dynamic> json) {
    isOver = json['is_over'];
    if (json['last_over'] != null) {
      lastOver = <LastOver>[];
      json['last_over'].forEach((v) {
        lastOver!.add(LastOver.fromJson(v));
      });
    }
    battingTeam = json['batting_team'] != null
        ? BattingTeam.fromJson(json['batting_team'])
        : null;
    bowingTeam = json['bowing_team'] != null
        ? BattingTeam.fromJson(json['bowing_team'])
        : null;
    umpireId = json['umpire_id'];
    isUmpire = json['is_umpire'];
    matchEnd = json['match_end'];
    isInning = json['is_inning'];
    onStriker = json['on_striker'];
    offStriker = json['off_striker'];
    umpireName = json['umpire_name'];
    umpireImage = json['umpire_image'];
    date = json['date'];
    time = json['time'];
    over = json['over'];
    run = json['run'];
    wicket = json['wicket'];
    venue = json['venue'];
    toseWinner = json['tose_winner'];
    tossDecision = json['toss_decision'];
    if (json['opener'] != null) {
      opener = <Opener>[];
      json['opener'].forEach((v) {
        opener!.add(Opener.fromJson(v));
      });
    }
    battingTeamName = json['batting_team_name'];
    bowingTeamName = json['bowing_team_name'];

    bowler = json['bowler'] != null ? Bowler.fromJson(json['bowler']) : null;
    ball = json['ball'];
  }
}

class LastOver {
  int? ballnumber;
  int? totalRun;
  int? extrasRun;
  String? extraType;
  int? overs;
  bool? isWicketDelivery;
  String? playerOut;

  LastOver(
      {this.ballnumber,
      this.totalRun,
      this.extrasRun,
      this.extraType,
      this.overs,
      this.isWicketDelivery,
      this.playerOut});

  LastOver.fromJson(Map<String, dynamic> json) {
    ballnumber = json['ballnumber'];
    totalRun = json['total_run'];
    extrasRun = json['extras_run'];
    extraType = json['extra_type'];
    overs = json['overs'];
    isWicketDelivery = json['isWicketDelivery'];
    playerOut = json['player_out'];
  }
}

class BattingTeam {
  int? id;
  String? name;
  String? image;
  String? caption;
  int? run;
  int? wicket;
  int? over;
  int? currentOverBall;
  List<PlayerList>? playerList;

  BattingTeam(
      {this.id,
      this.name,
      this.image,
      this.caption,
      this.run,
      this.wicket,
      this.over,
      this.currentOverBall,
      this.playerList});

  BattingTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    caption = json['caption'];
    run = json['run'];
    wicket = json['wicket'];
    over = json['over'];
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
  int? playerId;
  String? playerName;
  String? playerImage;
  int? run;
  int? ballFaced;
  int? four;
  int? six;
  bool? out;

  PlayerList(
      {this.playerId,
      this.playerName,
      this.playerImage,
      this.run,
      this.ballFaced,
      this.four,
      this.six,
      this.out});

  PlayerList.fromJson(Map<String, dynamic> json) {
    playerId = json['player_id'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    run = json['run'];
    ballFaced = json['ball_faced'];
    four = json['four'];
    six = json['six'];
    out = json['out'];
  }
}

class Opener {
  int? id;
  String? username;
  String? profileImage;
  int? run;
  int? ballFaced;
  int? four;
  int? six;
  bool? out;

  Opener(
      {this.id,
      this.username,
      this.profileImage,
      this.run,
      this.ballFaced,
      this.four,
      this.six,
      this.out});

  Opener.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profileImage = json['profile_image'];
    run = json['run'];
    ballFaced = json['ball_faced'];
    four = json['four'];
    six = json['six'];
    out = json['out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['profile_image'] = profileImage;
    data['run'] = run;
    data['ball_faced'] = ballFaced;
    data['four'] = four;
    data['six'] = six;
    data['out'] = out;
    return data;
  }
}

class Bowler {
  int? bowlerId;
  String? bowlerName;
  String? bowlerImage;
  double? over;
  int? ball;
  int? run;
  int? wicket;
  int? currentOver;
  List<BallLog>? ballLog;

  Bowler(
      {this.bowlerId,
      this.bowlerName,
      this.bowlerImage,
      this.over,
      this.ball,
      this.run,
      this.wicket,
      this.currentOver,
      this.ballLog});

  Bowler.fromJson(Map<String, dynamic> json) {
    bowlerId = json['bowler_id'];
    bowlerName = json['bowler_name'];
    bowlerImage = json['bowler_image'];
    over = json['over'];
    ball = json['ball'];
    run = json['run'];
    wicket = json['wicket'];
    currentOver = json['current_over'];
    if (json['ball_log'] != null) {
      ballLog = <BallLog>[];
      json['ball_log'].forEach((v) {
        ballLog!.add(BallLog.fromJson(v));
      });
    }
  }
}

class BallLog {
  int? ballnumber;
  int? totalRun;
  int? extrasRun;
  String? extraType;
  int? overs;
  bool? isWicketDelivery;
  String? playerOut;

  BallLog(
      {this.ballnumber,
      this.totalRun,
      this.extrasRun,
      this.extraType,
      this.overs,
      this.isWicketDelivery,
      this.playerOut});

  BallLog.fromJson(Map<String, dynamic> json) {
    ballnumber = json['ballnumber'];
    totalRun = json['total_run'];
    extrasRun = json['extras_run'];
    extraType = json['extra_type'];
    overs = json['overs'];
    isWicketDelivery = json['isWicketDelivery'];
    playerOut = json['player_out'];
  }
}
