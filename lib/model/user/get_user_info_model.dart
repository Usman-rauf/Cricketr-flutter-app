class GetUserInfoModel {
  int? status;
  bool? error;
  String? message;
  UserData? userData;

  GetUserInfoModel({this.status, this.error, this.message, this.userData});

  GetUserInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    userData =
        json['result'] != null ? UserData.fromJson(json['result']) : null;
  }
}

class UserData {
  int? id;
  String? lastLogin;
  bool? isSuperuser;
  String? firstName;
  String? lastName;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? uuid;
  String? username;
  String? email;
  String? mobileNo;
  String? password;
  String? address;
  String? country;
  String? deviceToken;
  String? profileImage;
  String? coverImage;
  String? playerType;
  String? batsmanType;
  String? bowlerType;
  int? totalInnings;
  int? totalMatches;
  int? totalRun;
  int? totalWicket;
  int? totalBall;
  int? total4;
  int? total6;
  int? total50;
  int? total100;
  bool? isSocial;
  List<void>? groups;
  List<void>? userPermissions;
  String? jerseyNo;

  UserData({
    this.id,
    this.lastLogin,
    this.isSuperuser,
    this.firstName,
    this.lastName,
    this.isStaff,
    this.isActive,
    this.dateJoined,
    this.uuid,
    this.username,
    this.email,
    this.mobileNo,
    this.password,
    this.address,
    this.jerseyNo,
    this.country,
    this.deviceToken,
    this.profileImage,
    this.coverImage,
    this.playerType,
    this.batsmanType,
    this.bowlerType,
    this.totalInnings,
    this.totalMatches,
    this.totalRun,
    this.totalWicket,
    this.totalBall,
    this.total4,
    this.total6,
    this.total50,
    this.total100,
    this.isSocial,
    this.groups,
    this.userPermissions,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    uuid = json['uuid'];
    username = json['username'];
    email = json['email'];
    jerseyNo = json['jersey_no'];
    mobileNo = json['mobile_no'];
    password = json['password'];
    address = json['address'];
    country = json['country'];
    deviceToken = json['device_token'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    playerType = json['player_type'];
    batsmanType = json['batsman_type'];
    bowlerType = json['bowler_type'];
    totalInnings = json['total_innings'];
    totalMatches = json['total_matches'];
    totalRun = json['total_run'];
    totalWicket = json['total_wicket'];
    totalBall = json['total_ball'];
    total4 = json['total_4'];
    total6 = json['total_6'];
    total50 = json['total_50'];
    total100 = json['total_100'];
    isSocial = json['is_social'];
    // if (json['groups'] != null) {
    //   groups = <Null>[];
    //   json['groups'].forEach((v) {
    //     groups!.add(void.fromJson(v));
    //   });
    // }
    // if (json['user_permissions'] != null) {
    //   userPermissions = <Null>[];
    //   json['user_permissions'].forEach((v) {
    //     userPermissions!.add(void.fromJson(v));
    //   });
    // }
    // groups = List<dynamic>.from(json["groups"].map((x) => x));
    // userPermissions =
    //     List<dynamic>.from(json["user_permissions"].map((x) => x));
  }
}
