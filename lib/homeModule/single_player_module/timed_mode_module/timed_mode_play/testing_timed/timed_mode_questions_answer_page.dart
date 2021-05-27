import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/testing_endless/testing_question_widget.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/timed_game_over_page.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

class TimedModeQuestionAnswerPage extends StatefulWidget {
  @override
  _TimedModeQuestionAnswerPageState createState() =>
      _TimedModeQuestionAnswerPageState();
}

class _TimedModeQuestionAnswerPageState
    extends State<TimedModeQuestionAnswerPage>
    with TickerProviderStateMixin, BaseClass {
  AnimationController _controller;
  int currentQuestionNumber = 1;

  bool changeQuestion = true;
  QuestionWithAnswersModel _currentSelectedQuestion;

  @override
  void initState() {
    // TODO: implement initState
    var questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    questionProvider.setSelectedMode(2);
    super.initState();
  }

  initTimer(QuestionProvider questionProvider) {
    if (questionProvider.getTimerStatus) {
      _controller =
          AnimationController(vsync: this, duration: Duration(minutes: 1));
      _controller.forward().whenComplete(() {
        _controller.dispose();
        pushToNextScreenWithFadeAnimation(
          context: context,
          destination: TimedGameOverPage(
              /*isEndlessMode: false,*/
              ),
        );
      });
      questionProvider.cancelTimerStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    var questionProvider = Provider.of<QuestionProvider>(context);
    print(fourQuestionsProvider.getTimerStatus);
    _currentSelectedQuestion = questionProvider.currentQuestion;
    if (fourQuestionsProvider.getTimerStatus) {
      fourQuestionsProvider.resetTimedTimer();
      initTimer(questionProvider);
    }
    return WillPopScope(
      onWillPop: () async {
        _controller.dispose();
        questionProvider.setNewQuestion();
        questionProvider.clearAnsweredQuestionsList();
        // remainingCount.resetLife();
        popToPreviousScreen(context: context);
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _currentSelectedQuestion == null
            ? Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      primaryColor,
                    ),
                  ),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: appBarTopMargin,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.pixels_15,
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _controller.dispose();
                                    pushToNextScreenWithFadeAnimation(
                                      context: context,
                                      destination: TimedGameOverPage(),
                                    );
                                  },
                                  child: Container(
                                    width: Dimensions.pixels_120,
                                    height: Dimensions.pixels_40,
                                    alignment: Alignment.topRight,
                                    decoration: BoxDecoration(
                                        color: editButtonColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.pixels_25)),
                                    child: Center(
                                      child: Text(
                                        "End Round",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimensions.pixels_14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.pixels_30,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.pixels_15,
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30),
                            child: Text(
                              _currentSelectedQuestion
                                  .category /*fourQuestionsProvider.getCurrentQuestion.category*/,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.pixels_24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.pixels_12,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.pixels_15,
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30),
                            child: Text(
                              _currentSelectedQuestion.subCategory,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: Dimensions.pixels_33,
                              ),
                            ),
                          ),
                          Text(
                            "Correct answers is  ${_currentSelectedQuestion.answer}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.pixels_15,
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(alarm_clock),
                                  height: Dimensions.pixels_25,
                                  width: Dimensions.pixels_25,
                                ),
                                SizedBox(
                                  width: Dimensions.pixels_15,
                                ),
                                Countdown(
                                  animation: StepTween(
                                    begin: 1 * 60,
                                    end: 0,
                                  ).animate(_controller),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: Dimensions.pixels_30,
                                ),
                                padding: EdgeInsets.only(
                                  bottom: Dimensions.pixels_30,
                                  left: Dimensions.pixels_30,
                                  right: Dimensions.pixels_30,
                                  top: Dimensions.pixels_30,
                                ),
                                decoration: getScreenBackgroundDecoration(
                                    color: Colors.white),
                                child: TestingQuestionWidget(
                                  question: _currentSelectedQuestion.question,
                                  correctionPosition:
                                      _currentSelectedQuestion.answer,
                                  optionList: _currentSelectedQuestion.options,
                                  backgroundColor:
                                      _currentSelectedQuestion.backgroundColor,
                                  isEndless: false,
                                  isTimedMode: true,
                                  isReviewMode: false,
                                  onAnswerSelected: (value) {
                                    int selectedAnswer = value;
                                    questionProvider.addAnsweredQuestions(
                                        questionProvider.currentQuestion,
                                        selectedAnswer);
                                    if ((selectedAnswer + 1).toString() ==
                                        _currentSelectedQuestion.answer) {
                                      questionProvider
                                          .changeTimedBackgroundColor(
                                              successColor, selectedAnswer);
                                      questionProvider.incrementScore();
                                    } else {
                                      questionProvider
                                          .changeTimedBackgroundColor(
                                              Colors.redAccent, selectedAnswer,
                                              context: context);
                                    }
                                  },
                                  context: context,
                                  questionImages:
                                      _currentSelectedQuestion.questionImages,
                                )),
                          ),
                        ],
                      )),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void tryAgain() {
    Navigator.pop(context);
    setState(() {
      currentQuestionNumber = 1;
    });
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: Dimensions.pixels_18,
        color: Colors.white,
      ),
    );
  }
}
