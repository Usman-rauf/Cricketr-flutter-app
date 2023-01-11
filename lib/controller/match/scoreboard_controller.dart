import 'package:cricketly/api_provider/match/score_board_api.dart';
import 'package:cricketly/model/match/score_board_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:rxdart/rxdart.dart';

class ScorebardContoller {
  //------------------------------------------------------------------ Api Instant -----------------------------------------------------------------//
  ScoreBoardApi scoreBoardApi = ScoreBoardApi();

  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  BehaviorSubject<ResponseModel<ScoreBoardModel>> scoreBoardController =
      BehaviorSubject<ResponseModel<ScoreBoardModel>>();

//------------------------------------------------------------------ Stream -----------------------------------------------------------------//
  Stream<ResponseModel<ScoreBoardModel>> get getScoreBoaerdStream =>
      scoreBoardController.stream;

  //------------------------------------------------------------------ Sink -----------------------------------------------------------------//

  //Get Score Board Controller
  Future<ResponseModel<ScoreBoardModel>> getScoreBoard(
      {required String matchId}) async {
    ResponseModel<ScoreBoardModel> getScoreBorad =
        await scoreBoardApi.scoreBoardApi(matchId: matchId);
    scoreBoardController.sink.add(getScoreBorad);
    return getScoreBorad;
  }
}
