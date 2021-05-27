import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/endless_game_over_page.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/providers/remaining_life_count_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/services/firestore_service.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:provider/provider.dart';

class QuestionProvider with ChangeNotifier, BaseClass {
  List<QuestionWithAnswersModel> _questionsList;
  FireStoreService _fireStoreService;
  SharedPreferenceProvider _sharedPreferenceProvider;

  int _correctAnswersCount;
  List<QuestionWithAnswersModel> _answeredQuestions;
  bool _initTimer;
  QuestionWithAnswersModel _currentQuestion;
  int _previousRandomNumber = -1;
  RemainingLifeCountProvider remainingLifeProvider;

  bool _isAnswerTapped;
  int _selectedMode = 0; // 1= endless, 2 = timed ,  3 = review
  QuestionProvider(BuildContext context) {
    _questionsList = [];
    _answeredQuestions = [];
    _correctAnswersCount = 0;
    _fireStoreService = FireStoreService(context);
    _sharedPreferenceProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    _initTimer = true;
    remainingLifeProvider =
        Provider.of<RemainingLifeCountProvider>(context, listen: false);
    _getAllQuestions();
    _isAnswerTapped = false;
  }

  void setSelectedMode(int modeNumber) {
    _selectedMode = modeNumber;
  }

  void resetTimedTimer() {
    _initTimer = true;
  }

  void cancelTimerStatus() {
    _initTimer = false;
  }

  bool get getTimerStatus => _initTimer;

// getting questions from firestore

  void _getAllQuestions() async {
    try {
      List<QuestionWithAnswersModel> list =
          await _fireStoreService.getAllQuestions();
      _setQuestions(list);
    } catch (error) {
      print(error);
    }
  }

  // adding all questions to list
  void _setQuestions(List<QuestionWithAnswersModel> questionData) {
    _questionsList = questionData;
    print(_questionsList.length);
    print("QUESTION LIST");
    setNewQuestion();
  }

// setting current question to be shown
  void setNewQuestion() {
    int randomNumber = Random().nextInt(_questionsList.length);

    print(_previousRandomNumber);
    print(randomNumber);
    if (randomNumber != _previousRandomNumber) {
      _currentQuestion = _questionsList.elementAt(randomNumber);
      if (_selectedMode == 1) {
        // endless mode
        if (_sharedPreferenceProvider.userDataModel.endlessModeRemovedCategories
            .contains(_currentQuestion.categoryId)) {
          setNewQuestion();
        } else {
          if (_sharedPreferenceProvider
              .userDataModel.endlessModeRemovedSubcategories
              .contains(_currentQuestion.subCategoryId)) {
            setNewQuestion();
          } else {
            _previousRandomNumber = randomNumber;
            _isAnswerTapped = false;
            notifyListeners();
          }
        }
      } else if (_selectedMode == 2) // Timed Mode
      {
        if (_sharedPreferenceProvider.userDataModel.timedModeRemovedCategories
            .contains(_currentQuestion.categoryId)) {
          setNewQuestion();
        } else {
          if (_sharedPreferenceProvider
              .userDataModel.timedModeRemovedSubcategories
              .contains(_currentQuestion.subCategoryId)) {
            setNewQuestion();
          } else {
            _previousRandomNumber = randomNumber;
            _isAnswerTapped = false;
            notifyListeners();
          }
        }
      }
    } else {
      setNewQuestion();
    }

    /* int randomNumber = Random().nextInt(_questionsList.length);

    print(_previousRandomNumber);
    print(randomNumber);
    if (randomNumber != _previousRandomNumber) {

      _currentQuestion = _questionsList.elementAt(randomNumber);
      _previousRandomNumber = randomNumber;
      _isAnswerTapped = false;
      notifyListeners();
    } else {
      setNewQuestion();
    }*/
  }

  bool get getAnswerTappedStatus => _isAnswerTapped;

  void setAnswerStatus(bool isStatus) {
    _isAnswerTapped = isStatus;
  }

  // get current question selected from the list

  QuestionWithAnswersModel get currentQuestion => _currentQuestion;

  // change background of the selected option and show next question after a delay

  void changeBackgroundColor(Color backgroundNewColor, int index,
      {BuildContext context}) {
    _currentQuestion.options.elementAt(index).optionBackgroundColor =
        backgroundNewColor;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (remainingLifeProvider.getRemainingLivesCount != 0) {
        _changeQuestion(index);
      } else {
        _currentQuestion.options.elementAt(index).optionBackgroundColor =
            dividerColor;
        pushToNextScreenWithFadeAnimation(
          context: context,
          destination: EndlessGameOverPage(),
        );
      }
    });
  }

  void changeTimedBackgroundColor(Color backgroundNewColor, int index,
      {BuildContext context}) {
    _currentQuestion.options.elementAt(index).optionBackgroundColor =
        backgroundNewColor;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      _currentQuestion.options.elementAt(index).optionBackgroundColor =
          dividerColor;
      _changeQuestion(index);
    });
  }

  // change question

  void _changeQuestion(int index) {
    _currentQuestion.options.elementAt(index).optionBackgroundColor =
        dividerColor;
    setNewQuestion();
  }

  // increment score on correct question
  void incrementScore() {
    _correctAnswersCount++;
  }

  // add answered  questions to the list
  void addAnsweredQuestions(QuestionWithAnswersModel questionWithAnswersModel,
      int selectedAnswerIndex) {
    _currentQuestion.selectedAnswer = (selectedAnswerIndex + 1).toString();
    _answeredQuestions.add(_currentQuestion);
  }

  // get answered questions
  List<QuestionWithAnswersModel> get getAnsweredQuestions => _answeredQuestions;

  // get correct answers count
  int get getCorrectAnswersCount => _correctAnswersCount;

  // reset answered questions list and reset correct answers count

  void clearAnsweredQuestionsList() {
    _answeredQuestions.clear();
    _correctAnswersCount = 0;
    _isAnswerTapped = false;

    notifyListeners();
  }

  // Add To review
  Future<bool> addEndlessReview(
      QuestionWithAnswersModel fourQuestionModel, String userId) async {
    bool value = await _fireStoreService.addQuestionsForReview(
        fourQuestionModel, userId);
    return value;
  }

  Future<bool> removeEndlessReview(
      QuestionWithAnswersModel fourQuestionModel, String userId) async {
    bool value = await _fireStoreService.removeQuestionsFromReview(
        fourQuestionModel, userId);
    return value;
  }

  Future<bool> addFlag(
      QuestionWithAnswersModel fourQuestionModel, String userId) async {
    bool value =
        await _fireStoreService.addFlagQuestions(fourQuestionModel, userId);
    return value;
  }

  Future<bool> removeFlag(
      QuestionWithAnswersModel fourQuestionModel, String userId) async {
    bool value = await _fireStoreService.removeFlaggedQuestions(
        fourQuestionModel, userId);
    return value;
  }

  switchToPremium(String transactionId, DateTime subscriptionFrom,
      DateTime subscriptionTo) {
    _fireStoreService.makeUserPremium(
        transactionId, subscriptionFrom, subscriptionTo);
  }

  Future<void> saveEndlessCorrectQuestionCount(
      String userId,
      String subCategoryId,
      String subCategoryName,
      String categoryId,
      String categoryName,
      int percentage) async {
    try {
      await _fireStoreService.saveEndlessCorrectQuestionCount(userId,
          subCategoryId, subCategoryName, categoryId, categoryName, percentage);
    } catch (error) {
      throw error;
    }
  }
}
