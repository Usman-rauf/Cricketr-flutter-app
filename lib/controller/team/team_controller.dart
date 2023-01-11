import 'package:cricketly/api_provider/team/check_duplicate_api.dart';
import 'package:cricketly/api_provider/team/create_team_api.dart';
import 'package:cricketly/api_provider/team/player_list_api.dart';
import 'package:cricketly/api_provider/team/select_players_list_api.dart';
import 'package:cricketly/api_provider/team/team_list_api.dart';
import 'package:cricketly/api_provider/team/update_team_api.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/team/check_duplicate_team_model.dart';
import 'package:cricketly/model/team/create_team_model.dart';
import 'package:cricketly/model/team/player_list_model.dart';
import 'package:cricketly/model/team/select_players_model.dart';
import 'package:cricketly/model/team/team_list_model.dart';
import 'package:cricketly/model/team/update_team_model.dart';
import 'package:rxdart/rxdart.dart';

class TeamController {
  //------------------------------------------------------------------ Api Instant -----------------------------------------------------------------//
  PlayerListApi playerListApi = PlayerListApi();
  CreateTeamApi createTeamApi = CreateTeamApi();
  TeamListApi teamListApi = TeamListApi();
  CheckDuplicateTeamApi checkDuplicateTeamApi = CheckDuplicateTeamApi();
  UpdateTeamListApi updateTeamListApi = UpdateTeamListApi();
  SelectPlayersListApi selectPlayersListApi = SelectPlayersListApi();

  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  BehaviorSubject<ResponseModel<PlayerListModel>> playerListController =
      BehaviorSubject<ResponseModel<PlayerListModel>>();
  BehaviorSubject<ResponseModel<TeamListModel>> teamListController =
      BehaviorSubject<ResponseModel<TeamListModel>>();

//------------------------------------------------------------------ Stream -----------------------------------------------------------------//
  Stream<ResponseModel<PlayerListModel>> get getPlayerListStream =>
      playerListController.stream;
  Stream<ResponseModel<TeamListModel>> get teamListStream =>
      teamListController.stream;

  //------------------------------------------------------------------ Sink -----------------------------------------------------------------//

  //Get Player List Controller
  Future<ResponseModel<PlayerListModel>> getPlayerList() async {
    ResponseModel<PlayerListModel> getPlayerListResponse =
        await playerListApi.playerListApi();

    playerListController.sink.add(getPlayerListResponse);
    return getPlayerListResponse;
  }

  //Create Team Controller
  Future<ResponseModel<CreateTeamModel>> createTeamController({
    required Map<String, dynamic> teamPostData,
  }) async {
    ResponseModel<CreateTeamModel> createTeamResponse =
        await createTeamApi.createTeamApi(teamPostData: teamPostData);
    return createTeamResponse;
  }

  //Get Team List Controller
  Future<ResponseModel<TeamListModel>> getTeamList() async {
    ResponseModel<TeamListModel> getTeamListResponse =
        await teamListApi.teamListApi();
    teamListController.sink.add(getTeamListResponse);
    return getTeamListResponse;
  }

  //check duplicate Controller
  Future<ResponseModel<CheckDuplicateModel>> checkDuplicateTeamContoller(
      {required String team1}) async {
    ResponseModel<CheckDuplicateModel> checkDuplicateTeam =
        await checkDuplicateTeamApi.checkDuplicateTeamApi(
      team1: team1,
    );
    return checkDuplicateTeam;
  }

//update team list
  Future<ResponseModel<UpdateTeamModel>> updateTeamList(
      {required int id,
      required String teamName,
      required String teamImage,
      required int caption,
      required int wicketKeeper,
      required List player}) async {
    ResponseModel<UpdateTeamModel> updateTeamListResponse =
        await updateTeamListApi.updateTeamListApi(
      id: id,
      teamName: teamName,
      teamImage: teamImage,
      caption: caption,
      wicketKeeper: wicketKeeper,
      player: player,
    );

    return updateTeamListResponse;
  }

// select team
  Future<ResponseModel<SelectPlayersListModel>> selectTeamList({
    required Map<String, dynamic> teamPostData,
  }) async {
    ResponseModel<SelectPlayersListModel> selectTeamListResponse =
        await selectPlayersListApi.selectPlayersListApi(
      teamPostData: teamPostData,
    );
    return selectTeamListResponse;
  }

  //------------------------------------------------------------------ Dispose  -----------------------------------------------------------------//
  void dispose() {
    playerListController.close();
    teamListController.close();
  }
}
