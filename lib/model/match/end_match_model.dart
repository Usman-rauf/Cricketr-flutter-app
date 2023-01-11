class EndMatchModel {
  int? status;
  bool? error;
  String? message;
  Result? result;

  EndMatchModel({this.status, this.error, this.message, this.result});

  EndMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? wnningTeam;
  String? result;

  Result({this.wnningTeam, this.result});

  Result.fromJson(Map<String, dynamic> json) {
    wnningTeam = json['wnning_team'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wnning_team'] = wnningTeam;
    data['result'] = result;
    return data;
  }
}
