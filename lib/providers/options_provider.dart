import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/options_model.dart';
import 'package:kings_of_the_curve/models/review_option_model.dart';
import 'package:kings_of_the_curve/models/timed_option_model.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/services/firestore_service.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:provider/provider.dart';

class OptionProvider with ChangeNotifier, BaseClass {
  FireStoreService _fireStoreService;
  SharedPreferenceProvider _sharedPreferenceProvider;

  /*= FireStoreService();*/
  List<OptionsModel> _endlessOptionList;
  List<TimedOptionsModel> _timedOptionList;
  List<ReviewOptionsModel> _reviewOptionList;

  OptionProvider(BuildContext context) {
    _fireStoreService = FireStoreService(context);
    _endlessOptionList = [];
    _timedOptionList = [];
    _reviewOptionList = [];
    _sharedPreferenceProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
  }

  void setOptionListForAll(String userId) {
    setEndlessOptionList(userId);
    setTimedOptionList(userId);
    setReviewOptionList(userId);
  }

  /// ENDLESSSSSSSS OPTIONNSSSSSSSSS---------
  Stream<List<OptionsModel>> get getOptionList =>
      _fireStoreService.getEndlessOption();

  /*Future<List<OptionsModel>>*/
  List<OptionsModel> get getAsyncOptionList =>
      /*_fireStoreService.getAsyncEndlessOption()*/ _endlessOptionList;

  void setEndlessOptionList(String userId) async {
    _endlessOptionList = await _fireStoreService.getAsyncEndlessOption(userId);
    notifyListeners();
  }

  /// ----------------------------------------------
  /// TIMED OPTIONSSSSSS----
  Stream<List<TimedOptionsModel>> get getTimedOptionList =>
      _fireStoreService.getTimedOptionList();

  List<TimedOptionsModel> get getAsyncTimedOptionList =>
      /*_fireStoreService.getAsyncEndlessOption()*/ _timedOptionList;

  void setTimedOptionList(String userId) async {
    _timedOptionList = await _fireStoreService.getAsyncTimedOptionList(userId);
    notifyListeners();
  }

  ///--------------------

  /// Review OPTIONSSSSSS----
  Stream<List<ReviewOptionsModel>> get getReviewOptionList =>
      _fireStoreService.getReviewOptionList();

  List<ReviewOptionsModel> get getAsyncReviewOptionList =>
      /*_fireStoreService.getAsyncEndlessOption()*/ _reviewOptionList;

  void setReviewOptionList(String userId) async {
    _reviewOptionList =
        await _fireStoreService.getAsyncReviewOptionList(userId);
    notifyListeners();
  }

  ///--------------------

  void changeEndlessSubCategoryStatus(
      bool isSelected,
      String subCategoryId,
      BuildContext context,
      String userId,
      int elementCategoryIndex,
      int elementSubCategoryIndex) async {
    bool result;
    print(isSelected);
    showCircularDialog(context);
    if (isSelected) {
      result = await _fireStoreService.removeSubCategory(subCategoryId, userId);
    } else {
      result = await _fireStoreService.selectSubCategory(subCategoryId, userId);
    }
    // print("Result" + result.toString());
    popToPreviousScreen(context: context);
    if (result) {
      if (isSelected) {
        _endlessOptionList
            .elementAt(elementCategoryIndex)
            .subCategoryList
            .elementAt(elementSubCategoryIndex)
            .isSubCatSelected = false;
      } else {
        _endlessOptionList
            .elementAt(elementCategoryIndex)
            .subCategoryList
            .elementAt(elementSubCategoryIndex)
            .isSubCatSelected = true;
      }
      notifyListeners();
    }
  }

  //--------

  void changeTimedSubCategoryStatus(
      bool isSelected,
      String subCategoryId,
      BuildContext context,
      String userId,
      int elementCategoryIndex,
      int elementSubCategoryIndex) async {
    bool result;
    print(isSelected);
    showCircularDialog(context);
    if (isSelected) {
      result =
          await _fireStoreService.removeTimedSubCategory(subCategoryId, userId);
    } else {
      result =
          await _fireStoreService.selectTimedSubCategory(subCategoryId, userId);
    }
    // print("Result" + result.toString());
    popToPreviousScreen(context: context);
    if (result) {
      if (isSelected) {
        _timedOptionList
            .elementAt(elementCategoryIndex)
            .subCategoryList
            .elementAt(elementSubCategoryIndex)
            .isSubCatSelected = false;
      } else {
        _timedOptionList
            .elementAt(elementCategoryIndex)
            .subCategoryList
            .elementAt(elementSubCategoryIndex)
            .isSubCatSelected = true;
      }
      notifyListeners();
    }
  }

  //-------------------------

  void changeReviewSubCategoryStatus(
      bool isSelected,
      String subCategoryId,
      BuildContext context,
      String userId,
      int elementCategoryIndex,
      int elementSubCategoryIndex) async {
    bool result;
    print(isSelected);
    showCircularDialog(context);
    if (isSelected) {
      result = await _fireStoreService.removeReviewSubCategory(
          subCategoryId, userId);
    } else {
      result = await _fireStoreService.selectReviewSubCategory(
          subCategoryId, userId);
    }
    // print("Result" + result.toString());
    popToPreviousScreen(context: context);
    if (result) {
      if (isSelected) {
        _reviewOptionList
            .elementAt(elementCategoryIndex)
            .subCategoryList
            .elementAt(elementSubCategoryIndex)
            .isSubCatSelected = false;
      } else {
        _reviewOptionList
            .elementAt(elementCategoryIndex)
            .subCategoryList
            .elementAt(elementSubCategoryIndex)
            .isSubCatSelected = true;
      }
      notifyListeners();
    }
  }

