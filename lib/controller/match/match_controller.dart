import 'package:cricketly/api_provider/match/change_inning_api.dart';
import 'package:cricketly/api_provider/match/check_player_api.dart';
import 'package:cricketly/api_provider/match/create_match_api.dart';
import 'package:cricketly/api_provider/match/end_match_api.dart';
import 'package:cricketly/api_provider/match/get_match_detail_api.dart';
import 'package:cricketly/api_provider/match/get_player_list_api.dart';
import 'package:cricketly/api_provider/match/match_list_api_services.dart';
import 'package:cricketly/api_provider/match/update_match_api.dart';
import 'package:cricketly/model/match/create_match_model.dart';
import 'package:cricketly/model/match/end_match_model.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/model/match/match_detail_model.dart';
import 'package:cricketly/model/match/matchlist_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:rxdart/rxdart.dart';

class MatchController {
  //------------------------------------------------------------------ Api Instant -----------------------------------------------------------------//
  CreateMatchApi createMatchApi = CreateMatchApi();
  MatchListApi matchListApi = MatchListApi();
  GetMatchDetailApi getMatchDetailApi = GetMatchDetailApi();
  UpdateScoreApi updateScoreApi = UpdateScoreApi();
  CheckPlayerApi checkPlayerApi = CheckPlayerApi();
  ChangeInningApi changeInningApi = ChangeInningApi();
  EndMatchApi endMatchApi = EndMatchApi();
  GetTeamPlayerListApi getTeamPlayerListApi = GetTeamPlayerListApi();
  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  BehaviorSubject<ResponseModel<MatchListModel>> matchListController =
      BehaviorSubject<ResponseModel<MatchListModel>>();
  BehaviorSubject<ResponseModel<GetMatchDetailModel>> getMatchDetailController =
      BehaviorSubject<ResponseModel<GetMatchDetailModel>>();
  BehaviorSubject<ResponseModel<GetTeamPlayerListModel>>
      getTeamPlayersController =
      BehaviorSubject<ResponseModel<GetTeamPlayerListModel>>();

//------------------------------------------------------------------ Stream -----------------------------------------------------------------//
  Stream<ResponseModel<MatchListModel>> get getMatchListStream =>
      matchListController.stream;
  Stream<ResponseModel<GetMatchDetailModel>> get getMatchStream =>
      getMatchDetailController.stream;
  Stream<ResponseModel<GetTeamPlayerListModel>> get getTeamPlayersStream =>
      getTeamPlayersController.stream;

  //------------------------------------------------------------------ Sink -----------------------------------------------------------------//

  //Create Match Controller
  Future<ResponseModel<CreateMatchModel>> createMatchSink(
      {required Map<String, dynamic> createMatchInfo}) async {
    ResponseModel<CreateMatchModel> createMatchController =
        await createMatchApi.createMatchApi(createMatchInfo: createMatchInfo);

    return createMatchController;
  }

  //Create Match Controller
  Future<ResponseModel<CreateMatchModel>> updateMatchSink(
      {required Map<String, dynamic> updateMatchInfo,
      required String matchId}) async {
    ResponseModel<CreateMatchModel> updateMatchResponse = await updateScoreApi
        .updateMatchApi(updateMatchInfo: updateMatchInfo, macthId: matchId);

    return updateMatchResponse;
  }

  // Match List Controller
  Future<ResponseModel<MatchListModel>> matchListSink() async {
    ResponseModel<MatchListModel> matchListResponse =
        await matchListApi.getMatchListApi();
    matchListController.sink.add(matchListResponse);
    return matchListResponse;
  }

  //Get Match Controller
  Future<ResponseModel<GetMatchDetailModel>> getMatchSink(
      {required String matchId}) async {
    ResponseModel<GetMatchDetailModel> getMatchResponse =
        await getMatchDetailApi.getMatchDetailApi(matchId: matchId);
    getMatchDetailController.sink.add(getMatchResponse);
    return getMatchResponse;
  }

  //Update Score Controller
  Future<ResponseModel> updateScoreSink(
      {required Map<String, dynamic> updateScoreData}) async {
    ResponseModel updateScoreResponse = await updateScoreApi.updateScoreAPi(
      updateScoreData: updateScoreData,
    );
    return updateScoreResponse;
  }

  //Undo Score Controller
  Future<ResponseModel> undoScroreSink({required String matchId}) async {
    ResponseModel updateScoreResponse = await updateScoreApi.undoScrore(
      matchId: matchId,
    );
    return updateScoreResponse;
  }

  //Upadte Bolwer Controller
  Future<ResponseModel> updateBolwerSink(
      {required Map<String, dynamic> updateBolwer}) async {
    ResponseModel updateScoreResponse =
        await updateScoreApi.updateBolwerApi(updateBolwer: updateBolwer);
    return updateScoreResponse;
  }

  //Update Batsman Score Controller
  Future<ResponseModel> updateBatsmanSink(
      {required Map<String, dynamic> updateBatsman}) async {
    ResponseModel updateScoreResponse =
        await updateScoreApi.updateBatManApi(updateBatsman: updateBatsman);
    return updateScoreResponse;
  }

  //check Player Controller
  Future<ResponseModel> checkPlayerSink(
      {required Map<String, dynamic> teamData}) async {
    ResponseModel updateScoreResponse = await checkPlayerApi.checkPlayerApi(
      checkPlayerData: teamData,
    );

    return updateScoreResponse;
  }

  //change Inning  Controller
  Future<ResponseModel> changeInningSink(
      {required Map<String, dynamic> changeInningData}) async {
    ResponseModel updateScoreResponse = await changeInningApi.changeInningApi(
      changeInningData: changeInningData,
    );

    return updateScoreResponse;
  }

  //End Match Controller
  Future<ResponseModel<EndMatchModel>> endMatchController(
      {required String matchId}) async {
    ResponseModel<EndMatchModel> endMatchReponse =
        await endMatchApi.endMatchApi(
      matchId: matchId,
    );
    return endMatchReponse;
  }

  //Get Team Players Controller
  Future<ResponseModel<GetTeamPlayerListModel>> getTeamPlayerController(
      {required String matchId}) async {
    ResponseModel<GetTeamPlayerListModel> getTeamPlayes =
        await getTeamPlayerListApi.getTeamPlayerListApi(matchId: matchId);
    getTeamPlayersController.sink.add(getTeamPlayes);
    return getTeamPlayes;
  }
}
