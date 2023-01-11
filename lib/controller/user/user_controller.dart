import 'dart:io';
import 'package:cricketly/api_provider/user/create_user_api.dart';
import 'package:cricketly/api_provider/user/get_user_api.dart';
import 'package:cricketly/api_provider/user/leader_board_api.dart';
import 'package:cricketly/api_provider/user/update_user_api.dart';
import 'package:cricketly/model/auth/login_model.dart';
import 'package:cricketly/model/response_model.dart';
import 'package:cricketly/model/user/get_user_info_model.dart';
import 'package:cricketly/model/user/leaderboard_model.dart';
import 'package:cricketly/model/user/world_leadserboard.dart';
import 'package:rxdart/rxdart.dart';

class UserController {
  //------------------------------------------------------------------ Api Instant -----------------------------------------------------------------//
  CreateUserApi createUserApi = CreateUserApi();
  GetUserInfoApi getUserInfoApi = GetUserInfoApi();
  UpdateUserApi updateUserApi = UpdateUserApi();
  LeaderBoardApi leaderBoardApi = LeaderBoardApi();

  //------------------------------------------------------------------ Controller -----------------------------------------------------------------//

  BehaviorSubject<ResponseModel<GetUserInfoModel>> getUserInfoController =
      BehaviorSubject<ResponseModel<GetUserInfoModel>>();

  BehaviorSubject<ResponseModel<LeaderBoardModel>> leaderBoardController =
      BehaviorSubject<ResponseModel<LeaderBoardModel>>();
  BehaviorSubject<ResponseModel<WorldLeaderBoardModel>>
      worldLeaderBoardController =
      BehaviorSubject<ResponseModel<WorldLeaderBoardModel>>();

//------------------------------------------------------------------ Stream -----------------------------------------------------------------//
  Stream<ResponseModel<GetUserInfoModel>> get getUserInfoStream =>
      getUserInfoController.stream;
  Stream<ResponseModel<LeaderBoardModel>> get leaderBoardStream =>
      leaderBoardController.stream;
  Stream<ResponseModel<WorldLeaderBoardModel>> get worldLeaderBoardStream =>
      worldLeaderBoardController.stream;

  //------------------------------------------------------------------ Sink -----------------------------------------------------------------//

  //Create User Controller
  Future<ResponseModel<LoginModel>> createUserSink({
    required Map<String, dynamic> createUserPostData,
    required File profileImage,
  }) async {
    ResponseModel<LoginModel> loginData = await createUserApi.createUserApi(
      createUserPostData: createUserPostData,
      profileImage: profileImage,
    );
    return loginData;
  }

  //Get User Info Controller
  Future<ResponseModel<GetUserInfoModel>> getUserInfoSink(
      {required String userId}) async {
    ResponseModel<GetUserInfoModel> geUserInfoResponse =
        await getUserInfoApi.getUserInfoApi(userId: userId);
    getUserInfoController.sink.add(geUserInfoResponse);
    return geUserInfoResponse;
  }

  //Get User Info Controller
  Future<ResponseModel<LeaderBoardModel>> leaderBoardSink() async {
    ResponseModel<LeaderBoardModel> leaderBoardResponse =
        await leaderBoardApi.laderBoardApi();
    leaderBoardController.sink.add(leaderBoardResponse);
    return leaderBoardResponse;
  }

  //Get User Info Controller
  Future<ResponseModel<WorldLeaderBoardModel>> worldLeadrBoard() async {
    ResponseModel<WorldLeaderBoardModel> leaderBoardResponse =
        await leaderBoardApi.worldLeadrBoard();
    worldLeaderBoardController.sink.add(leaderBoardResponse);
    return leaderBoardResponse;
  }

  //update user controller
  Future<ResponseModel<LoginModel>> updateUserSink({
    required Map<String, dynamic> updateUserData,
    required int id,
  }) async {
    ResponseModel<LoginModel> updateData = await updateUserApi.updateUserApi(
      id: id,
      updateUserData: updateUserData,
    );
    return updateData;
  }

  //------------------------------------------------------------------ Dispose  -----------------------------------------------------------------//
  void dispose() {
    getUserInfoController.close();
  }
}
