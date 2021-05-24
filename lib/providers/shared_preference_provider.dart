import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kings_of_the_curve/models/four_question_model.dart';
import 'package:kings_of_the_curve/models/user_model.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceProvider with ChangeNotifier, BaseClass {
  UserDataModel _userDataModel;
  List<FourQuestionModel> _fourQuesList;

  SharedPreferenceProvider() {
    _userDataModel = UserDataModel();
    loadPreference();
  }

  void setUserData(UserDataModel userDataModel) {
    _userDataModel = userDataModel;
    notifyListeners();
  }

  void setReviewQues(List<FourQuestionModel> ques) {
    _fourQuesList = ques;
    notifyListeners();
  }

  saveSharedPreference(UserDataModel userDataModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = encode(userDataModel);
    pref.setString(USER_DATA_KEY, data);
    setUserData(userDataModel);
  }

  UserDataModel get userDataModel => _userDataModel;

  loadPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString(USER_DATA_KEY) != null) {
      UserDataModel userDataModel = decode(pref.getString(USER_DATA_KEY));
      if (userDataModel != null) {
        setUserData(userDataModel);
      }
    }
  }

 /* updateRemovedCategoryInSharedPre(bool isAdded,String categoryId){
    SharedPreferences pref = await SharedPreferences.getInstance();
  }*/



  clearPreference() async {
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    UserDataModel model = new UserDataModel();
    model.isLoggedIn = false;
    model.userId = "0";
    model.endlessModeHighscore = "0";
    model.endlessModeRemovedCategories = [];
    model.endlessModeRemovedSubcategories = [];
    model.timedModeRemovedCategories = [];
    model.timedModeRemovedSubcategories = [];
    model.reviewModeHighScore = "0";
    model.reviewModeRemovedSubcategories = [];
    model.reviewModeRemovedCategories = [];
    model.timedModeHighScore = "";
    model.userName = "";
    model.userEmail = "";
    model.bookMarkedQuestions = [];
    model.instituteName="";
    model.instituteId="";
    model.instituteEmail="";
    saveSharedPreference(model);
  }

  static String encode(UserDataModel musics) =>
      json.encode(musics.toJson(musics));

  static UserDataModel decode(String userPRef) {
    var response = json.decode(userPRef);
    final result = UserDataModel.fromJson(response, response['isLoggedIn']);
    return result;
  }
}
