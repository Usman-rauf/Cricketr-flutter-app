class LeaderBoardModel {
  int? status;
  bool? error;
  String? message;
  List<Result>? result;

  LeaderBoardModel({this.status, this.error, this.message, this.result});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }
}

class Result {
  int? id;
  String? username;
  int? totalRun;
  String? country;
  int? totalWicket;

  Result(
      {this.id, this.username, this.totalRun, this.country, this.totalWicket});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    totalRun = json['total_run'];
    country = json['country'];
    totalWicket = json['total_wicket'];
  }
}
