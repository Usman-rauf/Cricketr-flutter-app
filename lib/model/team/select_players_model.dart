import 'package:cricketly/model/match/get_team_player_model.dart';

class SelectPlayersListModel {
  int? status;
  bool? error;
  String message;
  Result1? result;

  SelectPlayersListModel(
      {this.status, this.error, this.message = "", this.result});

  factory SelectPlayersListModel.fromJson(Map<String, dynamic> json) {
    return SelectPlayersListModel(
      status: json['status'],
      error: json['error'],
      message: json['message'],
      result: json['result'] != null ? Result1.fromJson(json['result']) : null,
    );
  }
}

class Result1 {
  TeamInfo? team1;
  TeamInfo? team2;

  Result1({this.team1, this.team2});

  Result1.fromJson(Map<String, dynamic> json) {
    team1 = json['team1'] != null ? TeamInfo.fromJson(json['team1']) : null;
    team2 = json['team2'] != null ? TeamInfo.fromJson(json['team2']) : null;
  }
}

// class Team1 {
//   int? id;
//   String teamName;
//   String teamImage;
//   int? bestScore;
//   int? winCount;
//   int? loseCount;
//   int? totalMatch;
//   int? caption;
//   int? wicketKeeper;
//   List<Players>? player;
//   String createdBy;

//   Team1(
//       {this.id,
//       this.teamName = "",
//       this.teamImage = "",
//       this.bestScore,
//       this.winCount,
//       this.loseCount,
//       this.totalMatch,
//       this.caption,
//       this.wicketKeeper,
//       this.player,
//       this.createdBy = ""});

//   factory Team1.fromJson(Map<String, dynamic> json) {
//     return Team1(
//       id: json['id'],
//       teamName: json['team_name'],
//       teamImage: json['team_image'],
//       bestScore: json['best_score'],
//       winCount: json['win_count'],
//       loseCount: json['lose_count'],
//       totalMatch: json['total_match'],
//       caption: json['caption'],
//       wicketKeeper: json['wicket_keeper'],
//       player: (json["players"] as List).map<Players>((players) {
//         return Players.fromJson(players);
//       }).toList(),
//       createdBy: json['created_by'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['team_name'] = teamName;
//     data['team_image'] = teamImage;
//     data['best_score'] = bestScore;
//     data['win_count'] = winCount;
//     data['lose_count'] = loseCount;
//     data['total_match'] = totalMatch;
//     data['caption'] = caption;
//     data['wicket_keeper'] = wicketKeeper;
//     if (player != null) {
//       data['players'] = player?.map((v) => v.toJson()).toList();
//     }
//     data['created_by'] = createdBy;
//     return data;
//   }
// }

// class Players {
//   int? id;
//   String? username;
//   String? profileImage;

//   Players({this.id, this.username, this.profileImage});

//   Players.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     profileImage = json['profile_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['username'] = username;
//     data['profile_image'] = profileImage;
//     return data;
//   }
// }
