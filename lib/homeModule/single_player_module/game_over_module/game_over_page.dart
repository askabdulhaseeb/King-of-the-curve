import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/blocs/auth_bloc.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/endless_mode_your_answers_page.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/remaining_life_count_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class GameOverPage extends StatelessWidget with BaseClass {
  final Function isTryAgain;
  final bool isEndlessMode;

  GameOverPage({this.isTryAgain, this.isEndlessMode = false});

  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    var remainingCount = Provider.of<RemainingLifeCountProvider>(context);
    var authBloc = Provider.of<AuthBloc>(context);
    remainingCount.resetLife();
    if (isEndlessMode) {
      /* authBloc.currentUser.listen((event) {
        FireStoreService().addEndlessHighScore(
            fourQuestionsProvider.getCorrectAnswersCount, event.uid);
      });*/
    }
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
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: appBarTopMargin,
                    ),
                    isEndlessMode
                        ? Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.pixels_15,
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: Dimensions.pixels_20,
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: Dimensions.pixels_20,
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: Dimensions.pixels_20,
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: Dimensions.pixels_20,
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: Dimensions.pixels_20,
                                ),
                              ],
                            ),
                          )
                        : Container(),
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
                                  "You got ${fourQuestionsProvider.getCorrectAnswersCount} out of ${fourQuestionsProvider.getAnsweredQuestions.length} correct",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  height: Dimensions.pixels_20,
                                ),
                                Text(
                                  "Your highest score is 3",
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
                                      fourQuestionsProvider
                                          .setCurrentQuestion(context);
                                      fourQuestionsProvider
                                          .clearAnsweredQuestionsList();
                                      if (isEndlessMode) {
                                        //   remainingCount.resetLife();
                                      } else {
                                        fourQuestionsProvider.resetTimedTimer();
                                      }
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
                                          destination:
                                              YourAnswersEndlessMode());
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
                                      fourQuestionsProvider
                                          .setCurrentQuestion(context);
                                      fourQuestionsProvider
                                          .clearAnsweredQuestionsList();
                                      // remainingCount.resetLife();
                                      popToPreviousScreen(context: context);
                                      popToPreviousScreen(context: context);
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
    );
  }
}
