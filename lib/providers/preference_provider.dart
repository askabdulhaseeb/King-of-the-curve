import 'package:flutter/foundation.dart';

class UserPreferenceProvider with ChangeNotifier {
  /*UserDataModel _userDataModel;

  UserPreferenceProvider() {
    _userDataModel = UserDataModel();
    loadPreference();
    loadProfileSharedPreference();
  }

  void setUserData(UserDataModel userDataModel) {
    _userDataModel = userDataModel;
    notifyListeners();
  }

  saveSharedPreference(UserDataModel userDataModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = encode(userDataModel);
    pref.setString("userData", data);
    setUserData(userDataModel);
  }

  UserDataModel get userDataModel => _userDataModel;

  loadProfileSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserDataModel userProfileModel = new UserDataModel();
  }

  loadPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userData") != null) {
      UserDataModel userDataModel = decode(pref.getString("userData"));
      if (userDataModel != null) {
        setUserData(userDataModel);
      }
    }
  }

  clearPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserDataModel model = new UserDataModel();
    model.isLoggedIn = false;
    model.userId = "";
    model.userNumber = "";
    model.userEmail = "";
    model.userName = "";
    model.fullName = "";
    saveSharedPreference(model);
  }

  static String encode(UserDataModel musics) =>
      json.encode(musics.toMap(musics));

  static UserDataModel decode(String musics) {
    var response = json.decode(musics);
    final result = UserDataModel.fromJson(response);
    return result;
  }*/
}
