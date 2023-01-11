class PlayerListModel {
  int? status;
  bool? error;
  String? message;
  PlayerListData? playerListData;

  PlayerListModel({this.status, this.error, this.message, this.playerListData});

  PlayerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    playerListData =
        json['result'] != null ? PlayerListData.fromJson(json['result']) : null;
  }
}

class PlayerListData {
  List<BATSMAN>? bATSMAN;
  List<BATSMAN>? bOWLER;

  PlayerListData({this.bATSMAN, this.bOWLER});

  PlayerListData.fromJson(Map<String, dynamic> json) {
    if (json['BATSMAN'] != null) {
      bATSMAN = <BATSMAN>[];
      json['BATSMAN'].forEach((v) {
        bATSMAN!.add(BATSMAN.fromJson(v));
      });
    }
    if (json['BOWLER'] != null) {
      bOWLER = <BATSMAN>[];
      json['BOWLER'].forEach((v) {
        bOWLER!.add(BATSMAN.fromJson(v));
      });
    }
  }
}

class BATSMAN {
  int? id;
  String? username;
  String? profileImage;
  String? playerType;
  bool isPlayerSelected = false;

  BATSMAN({
    this.id,
    this.username,
    this.profileImage,
    this.playerType,
    this.isPlayerSelected = false,
  });

  BATSMAN.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profileImage = json['profile_image'];
    playerType = json['player_type'];
    isPlayerSelected = json['isPlayerSelected'] ?? false;
  }
}
