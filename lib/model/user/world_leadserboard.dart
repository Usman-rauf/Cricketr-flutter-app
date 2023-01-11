class WorldLeaderBoardModel {
  int? status;
  bool? error;
  String? message;
  List<Result>? result;

  WorldLeaderBoardModel({this.status, this.error, this.message, this.result});

  WorldLeaderBoardModel.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['total_run'] = totalRun;
    data['country'] = country;
    data['total_wicket'] = totalWicket;
    return data;
  }
}
