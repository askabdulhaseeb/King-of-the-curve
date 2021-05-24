import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/four_question_model.dart';
import 'package:kings_of_the_curve/models/intitutes_model.dart';
import 'package:kings_of_the_curve/models/options_model.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/models/review_option_model.dart';
import 'package:kings_of_the_curve/models/statsModel.dart';
import 'package:kings_of_the_curve/models/timed_option_model.dart';
import 'package:kings_of_the_curve/models/user_model.dart';
import 'package:kings_of_the_curve/providers/leaderboard_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:provider/provider.dart';

import 'firestore_keys.dart';

class FireStoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference _userCollection;
  CollectionReference _endlessModeCategoryCollection;
  BuildContext _context;

  SharedPreferenceProvider sharedPrefProvider;

  // LeaderBoardProvider leaderBoardProvider;

  /*CollectionReference _categoryCollectionReference;
  CollectionReference _singlePlayerModesCollectionReference;

  CollectionReference _categoriesWithSubCategoriesCollection;*/

  FireStoreService(BuildContext context) {
    _userCollection = _db.collection(KEY_USERS);
    sharedPrefProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    /*leaderBoardProvider =
        Provider.of<LeaderBoardProvider>(context, listen: false);*/
    _endlessModeCategoryCollection = _db.collection(KEY_ENDLESS_MODE_CATEGORY);
    _context = context;
    /*_categoryCollectionReference = _db.collection(KEY_CATEGORY);
    _singlePlayerModesCollectionReference =
        _db.collection(KEY_SINGLE_PLAYER_MODES);

    _categoriesWithSubCategoriesCollection =
        _db.collection('question_categories');*/
  }

  //  Add User To user table

  void addUser(
      {String userName,
      String userEmail,
      String userId,
      BuildContext context,
      String instituteName = "",
      String instituteId = "",
      String instituteEmail = ""}) async {
    final sharedPrefProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    DocumentSnapshot documentSnapshot = await _userCollection.doc(userId).get();
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    if (documentSnapshot.exists) {
      sharedPrefProvider.saveSharedPreference(
        UserDataModel.fromJson(documentSnapshot.data(), true),
      );
      print(sharedPrefProvider.userDataModel.userId);
      return;
    }
    print("Added new");
    print(userName);
    Map<String, dynamic> params = {
      'user_id': userId,
      'endless_mode_highscore': 0 /*'0'*/,
      'endless_mode_removed_categories': [],
      'endless_mode_removed_subcategories': [],
      'timed_mode_removed_categories': [],
      'timed_mode_removed_subcategories': [],
      'timed_mode_high_score': 0 /*'0'*/,
      'review_mode_removed_categories': [],
      'review_mode_removed_subcategories': [],
      'review_mode_high_score': 0 /*"0"*/,
      'bookmarked_questions_id': [],
      'flagged_questions_id': [],
      'user_email': userEmail,
      "user_name": userName,
      "institute_name": instituteName,
      "institute_id": instituteId,
      "institute_email": instituteEmail,
      'isPremium': false
    };
    try {
      final response = await _db.collection(KEY_USERS).doc(userId).set(params);
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(userId).get();
      sharedPrefProvider.saveSharedPreference(
        UserDataModel.fromJson(documentSnapshot.data(), true),
      );
      print(sharedPrefProvider.userDataModel.userId);
      print("New user");
    } catch (error) {
      print('Something went wrong while adding user');
    }
  }

  Future<void> getUserDetail(String userId) async {
    DocumentSnapshot documentSnapshot = await _userCollection.doc(userId).get();
    if (documentSnapshot.exists) {
      DocumentSnapshot documentSnapshot =
          await _db.collection(KEY_USERS).doc(userId).get();

      await sharedPrefProvider.saveSharedPreference(
        UserDataModel.fromJson(
          documentSnapshot.data(),
          true,
        ),
      );
    }
  }

  Future<bool> get_removed_endless_mode_categories(
      String categoryId, String userId) async {
    try {
      //    String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_ENDLESS_MODE_REMOVED_CATEGORY: FieldValue.arrayUnion([categoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> get_removed_timed_mode_categories(
      String categoryId, String userId) async {
    try {
      //    String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_TIMED_MODE_REMOVED_CATEGORY: FieldValue.arrayUnion([categoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> get_removed_review_mode_categories(
      String categoryId, String userId) async {
    try {
      //    String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_REVIEW_MODE_REMOVED_CATEGORY: FieldValue.arrayUnion([categoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> selectCategory(String categoryId, String userId) async {
    try {
      // String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_ENDLESS_MODE_REMOVED_CATEGORY: FieldValue.arrayRemove([categoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateEndlessHighScore(String score, String userId) async {
    try {
      await _userCollection
          .doc(userId)
          .update({"endless_mode_highscore": int.parse(score)});
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateTimedHighScore(String score, String userId) async {
    try {
      await _userCollection
          .doc(userId)
          .update({"timed_mode_high_score": int.parse(score)});
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateReviewHighScore(String score, String userId) async {
    try {
      await _userCollection
          .doc(userId)
          .update({"review_mode_high_score": int.parse(score)});
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> selectTimedCategory(String categoryId, String userId) async {
    try {
      // String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_TIMED_MODE_REMOVED_CATEGORY: FieldValue.arrayRemove([categoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> selectReviewCategory(String categoryId, String userId) async {
    try {
      // String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_REVIEW_MODE_REMOVED_CATEGORY: FieldValue.arrayRemove([categoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeSubCategory(String subCategoryId, String userId) async {
    try {
      await _userCollection.doc(userId).update({
        KEY_ENDLESS_MODE_REMOVED_SUB_CATEGORY:
            FieldValue.arrayUnion([subCategoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> removeTimedSubCategory(
      String subCategoryId, String userId) async {
    try {
      await _userCollection.doc(userId).update({
        KEY_TIMED_MODE_REMOVED_SUB_CATEGORY:
            FieldValue.arrayUnion([subCategoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> addQuestionsForReview(
      QuestionWithAnswersModel fourQuestionModel, String userID) async {
    try {
      await _userCollection.doc(userID).update({
        'bookmarked_questions_id':
            FieldValue.arrayUnion([fourQuestionModel.documentId]),
      });
      CollectionReference response = _db
          .collection('review_mode_module')
          .doc(sharedPrefProvider.userDataModel.userId)
          .collection('question_list');
      response
          .doc(fourQuestionModel.documentId)
          .set(QuestionWithAnswersModel().toJson(fourQuestionModel));

      await getUserDetail(userID);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> addFlagQuestions(
      QuestionWithAnswersModel fourQuestionModel, String userID) async {
    try {
      await _userCollection.doc(userID).update({
        'flagged_questions_id':
            FieldValue.arrayUnion([fourQuestionModel.documentId]),
      });
      await getUserDetail(userID);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeFlaggedQuestions(
      QuestionWithAnswersModel fourQuestionModel, String userID) async {
    try {
      await _userCollection.doc(userID).update({
        'flagged_questions_id':
            FieldValue.arrayRemove([fourQuestionModel.documentId]),
      });
      await getUserDetail(userID);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeQuestionsFromReview(
      QuestionWithAnswersModel fourQuestionModel, String userID) async {
    try {
      await _userCollection.doc(userID).update({
        'bookmarked_questions_id':
            FieldValue.arrayRemove([fourQuestionModel.documentId]),
      });
      CollectionReference response = _db
          .collection('review_mode_module')
          .doc(sharedPrefProvider.userDataModel.userId)
          .collection('question_list');

      response.doc(fourQuestionModel.documentId).delete();

      await getUserDetail(userID);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeReviewSubCategory(
      String subCategoryId, String userId) async {
    try {
      await _userCollection.doc(userId).update({
        KEY_REVIEW_MODE_REMOVED_SUB_CATEGORY:
            FieldValue.arrayUnion([subCategoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> selectSubCategory(String subCategoryId, String userId) async {
    try {
      // String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_ENDLESS_MODE_REMOVED_SUB_CATEGORY:
            FieldValue.arrayRemove([subCategoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  //---------
  Future<bool> selectTimedSubCategory(
      String subCategoryId, String userId) async {
    try {
      // String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_TIMED_MODE_REMOVED_SUB_CATEGORY:
            FieldValue.arrayRemove([subCategoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  //------------------
  Future<bool> selectReviewSubCategory(
      String subCategoryId, String userId) async {
    try {
      // String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      await _userCollection.doc(userId).update({
        KEY_REVIEW_MODE_REMOVED_SUB_CATEGORY:
            FieldValue.arrayRemove([subCategoryId]),
      });
      await getUserDetail(userId);
      return true;
    } catch (error) {
      return false;
    }
  }

  Stream<List<OptionsModel>> getEndlessOption() async* {
    try {
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      DocumentSnapshot userDocumentSnapShot = await _userCollection
          .doc(sharedPrefProvider.userDataModel.userId)
          .get();
      Map<String, dynamic> map = userDocumentSnapShot.data();
      List userUnselectedCategories = map[KEY_ENDLESS_MODE_REMOVED_CATEGORY];
      List userUnSelectedSubCategories =
          map[KEY_ENDLESS_MODE_REMOVED_SUB_CATEGORY];
      // print(userUnSelectedSubCategories.length);
      //----------------------------------------------------------------
      QuerySnapshot querySnapshot = await _endlessModeCategoryCollection.get();
      List<OptionsModel> endlessOptionList =
          querySnapshot.docs.map((queryDocSnapshot) {
        if (userUnselectedCategories.contains(queryDocSnapshot.id)) {
          return OptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.id, false, userUnSelectedSubCategories);
        } else {
          return OptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.reference.id, true, userUnSelectedSubCategories);
        }
      }).toList();
      yield endlessOptionList;
    } catch (error) {
      throw error;
    }
  }

  // ---------------------------- Async Option List

  Future<List<OptionsModel>> getAsyncEndlessOption(String userId) async {
    try {
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      DocumentSnapshot userDocumentSnapShot =
          await _userCollection.doc(userId).get();
      Map<String, dynamic> map = userDocumentSnapShot.data();
      List userUnselectedCategories = map[KEY_ENDLESS_MODE_REMOVED_CATEGORY];
      List userUnSelectedSubCategories =
          map[KEY_ENDLESS_MODE_REMOVED_SUB_CATEGORY];
      // print(userUnSelectedSubCategories.length);
      //----------------------------------------------------------------
      QuerySnapshot querySnapshot = await _endlessModeCategoryCollection.get();
      List<OptionsModel> endlessOptionList =
          querySnapshot.docs.map((queryDocSnapshot) {
        if (userUnselectedCategories.contains(queryDocSnapshot.id)) {
          return OptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.id, false, userUnSelectedSubCategories);
        } else {
          return OptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.reference.id, true, userUnSelectedSubCategories);
        }
      }).toList();
      return endlessOptionList;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // ---------------------------- Async Option List

  /// -------- Get Asyn TImed Option List ///
  Future<void> userDataList(String userId) async {
    //  String userId = sharedPrefProvider.userDataModel.userId ;
    DocumentSnapshot userDocumentSnapShot =
        await _userCollection.doc(userId).get();
    print("DATA");
    print(userId);

    print(userDocumentSnapShot.data());
  }

  Future<List<TimedOptionsModel>> getAsyncTimedOptionList(String userId) async {
    try {
      userDataList(userId);
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      DocumentSnapshot userDocumentSnapShot =
          await _userCollection.doc(userId).get();
      print(userDocumentSnapShot.data());
      Map<String, dynamic> map = userDocumentSnapShot.data();
      List userUnselectedCategories = map[KEY_TIMED_MODE_REMOVED_CATEGORY];
      List userUnSelectedSubCategories =
          map[KEY_TIMED_MODE_REMOVED_SUB_CATEGORY];
      // print(userUnSelectedSubCategories.length);
      //----------------------------------------------------------------
      QuerySnapshot querySnapshot = await _endlessModeCategoryCollection.get();
      List<TimedOptionsModel> timedOptionList =
          querySnapshot.docs.map((queryDocSnapshot) {
        if (userUnselectedCategories /*sharedPrefProvider.userDataModel.timedModeRemovedCategories*/
            .contains(queryDocSnapshot.id)) {
          return TimedOptionsModel.fromMap(
              queryDocSnapshot.data(),
              queryDocSnapshot.id,
              false,
              userUnSelectedSubCategories /*sharedPrefProvider.userDataModel.timedModeRemovedSubcategories*/);
        } else {
          return TimedOptionsModel.fromMap(
              queryDocSnapshot.data(),
              queryDocSnapshot.reference.id,
              true,
              userUnSelectedSubCategories /*sharedPrefProvider.userDataModel.timedModeRemovedSubcategories*/);
        }
      }).toList();
      return timedOptionList;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /// --------  ///

  // TImed Option Stream Function

  Stream<List<TimedOptionsModel>> getTimedOptionList() async* {
    try {
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      DocumentSnapshot userDocumentSnapShot = await _userCollection
          .doc(sharedPrefProvider.userDataModel.userId)
          .get();
      Map<String, dynamic> map = userDocumentSnapShot.data();
      List userUnselectedCategories = map[KEY_TIMED_MODE_REMOVED_CATEGORY];
      List userUnSelectedSubCategories =
          map[KEY_TIMED_MODE_REMOVED_SUB_CATEGORY];
      // print(userUnSelectedSubCategories.length);
      //----------------------------------------------------------------
      QuerySnapshot querySnapshot = await _endlessModeCategoryCollection.get();
      List<TimedOptionsModel> timedOptionList =
          querySnapshot.docs.map((queryDocSnapshot) {
        if (userUnselectedCategories.contains(queryDocSnapshot.id)) {
          return TimedOptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.id, false, userUnSelectedSubCategories);
        } else {
          return TimedOptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.reference.id, true, userUnSelectedSubCategories);
        }
      }).toList();
      yield timedOptionList;
    } catch (error) {
      throw error;
    }
  }

  // --------- Review Option Stream Function

  // TImed Option Stream Functiontion

  /// -------- Get Async Review Option List ///

  Future<List<ReviewOptionsModel>> getAsyncReviewOptionList(
      String userId) async {
    try {
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      DocumentSnapshot userDocumentSnapShot =
          await _userCollection.doc(userId).get();
      Map<String, dynamic> map = userDocumentSnapShot.data();
      List userUnselectedCategories = map[KEY_REVIEW_MODE_REMOVED_CATEGORY];
      List userUnSelectedSubCategories =
          map[KEY_REVIEW_MODE_REMOVED_SUB_CATEGORY];
      // print(userUnSelectedSubCategories.length);
      //----------------------------------------------------------------
      QuerySnapshot querySnapshot = await _endlessModeCategoryCollection.get();
      List<ReviewOptionsModel> reviewOptionList =
          querySnapshot.docs.map((queryDocSnapshot) {
        if (userUnselectedCategories.contains(queryDocSnapshot.id)) {
          return ReviewOptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.id, false, userUnSelectedSubCategories);
        } else {
          return ReviewOptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.reference.id, true, userUnSelectedSubCategories);
        }
      }).toList();
      return reviewOptionList;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /// /// --------  ///
  /// --------  ///
  /// /// --------  ///
  Stream<List<ReviewOptionsModel>> getReviewOptionList() async* {
    try {
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      DocumentSnapshot userDocumentSnapShot = await _userCollection
          .doc(sharedPrefProvider.userDataModel.userId)
          .get();
      Map<String, dynamic> map = userDocumentSnapShot.data();
      List userUnselectedCategories = map[KEY_REVIEW_MODE_REMOVED_CATEGORY];
      List userUnSelectedSubCategories =
          map[KEY_REVIEW_MODE_REMOVED_SUB_CATEGORY];
      // print(userUnSelectedSubCategories.length);
      //----------------------------------------------------------------
      QuerySnapshot querySnapshot = await _endlessModeCategoryCollection.get();
      List<ReviewOptionsModel> reviewOptionList =
          querySnapshot.docs.map((queryDocSnapshot) {
        if (userUnselectedCategories.contains(queryDocSnapshot.id)) {
          return ReviewOptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.id, false, userUnSelectedSubCategories);
        } else {
          return ReviewOptionsModel.fromMap(queryDocSnapshot.data(),
              queryDocSnapshot.reference.id, true, userUnSelectedSubCategories);
        }
      }).toList();
      yield reviewOptionList;
    } catch (error) {
      throw error;
    }
  }

  Future<List<String>> getSubCategoriesName() async {
    try {
      List<String> list = [];
      QuerySnapshot query = await _db.collection('subcategories').get();
      print(sharedPrefProvider.userDataModel.endlessModeRemovedSubcategories);

      for (int i = 0; i < query.docs.length; i++) {
        if (sharedPrefProvider
                .userDataModel.endlessModeRemovedSubcategories.length >
            0) {
          print(query.docs.elementAt(i).id);

          if (sharedPrefProvider.userDataModel.endlessModeRemovedSubcategories
              .contains(query.docs.elementAt(i).id.trim().toString())) {
            print(query.docs.elementAt(i).data()['sub_category_name']);
            list.add(query.docs.elementAt(i).data()['sub_category_name']);
          }
        } else {
          break;
        }
      }
      return list;
    } catch (error) {
      print("Sub Category Error" + error);
      throw error;
    }
  }

  void addCategory() async {
    Map<String, dynamic> params = {
      'categoryName': 'New Category second  name',
      'categoryBackgroundColor': 'green',
      'categoryImage': 'categoryImage',
      'categoryTextColor': 'categoryTextColor',
    };
    try {
      //    var response = await categoryDocumentsReference.set(params);
    } catch (error) {
      print('error');
    }
  }

  void addRandomDocument() async {
    try {
      DocumentReference response = await _db.collection('categories').add({
        'categoryName': 'xyz',
        'categoryBackgroundColor': 'dasdasd',
        'categoryImage': 'dsadsa',
        'categoryTextColor': 'categoryTdasdasextColor',
      });
      print("Added new document");
      print(response.id);
    } catch (error) {
      print('Something went wrong');
    }
  }

// Save EndLess High Score ---------

  void addEndlessHighScore(int highScore, String userId) async {
    try {
      var response = await _db
          .collection("endless_highscore")
          .doc(userId)
          .set({'userId': userId, 'value': highScore, 'date': Timestamp.now()});
      print("Added");
    } catch (error) {
      print('Something went wrong');
    }
  }

// get endless high score

  void getEndlessHighScore(String userId) async {
    DocumentReference documentReference =
        _db.collection("endless_highscore").doc(userId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    int data = documentSnapshot.get('value');
    print(data.toString());
  }

//// Get All Questions
  Future<List<QuestionWithAnswersModel>> getAllQuestions() async {
    try {
      final QuerySnapshot result = await _db.collection('questions').get();
      final List<DocumentSnapshot> documents = result.docs;

      List<QuestionWithAnswersModel> questionModel = documents
          .map(
              (data) => QuestionWithAnswersModel.fromJson(data.data(), data.id))
          .toList();
      return questionModel;
    } catch (error) {
      print(error);
      throw error;
    }
  }

// Get All review questions
  Future<List<QuestionWithAnswersModel>> getReviewQuestions() async {
    try {
      //  String userId = 'IypFieL7msYv3A3V0obSQjNidq93';
      // ---------------- User Data _-------------------
      List<FourQuestionModel> fourQuestionModel = [];
      QuerySnapshot result = await _db
          .collection('review_mode_module')
          .doc(sharedPrefProvider.userDataModel.userId)
          .collection('question_list')
          .get();
      List<QueryDocumentSnapshot> documents = result.docs;
      List<QuestionWithAnswersModel> reviewQuestionsList = documents
          .map(
              (data) => QuestionWithAnswersModel.fromJson(data.data(), data.id))
          .toList();

      return reviewQuestionsList;
      //endlessOptionList;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  ////////////////////--------------------
  Future<List<UserDataModel>> getAllUsers(
      LeaderBoardProvider leaderBoardProvider) async {
    QuerySnapshot allUsersDoc = await _db
        .collection(KEY_USERS)
        .orderBy("endless_mode_highscore", descending: true)
        .get();
    List<UserDataModel> usersList = allUsersDoc.docs.map((snapshot) {
      return UserDataModel.fromJson(snapshot.data(), false);
    }).toList();
    bool value = usersList.any((element) {
      if (element.userId == sharedPrefProvider.userDataModel.userId) {
        leaderBoardProvider.setEndlessRank(usersList.indexOf(element) + 1);
        return true;
      } else {
        leaderBoardProvider.setEndlessRank(0);
        return false;
      }
    });

    return usersList;
  }

  //---- get all users order by timed high score
  Future<List<UserDataModel>> getAllUsersOrderByTimedScore(
      LeaderBoardProvider leaderBoardProvider) async {
    QuerySnapshot allUsersDoc = await _db
        .collection(KEY_USERS)
        .orderBy("timed_mode_high_score", descending: true)
        .get();
    List<UserDataModel> usersList = allUsersDoc.docs.map((snapshot) {
      return UserDataModel.fromJson(snapshot.data(), false);
    }).toList();
    bool value = usersList.any((element) {
      if (element.userId == sharedPrefProvider.userDataModel.userId) {
        leaderBoardProvider.setTimedRank(usersList.indexOf(element) + 1);
        return true;
      } else {
        leaderBoardProvider.setTimedRank(0);
        return false;
      }
    });

    return usersList;
  }

  // Save EndLess High Score ---------

  void makeUserPremium(String transactionId, DateTime subscriptionFrom,
      DateTime subscriptionTo) async {
    try {
      var response = await _userCollection
          .doc(sharedPrefProvider.userDataModel.userId)
          .update({
        'transactionId': transactionId,
        'isPremium': true,
        'subscriptionFrom': subscriptionFrom,
        'subscriptionTo': subscriptionTo,
      });

      await getUserDetail(sharedPrefProvider.userDataModel.userId);
      print("Added");
    } catch (error) {
      print('Something went wrong');
    }
  }

  Future<List<InstituteModel>> getAllInstitutes() async {
    QuerySnapshot allInstitutes = await _db.collection("institutions").get();
    List<InstituteModel> instituteList = allInstitutes.docs.map((snapshot) {
      return InstituteModel.fromJson(snapshot.data());
    }).toList();
    print(instituteList.first.institutionName);

    return instituteList;
  }

  Future<void> updateUserInstitute(String userId, String instituteName,
      String instituteId, String instituteEmail) async {
    try {
      var response = await _userCollection.doc(userId).update({
        'institute_name': instituteName,
        'institute_id': instituteId,
        'institute_email': instituteEmail
      });

      await getUserDetail(sharedPrefProvider.userDataModel.userId);
    } catch (error) {
      print('Something went wrong');
    }
  }

  List<String> subCategoriesId = [];
  List<int> questionsCountAsPerSubCategories = [];

  Future<int> getStatsCount() async {
    QuerySnapshot query = await _db.collection('subcategories').get();
    query.docs.forEach((element) async {
      final QuerySnapshot questionResult = await _db
          .collection('questions')
          .where("sub_category_id", isEqualTo: element.id)
          .get();
      print(element.data()['sub_category_name']);
      print(questionResult.docs.length);
    });
  }

  Future<List<StatsModel>> calculateStats(String userId) async {
    try {
      List<StatsModel> statsDataList = [];

      QuerySnapshot statCollection = await _db
          .collection('user_stats')
          .doc(userId)
          .collection('userCategory')
          .get();
      //  print(statCollection.docs.length);\

      for (var element in statCollection.docs) {
        CollectionReference userCatCollection =
            _db.collection('user_stats').doc(userId).collection('userCategory');
        StatsModel statsModel = StatsModel();
        statsModel.categoryName = element.data()['categoryName'];
        statsModel.categoryId = element.data()['categoryId'];
        statsModel.statsSubCategory = [];
        int catPercentage = 0;
        QuerySnapshot querySnapshot = await userCatCollection
            .doc(element.id)
            .collection('userSubCategory')
            .get();
        for (var subCatElement in querySnapshot.docs) {
          catPercentage = catPercentage + subCatElement.data()['percentage'];
          statsModel.statsSubCategory.add(
            StatsSubCategory.fromJson(
              subCatElement.data(),
            ),
          );
        }
        print(statsModel.categoryId);
        print(statsModel.statsSubCategory.length);
        double percentageOutput =
            ((catPercentage / statsModel.statsSubCategory.length));
        statsModel.categoryPercentage =
            int.parse(percentageOutput.toStringAsFixed(0));
        statsDataList.add(statsModel);
      }

      return statsDataList;

      /*   statCollection.docs.forEach((element) async {
        CollectionReference userCatCollection =
            _db.collection('user_stats').doc(userId).collection('userCategory');

        StatsModel statsModel = StatsModel();
        statsModel.categoryName = element.data()['categoryName'];
        statsModel.categoryId = element.data()['categoryId'];
        statsModel.statsSubCategory = [];
        QuerySnapshot querySnapshot = await userCatCollection
            .doc(element.id)
            .collection('userSubCategory')
            .get();
        querySnapshot.docs.forEach((element) {
          statsModel.statsSubCategory
              .add(StatsSubCategory.fromJson(element.data()));
        });
        print(statsModel.categoryId);
        print(statsModel.statsSubCategory.length);
       return  statsDataList.add(statsModel);
      });*/

    } catch (error) {
      print(error);
      throw error;
    }
    //QuerySnapshot data = await categoryQuerySnap.get();
    // print(data.docs.length);
  }

  /* Future<void> saveStatsData(
      String userId,
      String subCategoryId,
      String subCategoryName,
      String categoryId,
      String categoryName,
      int percentage) async {
    _db.collection('user_stats').doc(userId).
  }*/

  Future<void> saveEndlessCorrectQuestionCount(
      String userId,
      String subCategoryId,
      String subCategoryName,
      String categoryId,
      String categoryName,
      int percentage) async {
    try {
      QuerySnapshot subCategoryQuery = await _db
          .collection('user_stats')
          .doc(userId)
          .collection('userCategory')
          .doc(categoryId)
          .collection('userSubCategory')
          .where('subCategoryId', isEqualTo: subCategoryId)
          .get();

      print(subCategoryQuery.docs.isNotEmpty);
      if (subCategoryQuery.docs.isNotEmpty) {
        int savedPercentage =
            subCategoryQuery.docs.elementAt(0).data()['percentage'];
        double tempPercentage = ((savedPercentage + percentage) / 2);
        int avgNewPercentage = int.parse(tempPercentage.toStringAsFixed(0));
        Map<String, dynamic> param = {
          'percentage': avgNewPercentage,
          'userId': userId,
          'categoryId': categoryId,
          'categoryName': categoryName,
          'subCategoryId': subCategoryId,
          'subCategoryName': subCategoryName
        };

        /* await _db
            .collection('user_stats')
            .doc(userId)
            .set({'categoryId': categoryId}); */
        var response = await _db
            .collection('user_stats')
            .doc(userId)
            .collection('userCategory')
            .doc()
            .collection('userSubCategory')
            .doc()
            .set(param);
      } else {
        print("New SubCategory");
        Map<String, dynamic> param = {
          'percentage': percentage,
          'userId': userId,
          'categoryId': categoryId,
          'categoryName': categoryName,
          'subCategoryId': subCategoryId,
          'subCategoryName': subCategoryName
        };

        DocumentReference data = _db
            .collection('user_stats')
            .doc(userId)
            .collection('userCategory')
            .doc(categoryId);

        await data.set({
          "categoryName": categoryName,
          "categoryId": categoryId,
        });
        await data.collection('userSubCategory').doc(subCategoryId).set(param);

        /*var response = await _db
            .collection('user_stats')
            .doc(userId)
            .collection('userCategory')
            .doc(categoryId)
            .collection('userSubCategory')
            .doc(subCategoryId)
            .set(param);*/
      }
    } catch (error) {
      throw error;
    }
  }
}
