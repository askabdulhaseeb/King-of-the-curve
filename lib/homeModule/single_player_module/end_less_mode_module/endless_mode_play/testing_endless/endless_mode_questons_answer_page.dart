import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/testing_endless/testing_question_widget.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/endless_game_over_page.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/remaining_life_count_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

class EndlessModeQuestionAnswerPage extends StatefulWidget {
  @override
  _EndlessModeQuestionAnswerPageState createState() =>
      _EndlessModeQuestionAnswerPageState();
}

class _EndlessModeQuestionAnswerPageState
    extends State<EndlessModeQuestionAnswerPage> with BaseClass {
  int currentQuestionNumber = 1;
  bool changeQuestion = true;
  QuestionWithAnswersModel _currentSelectedQuestion;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<RemainingLifeCountProvider>(context, listen: false).resetLife();
    var questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    questionProvider.setSelectedMode(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    var questionProvider = Provider.of<QuestionProvider>(context);
    var remainingLifeProvider =
        Provider.of<RemainingLifeCountProvider>(context);
    _currentSelectedQuestion = questionProvider.currentQuestion;
    var sharedPrefProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: RatingBar(
                                      initialRating: double.parse(
                                          remainingLifeProvider
                                              .getRemainingLivesCount
                                              .toString()),
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemSize: Dimensions.pixels_20,
                                      itemCount: remainingLifeProvider
                                          .getRemainingLivesCount,
                                      ratingWidget: RatingWidget(
                                        full: Icon(
                                          Icons.favorite,
                                          color: questionBackgroundColor,
                                        ),
                                        half: Container(),
                                        empty: Icon(
                                          Icons.favorite,
                                          color: questionBackgroundColor,
                                        ) /*Icon(
                                          Icons.favorite_border,
                                          color: questionBackgroundColor,
                                        )*/
                                        ,
                                      ),
                                      tapOnlyMode: false,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: EndlessGameOverPage());
                                    },
                                    child: Container(
                                      width: Dimensions.pixels_120,
                                      height: Dimensions.pixels_40,
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
                                  left: Dimensions.pixels_30),
                              child: Text(
                                _currentSelectedQuestion
                                    .category /* "Behavioral Science"*/,
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
                                    questionImages:
                                        _currentSelectedQuestion.questionImages,
                                    correctionPosition:
                                        _currentSelectedQuestion.answer,
                                    optionList:
                                        _currentSelectedQuestion.options,
                                    backgroundColor: _currentSelectedQuestion
                                        .backgroundColor,
                                    isEndless: true,
                                    isTimedMode: false,
                                    isReviewMode: false,
                                    onAnswerSelected: (value) {
                                      int selectedAnswer = value;
                                      questionProvider.addAnsweredQuestions(
                                          questionProvider.currentQuestion,
                                          selectedAnswer);
                                      if ((selectedAnswer + 1).toString() ==
                                          _currentSelectedQuestion.answer) {
                                        questionProvider.changeBackgroundColor(
                                            successColor, selectedAnswer);
                                        questionProvider.incrementScore();
                                      } else {
                                        questionProvider.changeBackgroundColor(
                                            Colors.redAccent, selectedAnswer,
                                            context: context);
                                        remainingLifeProvider.subtractLife(1);
                                      }
                                    },
                                    context: context,
                                  )),
                            )
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
