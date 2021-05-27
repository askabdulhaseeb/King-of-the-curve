import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/timed_mode_module/timed_mode_option_module/timed_option_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/timed_mode_module/timed_mode_play/testing_timed/timed_mode_questions_answer_page.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';
import 'package:provider/provider.dart';
import 'leaderboard_module/timed_leadership_page.dart';

class TimedModePage extends StatefulWidget {
  @override
  _TimedModePageState createState() => _TimedModePageState();
}

class _TimedModePageState extends State<TimedModePage> with BaseClass {
  @override
  Widget build(BuildContext context) {
    var questionModel = Provider.of<QuestionProvider>(context, listen: false);

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
                    getCustomAppBar(context, topMargin: appBarTopMargin),
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.pixels_15,
                          left: Dimensions.pixels_30),
                      child: Text(
                        "Timed Mode",
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
                                questionModel.resetTimedTimer();
                                pushToNextScreenWithFadeAnimation(
                                    context: context,
                                    destination:
                                        TimedModeQuestionAnswerPage /*QuestionsPageTimedMode*/ ());
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
                                    destination: TimedLeaderShipModule());
                              },
                              context: context,
                              cardTextColor: Colors.white,
                              cardTitle: "Leaderboards",
                              cardBackgroundColor: timedModeBackgroundColor,
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
                                    destination: TimedOptionPage());
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
