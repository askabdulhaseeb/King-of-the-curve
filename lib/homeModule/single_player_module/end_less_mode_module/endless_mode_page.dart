import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/endless_mode_questions_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/endless_mode_your_answers_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/options_module/options_page.dart';
import 'package:kings_of_the_curve/homeModule/testing_files/optionTesting.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';
import 'package:kings_of_the_curve/widgets/card_widget_with_hint.dart';

import 'endless_mode_play/testing_endless/endless_mode_questons_answer_page.dart';
import 'leaderboard_module/end_less_leadership_page.dart';

class EndlessModePage extends StatefulWidget {
  @override
  _EndlessModePageState createState() => _EndlessModePageState();
}

class _EndlessModePageState extends State<EndlessModePage> with BaseClass {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getCustomAppBar(context, topMargin: appbarTopMargin),
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.pixels_15,
                          left: Dimensions.pixels_30),
                      child: Text(
                        "Endless Mode",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: Dimensions.pixels_33,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.pixels_30),
                        decoration: getScreenBackgroundDecoration(),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child:
                                        Image(image: AssetImage(endless_one)),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    child:
                                        Image(image: AssetImage(endless_two)),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child:
                                        Image(image: AssetImage(endless_three)),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Dimensions.pixels_30,
                                  ),
                                  HomeCardWidget(
                                    cardHeight: Dimensions.pixels_120,
                                    leftMargin: Dimensions.pixels_30,
                                    rightMargin: Dimensions.pixels_30,
                                    cardRadius: Dimensions.pixels_15,
                                    onCardClicked: (value) {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination:
                                              EndlessModeQuestionAnswerPage() /*QuestionsPageEndlessMode()*/);
                                    },
                                    context: context,
                                    cardTitle: "Play",
                                    cardTextFontSize: Dimensions.pixels_24,
                                    cardTextColor: Colors.white,
                                    cardBackgroundColor: editButtonColor,
                                    cardTrailingImage: play_icon,
                                  ),
                                  SizedBox(
                                    height: Dimensions.pixels_30,
                                  ),
                                  HomeCardWidget(
                                    cardHeight: Dimensions.pixels_120,
                                    leftMargin: Dimensions.pixels_30,
                                    rightMargin: Dimensions.pixels_30,
                                    cardRadius: Dimensions.pixels_15,
                                    cardTextFontSize: Dimensions.pixels_24,
                                    onCardClicked: (value) {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination:
                                              EndLessLeaderShipModule());
                                    },
                                    context: context,
                                    cardTextColor: Colors.white,
                                    cardTitle: "Leaderboards",
                                    cardBackgroundColor: flashcardsModeColor,
                                    cardTrailingImage: leader_borders_icon,
                                  ),
                                  SizedBox(
                                    height: Dimensions.pixels_30,
                                  ),
                                  HomeCardWidget(
                                    cardHeight: Dimensions.pixels_120,
                                    leftMargin: Dimensions.pixels_30,
                                    rightMargin: Dimensions.pixels_30,
                                    cardTextFontSize: Dimensions.pixels_24,
                                    cardRadius: Dimensions.pixels_15,
                                    onCardClicked: (value) {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: OptionTestingPage(
                                            isEndlessMode: true,
                                          ) /*OptionsPage(
                                          isEndlessMode: true,
                                        ),*/
                                          );
                                    },
                                    context: context,
                                    cardTitle: "Options",
                                    cardTextColor: Colors.white,
                                    cardTrailingImage: options_icon,
                                    cardBackgroundColor: successColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
