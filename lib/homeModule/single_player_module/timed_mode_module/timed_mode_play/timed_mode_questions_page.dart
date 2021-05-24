import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/question_withanswer_option_widget.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/game_over_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/game_over_module/timed_game_over_page.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

class QuestionsPageTimedMode extends StatefulWidget {
  @override
  _QuestionsPageTimedModeState createState() => _QuestionsPageTimedModeState();
}

class _QuestionsPageTimedModeState extends State<QuestionsPageTimedMode>
    with TickerProviderStateMixin, BaseClass {
  AnimationController _controller;
  int currentQuestionNumber = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  initTimer(FourQuestionsProvider fourQuestionsProvider) {
    if (fourQuestionsProvider.getTimerStatus) {
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
        /*pushToNextScreenWithFadeAnimation(
          context: context,
          destination: GameOverPage(
            isEndlessMode: false,
          ),
        );*/
      });
      fourQuestionsProvider.cancelTimerStatus();
    }
  }



  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    print(fourQuestionsProvider.getTimerStatus);
    if (fourQuestionsProvider.getTimerStatus) {
      fourQuestionsProvider.resetTimedTimer();
      initTimer(fourQuestionsProvider);
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /*Container(
                          child: Row(
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
                        GestureDetector(
                          onTap: () {
                            _controller.dispose();

                            pushToNextScreenWithFadeAnimation(
                              context: context,
                              destination: TimedGameOverPage(
                                /*isEndlessMode: false,*/
                              ),
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
                      fourQuestionsProvider.getCurrentQuestion.category,
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
                      fourQuestionsProvider.getCurrentQuestion.subCategory,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: Dimensions.pixels_33,
                      ),
                    ),
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
                      decoration:
                          getScreenBackgroundDecoration(color: Colors.white),
                      child: QuestionAnswerOptionsWidget(
                        question:
                            fourQuestionsProvider.getCurrentQuestion.question,
                      /*  answerOne:
                            fourQuestionsProvider.getCurrentQuestion.optionOne,
                        answerTwo:
                            fourQuestionsProvider.getCurrentQuestion.optionTwo,
                        answerThree: fourQuestionsProvider
                            .getCurrentQuestion.optionThree,
                        answerFour:
                            fourQuestionsProvider.getCurrentQuestion.optionFour,*/
                        correctionPosition: int.parse(fourQuestionsProvider
                            .getCurrentQuestion.correctAnswerOption),
                        isEndless: false,
                        onAnswerSelected: (value) {
                          fourQuestionsProvider.setCurrentQuestion(context);
                        },
                        context: context,
                      ),
                    ),
                  ),
                ],
              )),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() async {
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
