import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/endless_mode_your_answers_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/review_screens_module/review_mode_play_screens/review_mode_see_answers.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/review_question_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class ReviewModeGameOver extends StatefulWidget {
  @override
  _ReviewModeGameOverState createState() => _ReviewModeGameOverState();
}

class _ReviewModeGameOverState extends State<ReviewModeGameOver>
    with BaseClass {
  @override
  void initState() {
    var questionProvider =
        //Provider.of<QuestionProvider>(context, listen: false);

        // TODO: implement initState
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    var reviewModeQuestionProvider = Provider.of<ReviewQuestionProvider>(context);
    var sharePrefProvider = Provider.of<SharedPreferenceProvider>(context);
    var optionProvider = Provider.of<OptionProvider>(context);

    String highestScore;
    if (int.parse(sharePrefProvider.userDataModel.reviewModeHighScore) <
        reviewModeQuestionProvider.getCorrectAnswersCount) {
      optionProvider.setUserReviewHighScore(
          reviewModeQuestionProvider.getCorrectAnswersCount.toString(),
          sharePrefProvider.userDataModel.userId);
      highestScore = reviewModeQuestionProvider.getCorrectAnswersCount.toString();
    } else {
      highestScore = sharePrefProvider.userDataModel.reviewModeHighScore;
    }
    return WillPopScope(
      onWillPop: () async {

        reviewModeQuestionProvider
            .clearAnsweredQuestionsList();
        reviewModeQuestionProvider.setNewQuestion();
        // remainingCount.resetLife();
        popToPreviousScreen(context: context);
        popToPreviousScreen(context: context);

        return false;
      },
      child: Scaffold(
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
                          top: Dimensions.pixels_24,
                        ),
                        child: Text(
                          "Game Over!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: Dimensions.pixels_33,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: Dimensions.pixels_128),
                              decoration: getScreenBackgroundDecoration(),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.pixels_51,
                                  left: Dimensions.pixels_30,
                                  right: Dimensions.pixels_30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.pixels_10),
                                  topRight: Radius.circular(Dimensions.pixels_10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: Dimensions.pixels_20),
                                    child: Image(
                                      image: AssetImage(game_over),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.pixels_30,
                                  ),
                                  Text(
                                    "You got ${reviewModeQuestionProvider.getCorrectAnswersCount} out of ${reviewModeQuestionProvider.getAnsweredQuestions.length} correct",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: Dimensions.pixels_20,
                                  ),
                                  Text(
                                    "Your highest score is $highestScore",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  RoundedEdgeButton(
                                      color: Colors.black,
                                      text: "Try Again",
                                      textFontSize: Dimensions.pixels_18,
                                      height: Dimensions.pixels_60,
                                      textFontWeight: FontWeight.w400,
                                      topMargin: Dimensions.pixels_51,
                                      buttonRadius: 0,
                                      textColor: Colors.white,
                                      onPressed: (value) {

                                        reviewModeQuestionProvider
                                            .clearAnsweredQuestionsList();
                                        reviewModeQuestionProvider.setNewQuestion();


                                        Navigator.pop(context);
                                      },
                                      context: context),
                                  RoundedEdgeButton(
                                      color: successColor,
                                      text: "See Answers",
                                      textFontSize: Dimensions.pixels_18,
                                      height: Dimensions.pixels_60,
                                      buttonRadius: 0,
                                      topMargin: Dimensions.pixels_18,
                                      textColor: Colors.white,
                                      textFontWeight: FontWeight.w400,
                                      onPressed: (value) {
                                        pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: ReviewSeeAnswersPage(),
                                        );
                                      },
                                      context: context),
                                  RoundedEdgeButton(
                                      color: primaryColor,
                                      text: "Back to Menu",
                                      buttonRadius: 0,
                                      textFontSize: Dimensions.pixels_18,
                                      height: Dimensions.pixels_60,
                                      textFontWeight: FontWeight.w400,
                                      topMargin: Dimensions.pixels_18,
                                      bottomMargin: Dimensions.pixels_30,
                                      textColor: Colors.white,
                                      onPressed: (value) {
                                        reviewModeQuestionProvider
                                            .clearAnsweredQuestionsList();
                                        reviewModeQuestionProvider.setNewQuestion();


                                        // remainingCount.resetLife();
                                        int count = 0;
                                        Navigator.of(context)
                                            .popUntil((_) => count++ >= 2);
                                      },
                                      context: context),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}
