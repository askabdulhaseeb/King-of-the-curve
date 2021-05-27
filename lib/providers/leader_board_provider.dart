import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kings_of_the_curve/models/user_model.dart';
import 'package:kings_of_the_curve/services/firestore_service.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class LeaderBoardProvider with ChangeNotifier, BaseClass {
  List<UserDataModel> _usersList;
  List<UserDataModel> _timedModeUsersList;

  FireStoreService _fireStoreService;
  int _endlessRank;
  int _timedRank;

  LeaderBoardProvider(BuildContext context) {
    _usersList = [];
    _timedModeUsersList = [];
    _fireStoreService = FireStoreService(context);
    _endlessRank = -1;
    _timedRank =-1 ;
  }

  void getAllUsers(LeaderBoardProvider leaderBoardProvider) async {
    _usersList = await _fireStoreService.getAllUsers(leaderBoardProvider);
    notifyListeners();
  }

  void getAllUsersTimedMode(LeaderBoardProvider leaderBoardProvider) async {
    _timedModeUsersList = await _fireStoreService
        .getAllUsersOrderByTimedScore(leaderBoardProvider);
    notifyListeners();
  }

  void setEndlessRank(int rank) {
    _endlessRank = rank;
    /*notifyListeners();*/
  }

  void setTimedRank(int rank) {
    _timedRank = rank;
  }

  int getTimedRank(){
    return _timedRank;
  }

  int getEndlessRank() {
    return _endlessRank;
  }

  List<UserDataModel> get usersList => _usersList;

  List<UserDataModel> get timedModeUsersList => _timedModeUsersList;
}
