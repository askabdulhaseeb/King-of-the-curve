import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/review_question_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

class TestingQuestionWidget extends StatefulWidget {
  final String question;

  /* final String answerOne;
  final String answerTwo;
  final String answerThree;
  final String answerFour;*/
  final String correctionPosition;
  final Function onAnswerSelected;
  final List<OptionList> optionList;
  final List<NetworkImage> questionImages;

  final BuildContext context;
  final bool isEndless;
  final isTimedMode;

  final Color backgroundColor;
  final bool isReviewMode;

  TestingQuestionWidget(
      {@required this.question,
      @required this.optionList,
      @required this.questionImages,
      @required this.correctionPosition,
      @required this.context,
      this.backgroundColor,
      this.isReviewMode = false,
      this.isTimedMode = false,
      this.isEndless = false,
      @required this.onAnswerSelected});

  @override
  _TestingQuestionWidgetState createState() => _TestingQuestionWidgetState();
}

class _TestingQuestionWidgetState extends State<TestingQuestionWidget> {
  bool isTapped = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double _scaleFactor = 2.0;

  @override
  Widget build(BuildContext context) {
    print(widget.questionImages);
    var testingProvider = Provider.of<QuestionProvider>(context);
    var reviewModeProvider = Provider.of<ReviewQuestionProvider>(context);
    return Scaffold(
      key: GlobalKey(),
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
            ...widget.optionList.map((answer) {
              return Column(
                children: [
                  BouncingWidget(
                    scaleFactor: _scaleFactor,
                    onPressed: () {
                      if (widget.isReviewMode) {
                        if (!reviewModeProvider.getReviewAnswerTappedStatus) {
                          reviewModeProvider.setAnswerStatus(true);
                          widget.onAnswerSelected(
                              widget.optionList.indexOf(answer));
                        }
                        print(reviewModeProvider.getReviewAnswerTappedStatus);
                      } else {
                        if (!testingProvider.getAnswerTappedStatus) {
                          testingProvider.setAnswerStatus(true);
                          widget.onAnswerSelected(
                              widget.optionList.indexOf(answer));
                        }
                        print(testingProvider.getAnswerTappedStatus);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      key: GlobalKey(),
                      padding: EdgeInsets.only(
                          left: Dimensions.pixels_14,
                          right: Dimensions.pixels_14,
                          top: Dimensions.pixels_18,
                          bottom: Dimensions.pixels_18),
                      decoration: BoxDecoration(
                        color: answer.optionBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.pixels_5),
                      ),
                      child: Text(
                        answer.optionText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.pixels_16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.pixels_10,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
