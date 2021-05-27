import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/remaining_life_count_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

class QuestionAnswerOptionsWidget extends StatefulWidget {
  final String question;
/*  final String answerOne;
  final String answerTwo;
  final String answerThree;
  final String answerFour;*/
  final int correctionPosition;
  final Function onAnswerSelected;
  final BuildContext context;
  final bool isEndless;

  QuestionAnswerOptionsWidget(
      {@required this.question,
      /*     @required this.answerOne,
      @required this.answerTwo,
      @required this.answerThree,
      @required this.answerFour,*/
      @required this.correctionPosition,
      @required this.context,
      this.isEndless = false,
      @required this.onAnswerSelected});

  @override
  _QuestionAnswerOptionsWidgetState createState() =>
      _QuestionAnswerOptionsWidgetState();
}

class _QuestionAnswerOptionsWidgetState
    extends State<QuestionAnswerOptionsWidget> {
  Color answer1Background;
  Color answer2Background;
  Color answer3Background;
  Color answer4Background;
  Color answer1TextBackground;
  Color answer2TextBackground;
  Color answer3TextBackground;
  Color answer4TextBackground;
  var remainingLifeCounterProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    answer1Background = dividerColor;
    answer2Background = dividerColor;
    answer3Background = dividerColor;
    answer4Background = dividerColor;
    answer1TextBackground = Colors.black;
    answer2TextBackground = Colors.black;
    answer3TextBackground = Colors.black;
    answer4TextBackground = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    remainingLifeCounterProvider =
        Provider.of<RemainingLifeCountProvider>(context);
    var questionsProvider = Provider.of<FourQuestionsProvider>(context);
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: Dimensions.pixels_14,
                  right: Dimensions.pixels_14,
                  top: Dimensions.pixels_25,
                  bottom: Dimensions.pixels_25),
              decoration: BoxDecoration(
                color: questionBackgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.pixels_15),
              ),
              child: Text(
                widget.question,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: Dimensions.pixels_20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.correctionPosition == 1) {
                    answer1Background = successColor;
                    answer1TextBackground = Colors.white;

                    questionsProvider.incrementCorrectAnswerCount();
                  } else {
                    answer1Background = Colors.redAccent;
                    answer1TextBackground = Colors.white;
                    if (widget.isEndless)
                      remainingLifeCounterProvider.subtractLife(1);
                  }
                });
                questionsProvider.getCurrentQuestion.selectedAnswerOption = "1";
                questionsProvider
                    .addAnsweredQuestions(questionsProvider.getCurrentQuestion);
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    answer1Background = dividerColor;
                    answer1TextBackground = Colors.black;
                    widget.onAnswerSelected(
                        context); // Here you can write your code for open new view
                  });
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimensions.pixels_14,
                    right: Dimensions.pixels_14,
                    top: Dimensions.pixels_18,
                    bottom: Dimensions.pixels_18),
                decoration: BoxDecoration(
                  color: answer1Background,
                  borderRadius: BorderRadius.circular(Dimensions.pixels_5),
                ),
                child: Text(
                  "" /*widget.answerOne*/,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: answer1TextBackground,
                      fontSize: Dimensions.pixels_16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.pixels_20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.correctionPosition == 2) {
                    answer2Background = successColor;
                    answer2TextBackground = Colors.white;

                    questionsProvider.incrementCorrectAnswerCount();
                  } else {
                    answer2Background = Colors.redAccent;
                    answer2TextBackground = Colors.white;
                    if (widget.isEndless)
                      remainingLifeCounterProvider.subtractLife(1);
                  }
                });
                questionsProvider.getCurrentQuestion.selectedAnswerOption = "2";
                questionsProvider
                    .addAnsweredQuestions(questionsProvider.getCurrentQuestion);
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    answer2Background = dividerColor;
                    answer2TextBackground = Colors.black;
                    widget.onAnswerSelected(
                        context); // Here you can write your code for open new view
                  });
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimensions.pixels_14,
                    right: Dimensions.pixels_14,
                    top: Dimensions.pixels_18,
                    bottom: Dimensions.pixels_18),
                decoration: BoxDecoration(
                  color: answer2Background,
                  borderRadius: BorderRadius.circular(Dimensions.pixels_5),
                ),
                child: Text(
                  "" /*widget.answerTwo*/,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: answer2TextBackground,
                      fontSize: Dimensions.pixels_16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.pixels_20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.correctionPosition == 3) {
                    answer3Background = successColor;
                    answer3TextBackground = Colors.white;

                    questionsProvider.incrementCorrectAnswerCount();
                  } else {
                    answer3Background = Colors.redAccent;
                    answer3TextBackground = Colors.white;
                    if (widget.isEndless)
                      remainingLifeCounterProvider.subtractLife(1);
                  }
                });
                questionsProvider.getCurrentQuestion.selectedAnswerOption = "3";
                questionsProvider
                    .addAnsweredQuestions(questionsProvider.getCurrentQuestion);
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    answer3Background = dividerColor;
                    answer3TextBackground = Colors.black;
                    widget.onAnswerSelected(
                        context); // Here you can write your code for open new view
                  });
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimensions.pixels_14,
                    right: Dimensions.pixels_14,
                    top: Dimensions.pixels_18,
                    bottom: Dimensions.pixels_18),
                decoration: BoxDecoration(
                  color: answer3Background,
                  borderRadius: BorderRadius.circular(Dimensions.pixels_5),
                ),
                child: Text(
                  "" /*widget.answerThree*/,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: answer3TextBackground,
                      fontSize: Dimensions.pixels_16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.pixels_20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.correctionPosition == 4) {
                    answer4Background = successColor;
                    answer4TextBackground = Colors.white;
                    questionsProvider.incrementCorrectAnswerCount();
                  } else {
                    answer4Background = Colors.redAccent;
                    answer4TextBackground = Colors.white;
                    if (widget.isEndless)
                      remainingLifeCounterProvider.subtractLife(1);
                  }
                });
                questionsProvider.getCurrentQuestion.selectedAnswerOption = "4";
                questionsProvider
                    .addAnsweredQuestions(questionsProvider.getCurrentQuestion);
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    answer4Background = dividerColor;
                    answer4TextBackground = Colors.black;
                    widget.onAnswerSelected(
                        context); // Here you can write your code for open new view
                  });
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimensions.pixels_14,
                    right: Dimensions.pixels_14,
                    top: Dimensions.pixels_18,
                    bottom: Dimensions.pixels_18),
                decoration: BoxDecoration(
                  color: answer4Background,
                  borderRadius: BorderRadius.circular(Dimensions.pixels_5),
                ),
                child: Text(
                  "" /*widget.answerFour*/,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: answer4TextBackground,
                      fontSize: Dimensions.pixels_16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
