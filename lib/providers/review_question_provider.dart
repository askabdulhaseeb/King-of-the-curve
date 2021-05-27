import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/review_mode_gameover.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/services/firestore_service.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class ReviewQuestionProvider with ChangeNotifier, BaseClass {
  List<QuestionWithAnswersModel> _reviewQuestionsList;
  FireStoreService _fireStoreService;
  int _reviewCorrectAnswersCount;
  List<QuestionWithAnswersModel> _reviewAnsweredQuestions;
  bool _initTimer;
  QuestionWithAnswersModel _currentQuestion;
  BuildContext _context;
  int _currentIndex = 0;
  int _reviewQuestionsTotalLength = 0;
  bool _isReviewAnswerTapped;

  ReviewQuestionProvider(BuildContext context) {
    _reviewQuestionsList = [];
    _reviewAnsweredQuestions = [];
    _reviewCorrectAnswersCount = 0;
    _fireStoreService = FireStoreService(context);
    _initTimer = true;
    _context = context;
    _isReviewAnswerTapped = false;
  }

  String _message = "... Loading Review Questions";

  String get getMessage => _message;

  void changeMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  void getReviewQuestions() async {
    List<QuestionWithAnswersModel> list =
        await _fireStoreService.getReviewQuestions();
    print(list.length);
    _setReviewQuestions(list);
  }

  void _setReviewQuestions(List<QuestionWithAnswersModel> questionData) {
    _reviewQuestionsList = questionData;
    _reviewQuestionsTotalLength = questionData.length;
    _currentIndex = 0;
    if (questionData.length > 0)
      setNewQuestion();
    else
      changeMessage("No review Questions Found");
  }

  void setNewQuestion({BuildContext context}) {
    print(_currentIndex);
    print(_reviewQuestionsList.length);
    if (_currentIndex < _reviewQuestionsList.length) {
      _currentQuestion = _reviewQuestionsList.elementAt(_currentIndex);
      _currentIndex++;
      _isReviewAnswerTapped = false;
      notifyListeners();
    } else {
      if (_reviewQuestionsList.length > 0)
        //_isReviewAnswerTapped = false;
        pushToNextScreenWithFadeAnimation(
            context: context, destination: ReviewModeGameOver());
    }
  }

  void removeQuestionFromList(
      QuestionWithAnswersModel model, BuildContext context) {
    int index = _reviewQuestionsList.indexOf(model);
    _reviewQuestionsList.removeAt(index);
    print("QUESTION INDEX $index");
    _currentIndex = 0;
    if (_currentIndex < _reviewQuestionsList.length) {
      _currentQuestion = _reviewQuestionsList.elementAt(_currentIndex);
      _currentIndex++;
      _isReviewAnswerTapped = false;
      notifyListeners();
    } else if (_reviewQuestionsList.length >= 0) {
      changeMessage("No review Questions Found");
    }
  }

  void addQuestionsToList(
      QuestionWithAnswersModel model, BuildContext context) {
    _reviewQuestionsList.add(model);
    notifyListeners();
  }

  bool get getReviewAnswerTappedStatus => _isReviewAnswerTapped;

  void setAnswerStatus(bool isStatus) {
    _isReviewAnswerTapped = isStatus;
  }

  int get currentIndex => _currentIndex;

  int _getReviewQuestionsLength() {
    return _reviewQuestionsList.length;
  }

  int get reviewQuestionsLength =>
      /*_reviewQuestionsTotalLength*/ _getReviewQuestionsLength();

  // get current question selected from the list
  // List<QuestionWithAnswersModel> get getAllQuestions => _reviewQuestionsList;

  QuestionWithAnswersModel get currentQuestion => _currentQuestion;

  void changeBackgroundColor(Color backgroundNewColor, int index,
      {BuildContext context}) {
    _currentQuestion.options.elementAt(index).optionBackgroundColor =
        backgroundNewColor;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      _currentQuestion.options.elementAt(index).optionBackgroundColor =
          dividerColor;
      setNewQuestion(context: context);
    });
  }

  // increment score on correct question
  void incrementScore() {
    _reviewCorrectAnswersCount++;
  }

  // add answered  questions to the list
  void addAnsweredQuestions(QuestionWithAnswersModel questionWithAnswersModel,
      int selectedAnswerIndex) {
    _currentQuestion.selectedAnswer = (selectedAnswerIndex + 1).toString();
    _reviewAnsweredQuestions.add(_currentQuestion);
  }

  // get answered questions
  List<QuestionWithAnswersModel> get getAnsweredQuestions =>
      _reviewAnsweredQuestions;

  // get correct answers count
  int get getCorrectAnswersCount => _reviewCorrectAnswersCount;

  void clearAnsweredQuestionsList() {
    _reviewAnsweredQuestions.clear();
    _reviewCorrectAnswersCount = 0;
    _currentIndex = 0;
    notifyListeners();
  }
}
