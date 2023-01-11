class CreateMatchModel {
  int? status;
  bool? error;
  String? message;
  Result? result;

  CreateMatchModel({this.status, this.error, this.message, this.result});

  CreateMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  int? id;
  String? team1;
  String? team2;
  String? date;
  String? time;
  String? venue;
  int? umpire;
  int? toseWinner;
  String? tossDecision;
  String? bowler;
  String? over;

  Result(
      {this.id,
      this.team1,
      this.team2,
      this.date,
      this.time,
      this.venue,
      this.umpire,
      this.toseWinner,
      this.tossDecision,
      this.bowler,
      this.over});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    team1 = json['team1'];
    team2 = json['team2'];
    date = json['date'];
    time = json['time'];
    venue = json['venue'];
    umpire = json['umpire'];
    toseWinner = json['tose_winner'];
    tossDecision = json['toss_decision'];
    bowler = json['bowler'];
    over = json['over'];
  }
}
