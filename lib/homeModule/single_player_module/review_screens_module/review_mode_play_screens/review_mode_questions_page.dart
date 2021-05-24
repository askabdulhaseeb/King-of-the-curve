import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../homeModule/single_player_module/end_less_mode_module/endless_mode_play/testing_endless/testing_question_widget.dart';
import '../../../../homeModule/single_player_module/game_over_module/review_mode_gameover.dart';
import '../../../../models/question_with_answers_model.dart';
import '../../../../providers/review_question_provider.dart';
import '../../../../utils/appColors.dart';
import '../../../../utils/baseClass.dart';
import '../../../../utils/constantWidgets.dart';
import '../../../../utils/constantsValues.dart';
import '../../../../utils/widget_dimensions.dart';

class QuestionsPageReviewMode extends StatefulWidget {
  @override
  createState() => _QuestionsPageReviewModeState();
}

class _QuestionsPageReviewModeState extends State<QuestionsPageReviewMode>
    with BaseClass {
  int currentQuestionNumber = 1;

  @override
  void initState() {
    final reviewQuestionsProvider = Provider.of<ReviewQuestionProvider>(
      context,
      listen: false,
    );
    reviewQuestionsProvider.getReviewQuestions();
    super.initState();
  }

  QuestionWithAnswersModel _currentSelectedQuestion;

  @override
  Widget build(BuildContext context) {
    final reviewQuestionsProvider = Provider.of<ReviewQuestionProvider>(
      context,
    );
    _currentSelectedQuestion = reviewQuestionsProvider.currentQuestion;
    return WillPopScope(
      onWillPop: () async {
        reviewQuestionsProvider.clearAnsweredQuestionsList();
        reviewQuestionsProvider.setNewQuestion();

        popToPreviousScreen(context: context);

        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: reviewQuestionsProvider.reviewQuestionsLength == 0
            ? Container(
                margin: EdgeInsets.only(top: Dimensions.pixels_20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      reviewQuestionsProvider.getMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.pixels_20,
                      ),
                    ),
                    reviewQuestionsProvider.getMessage !=
                            "No review Questions Found"
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              reviewQuestionsProvider.changeMessage(
                                "... Loading Review Questions",
                              );
                              popToPreviousScreen(context: context);
                            },
                            child: Container(
                              height: Dimensions.pixels_51,
                              margin: EdgeInsets.only(
                                left: Dimensions.pixels_20,
                                right: Dimensions.pixels_20,
                                top: Dimensions.pixels_20,
                              ),
                              color: editButtonColor,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Go To Previous Screen",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              )
            : LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraint.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: appbarTopMargin,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: Dimensions.pixels_15,
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      pushToNextScreenWithFadeAnimation(
                                        context: context,
                                        destination: ReviewModeGameOver(),
                                      );
                                    },
                                    child: Container(
                                      width: Dimensions.pixels_120,
                                      height: Dimensions.pixels_40,
                                      decoration: BoxDecoration(
                                        color: editButtonColor,
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.pixels_25,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "End Round",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimensions.pixels_14,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                              ),
                              child: Text(
                                _currentSelectedQuestion.category,
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
                                right: Dimensions.pixels_30,
                              ),
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
                                  questionImages: null,
                                  question: _currentSelectedQuestion.question,
                                  correctionPosition:
                                      _currentSelectedQuestion.answer,
                                  optionList: _currentSelectedQuestion.options,
                                  backgroundColor:
                                      _currentSelectedQuestion.backgroundColor,
                                  isReviewMode: true,
                                  isEndless: false,
                                  onAnswerSelected: (value) {
                                    int selectedAnswer = value;
                                    reviewQuestionsProvider
                                        .addAnsweredQuestions(
                                            reviewQuestionsProvider
                                                .currentQuestion,
                                            selectedAnswer);
                                    if ((selectedAnswer + 1).toString() ==
                                        _currentSelectedQuestion.answer) {
                                      reviewQuestionsProvider
                                          .changeBackgroundColor(
                                              successColor, selectedAnswer,
                                              context: context);
                                      reviewQuestionsProvider.incrementScore();
                                    } else {
                                      reviewQuestionsProvider
                                          .changeBackgroundColor(
                                        Colors.redAccent,
                                        selectedAnswer,
                                        context: context,
                                      );
                                    }
                                  },
                                  context: context,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void tryAgain() {
    Navigator.pop(context);
    setState(() {
      currentQuestionNumber = 1;
    });
  }
}
