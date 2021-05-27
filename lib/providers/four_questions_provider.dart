import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kings_of_the_curve/models/four_question_model.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class FourQuestionsProvider with ChangeNotifier, BaseClass {
  List<List<dynamic>> _csvFourQuestions;
  FourQuestionModel _currentQuestion;
  List<FourQuestionModel> _answeredQuestions;
  int _correctAnswersCount;
  bool _initTimer;

  FourQuestionsProvider() {
    _csvFourQuestions = [];
    _answeredQuestions = [];
    _correctAnswersCount = 0;
    _initTimer = true;
  }

  void resetTimedTimer() {
    _initTimer = true;
  }

  void cancelTimerStatus() {
    _initTimer = false;
  }

  bool get getTimerStatus => _initTimer;

  List<List<dynamic>> get getFourOptionQuestions => _csvFourQuestions;

  void setFourQuestions(List<List<dynamic>> fourQuestions) {
    _csvFourQuestions = fourQuestions;
  }

  List<FourQuestionModel> get getAnsweredQuestions => _answeredQuestions;

  int get getCorrectAnswersCount => _correctAnswersCount;

  void incrementCorrectAnswerCount() {
    _correctAnswersCount++;
    /*notifyListeners();*/
  }

  void clearAnsweredQuestionsList() {
    _answeredQuestions.clear();
    _correctAnswersCount = 0;
    notifyListeners();
  }

  void addAnsweredQuestions(FourQuestionModel fourQuestionModel) {
    _answeredQuestions.add(_currentQuestion);
  }

  void setCurrentQuestion(BuildContext context) async {
    int randomNumber = Random().nextInt(_csvFourQuestions.length) + 1;
    //List<String> list = await FireStoreService(context).getSubCategoriesName();
    List<String> list = _csvFourQuestions
        .elementAt(randomNumber)
        .map((e) => e.toString())
        .toList();
    _currentQuestion = FourQuestionModel(
        category: list.elementAt(0),
        question: list.elementAt(1),
        /*  optionOne: list.elementAt(2),
        optionTwo: list.elementAt(3),
        optionThree: list.elementAt(4),
        optionFour: list.elementAt(5),*/
        correctAnswerOption: list.elementAt(6),
        explanation: list.elementAt(7),
        trial: list.elementAt(8),
        subCategory: list.elementAt(9),
        image: list.elementAt(10),
        id: list.elementAt(11),
        isAnswered: false,
        selectedAnswerOption: "-1");
    notifyListeners();
  }

  FourQuestionModel get getCurrentQuestion {
    return _currentQuestion;
  }
}