  void changeEndlessCategoryStatus(bool isSelected, String categoryId,
      BuildContext context, String userId, int elementIndex) async {
    bool result;
    showCircularDialog(context);
    if (isSelected) {
      result = await _fireStoreService.get_removed_endless_mode_categories(
          categoryId, userId);
    } else {
      result = await _fireStoreService.selectCategory(categoryId, userId);
    }
    popToPreviousScreen(context: context);
    if (result) {
      if (isSelected) {
        _endlessOptionList.elementAt(elementIndex).isCategorySelected = false;
        _endlessOptionList
            .elementAt(elementIndex)
            .subCategoryList
            .forEach((element) {
          element.isSubCatSelected = false;
        });
      } else {
        _endlessOptionList.elementAt(elementIndex).isCategorySelected = true;
        _endlessOptionList
            .elementAt(elementIndex)
            .subCategoryList
            .forEach((element) {
          if (_sharedPreferenceProvider
              .userDataModel.endlessModeRemovedSubcategories
              .contains(element.subCatId)) {
            element.isSubCatSelected = false;
          } else {
            element.isSubCatSelected = true;
          }
        });
      }
      notifyListeners();
    }
  }

  void changeTimedCategoryStatus(bool isSelected, String categoryId,
      BuildContext context, String userId, int elementIndex) async {
    bool result;
    showCircularDialog(context);
    if (isSelected) {
      result = await _fireStoreService.get_removed_timed_mode_categories(
          categoryId, userId);
    } else {
      result = await _fireStoreService.selectTimedCategory(categoryId, userId);
    }
    popToPreviousScreen(context: context);
    if (result) {
      if (isSelected) {
        _timedOptionList.elementAt(elementIndex).isCategorySelected = false;
        _timedOptionList
            .elementAt(elementIndex)
            .subCategoryList
            .forEach((element) {
          element.isSubCatSelected = false;
        });
      } else {
        _timedOptionList.elementAt(elementIndex).isCategorySelected = true;
        _timedOptionList
            .elementAt(elementIndex)
            .subCategoryList
            .forEach((element) {
          if (_sharedPreferenceProvider
              .userDataModel.timedModeRemovedSubcategories
              .contains(element.subCatId)) {
            element.isSubCatSelected = false;
          } else {
            element.isSubCatSelected = true;
          }
        });
      }
      notifyListeners();
    }
  }

//--------------

  void changeReviewCategoryStatus(bool isSelected, String categoryId,
      BuildContext context, String userId, int elementIndex) async {
    bool result;
    showCircularDialog(context);
    if (isSelected) {
      result = await _fireStoreService.get_removed_review_mode_categories(
          categoryId, userId);
    } else {
      result = await _fireStoreService.selectReviewCategory(categoryId, userId);
    }
    popToPreviousScreen(context: context);
    if (result) {
      if (isSelected) {
        _reviewOptionList.elementAt(elementIndex).isCategorySelected = false;
        _reviewOptionList
            .elementAt(elementIndex)
            .subCategoryList
            .forEach((element) {
          element.isSubCatSelected = false;
        });
      } else {
        _reviewOptionList.elementAt(elementIndex).isCategorySelected = true;
        _reviewOptionList
            .elementAt(elementIndex)
            .subCategoryList
            .forEach((element) {
          if (_sharedPreferenceProvider
              .userDataModel.reviewModeRemovedSubcategories
              .contains(element.subCatId)) {
            element.isSubCatSelected = false;
          } else {
            element.isSubCatSelected = true;
          }
        });
      }
      notifyListeners();
    }
  }

  void addUserLogin(
      {String displayName,
      String email,
      String user_id,
      BuildContext context}) {
    _fireStoreService.addUser(
        userName: displayName,
        userEmail: email,
        userId: user_id,
        context: context);
  }

  void addAuthUserLogin(
      {String displayName,
      String email,
      String user_id,
      BuildContext context,
      String mInstituteEmail,
      String mInstituteId,
      String mInstituteName}) {
    _fireStoreService.addUser(
      userName: displayName,
      userEmail: email,
      userId: user_id,
      context: context,
      instituteEmail: mInstituteEmail,
      instituteId: mInstituteId,
      instituteName: mInstituteName,
    );
  }

  //-------------------

  void setUserEndlessHighScore(String endlessHighScore, String userId) async {
    bool value = await _fireStoreService.updateEndlessHighScore(
        endlessHighScore, userId);
  }

  void setUserTimedHighScore(String timedHighScore, String userId) async {
    bool value =
        await _fireStoreService.updateTimedHighScore(timedHighScore, userId);
  }

  void setUserReviewHighScore(String timedHighScore, String userId) async {
    bool value =
        await _fireStoreService.updateReviewHighScore(timedHighScore, userId);
  }
}
