import 'package:shared_preferences/shared_preferences.dart';

class Keys {
  static const String userData = 'USER_DATA';
  static const String userID = 'USER_ID';
  static const String token = 'TOKEN';
  static const String loginType = 'loginType';
}

late SharedPreferences preferences;
