import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/question_withanswer_option_widget.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/endless_game_over_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/game_over_page.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/remianing_life_count_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

import 'endless_mode_your_answers_page.dart';

class QuestionsPageEndlessMode extends StatefulWidget {
  @override
  _QuestionsPageEndlessModeState createState() =>
      _QuestionsPageEndlessModeState();
}

class _QuestionsPageEndlessModeState extends State<QuestionsPageEndlessMode>
    with BaseClass {
  int currentQuestionNumber = 1;
  bool changeQuestion = true;

  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    var remainingLifeProvider =
        Provider.of<RemainingLifeCountProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
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
                        right: Dimensions.pixels_30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar(
                          initialRating: double.parse(remainingLifeProvider
                              .getRemainingLivesCount
                              .toString()),
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemSize: Dimensions.pixels_20,
                          itemCount:
                              remainingLifeProvider.getRemainingLivesCount,
                          ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.favorite,
                              color: questionBackgroundColor,
                            ),
                            half: Container(),
                            empty: Icon(
                              Icons.favorite_border,
                              color: questionBackgroundColor,
                            ),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            pushToNextScreenWithFadeAnimation(
                                context: context,
                                destination: EndlessGameOverPage());
                            /*pushToNextScreenWithFadeAnimation(
                                context: context,
                                destination: GameOverPage(
                                  isEndlessMode: true,
                                ));*/
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
                        top: Dimensions.pixels_15, left: Dimensions.pixels_30),
                    child: Text(
                      fourQuestionsProvider.getCurrentQuestion
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
                      fourQuestionsProvider.getCurrentQuestion.subCategory,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: Dimensions.pixels_33,
                      ),
                    ),
                  ),
                  /*Container(
                    margin: EdgeInsets.only(
                        top: Dimensions.pixels_15,
                        left: Dimensions.pixels_30,
                        right: Dimensions.pixels_30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image(
                          image: AssetImage(question_mark_question),
                          height: Dimensions.pixels_25,
                          width: Dimensions.pixels_25,
                        ),
                        SizedBox(
                          width: Dimensions.pixels_15,
                        ),
                        Text(
                          "05/",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: Dimensions.pixels_14,
                          ),
                        ),
                        Text(
                          "10",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: Dimensions.pixels_14,
                          ),
                        ),
                      ],
                    ),
                  ),*/
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
                        decoration:
                            getScreenBackgroundDecoration(color: Colors.white),
                        child: QuestionAnswerOptionsWidget(
                          question:
                              fourQuestionsProvider.getCurrentQuestion.question,
                     /*     answerOne: fourQuestionsProvider
                              .getCurrentQuestion.optionOne,
                          answerTwo: fourQuestionsProvider
                              .getCurrentQuestion.optionTwo,
                          answerThree: fourQuestionsProvider
                              .getCurrentQuestion.optionThree,
                          answerFour: fourQuestionsProvider
                              .getCurrentQuestion.optionFour,*/
                          correctionPosition: int.parse(fourQuestionsProvider
                              .getCurrentQuestion.correctAnswerOption),
                          isEndless: true,
                          onAnswerSelected: (value) {
                            if (remainingLifeProvider.getRemainingLivesCount ==
                                0) {
                              pushToNextScreenWithFadeAnimation(
                                context: context,
                                destination: EndlessGameOverPage(),
                              );
                              /* pushToNextScreenWithFadeAnimation(
                                  context: context,
                                  destination: GameOverPage(
                                    isEndlessMode: true,
                                  ));*/
                            } else {
                              fourQuestionsProvider.setCurrentQuestion(context);
                            }
                          },
                          context: context,
                        )),
                  )
                ],
              )),
            ),
          );
        },
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
