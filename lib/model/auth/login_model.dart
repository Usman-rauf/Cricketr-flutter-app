class LoginModel {
  int? status;
  bool? error;
  String? message;
  bool? isRegister;
  Result? result;

  LoginModel(
      {this.status, this.error, this.message, this.isRegister, this.result});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    isRegister = json['is_register'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
}

class Result {
  int? id;
  String? username;
  String? email;
  String? country;
  String? profileImage;
  String? coverImage;
  String? playerType;
  String? batsmanType;
  String? bowlerType;
  String? deviceToken;
  String? token;

  Result(
      {this.id,
      this.username,
      this.email,
      this.country,
      this.profileImage,
      this.coverImage,
      this.playerType,
      this.batsmanType,
      this.bowlerType,
      this.deviceToken,
      this.token});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    country = json['country'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    playerType = json['player_type'];
    batsmanType = json['batsman_type'];
    bowlerType = json['bowler_type'];
    deviceToken = json['device_token'];
    token = json['token'];
  }
}
