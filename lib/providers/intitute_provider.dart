import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kings_of_the_curve/models/intitutes_model.dart';
import 'package:kings_of_the_curve/models/statsModel.dart';
import 'package:kings_of_the_curve/services/firestore_service.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class InstituteProvider with ChangeNotifier, BaseClass {
  List<InstituteModel> _instituteList;

  FireStoreService _fireStoreService;

  InstituteProvider(BuildContext context) {
    _fireStoreService = FireStoreService(context);
    _instituteList = [];
  }

  List<InstituteModel> getInstituteList() => _instituteList;

  void setInstituteList() async {
    _instituteList = await _fireStoreService.getAllInstitutes();
    notifyListeners();
  }

  void updateInstituteName(String userId, String instituteName,
      String instituteId, BuildContext context, String instituteEmail) async {
    showCircularDialog(context);
    await _fireStoreService.updateUserInstitute(
        userId, instituteName, instituteId, instituteEmail);
    popToPreviousScreen(context: context);
    Navigator.pop(context, true);
  }

  Future<List<StatsModel>> checkStats(String userId)async {
    //await _fireStoreService.getStatsCount();
  List<StatsModel> statsList =   await _fireStoreService.calculateStats(userId);
  return statsList ;
  }
}
