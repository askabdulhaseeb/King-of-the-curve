import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class YourAnswersReviewMode extends StatelessWidget with BaseClass {
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
                children: [
                  getCustomAppBar(context, topMargin: appBarTopMargin),
                  Container(
                    margin: EdgeInsets.only(
                        top: Dimensions.pixels_15, left: Dimensions.pixels_30),
                    child: Text(
                      "Your Answers",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.pixels_33,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: Dimensions.pixels_30,
                      ),
                      padding: EdgeInsets.only(bottom: Dimensions.pixels_30),
                      decoration: getScreenBackgroundDecoration(
                          color: settingAccountDetailBackgroundColor),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30,
                                top: Dimensions.pixels_30),
                            child: _getQuestionsWithAnswersWidget(
                                title: "Question 1"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30,
                                top: Dimensions.pixels_30),
                            child: _getQuestionsWithAnswersWidget(
                                title: "Question 2"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30,
                                top: Dimensions.pixels_30),
                            child: _getQuestionsWithAnswersWidget(
                                title: "Question 3"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30,
                                top: Dimensions.pixels_30),
                            child: _getQuestionsWithAnswersWidget(
                                title: "Question 4"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.pixels_30,
                                right: Dimensions.pixels_30,
                                top: Dimensions.pixels_30),
                            child: _getQuestionsWithAnswersWidget(
                                title: "Question 5"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}

Widget _getQuestionsWithAnswersWidget({String title}) {
  return Container(
    padding: EdgeInsets.all(Dimensions.pixels_20),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.pixels_5)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: Dimensions.pixels_16,
                  fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Image(
                  image: AssetImage(bookmark_fill),
                  height: Dimensions.pixels_20,
                  width: Dimensions.pixels_20,
                ),
                SizedBox(
                  width: Dimensions.pixels_10,
                ),
                Image(
                  image: AssetImage(flag_bug_report),
                  height: Dimensions.pixels_20,
                  width: Dimensions.pixels_20,
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: Dimensions.pixels_20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _gertAnswerTile(
                backgroundColor: wrongAnswerBackground,
                textColor: wrongAnswerTextColor,
                title: "Answer A",
                subTitle: "10%"),
            SizedBox(
              width: Dimensions.pixels_15,
            ),
            _gertAnswerTile(
                backgroundColor: dividerColor,
                textColor: notAttemptedAnswerTextColor,
                title: "Answer B",
                subTitle: "20%"),
          ],
        ),
        SizedBox(
          height: Dimensions.pixels_15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _gertAnswerTile(
                backgroundColor: correctAnswerBackgroundColor,
                textColor: successColor,
                title: "Answer C",
                subTitle: "15%"),
            SizedBox(
              width: Dimensions.pixels_15,
            ),
            _gertAnswerTile(
                backgroundColor: dividerColor,
                textColor: notAttemptedAnswerTextColor,
                title: "Answer D",
                subTitle: "20%"),
          ],
        ),
        SizedBox(
          height: Dimensions.pixels_20,
        ),
        getDivider(),
        SizedBox(
          height: Dimensions.pixels_15,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Explanation etc etc",
            style: TextStyle(
                color: notAttemptedAnswerTextColor,
                fontSize: Dimensions.pixels_14,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    ),
  );
}

Widget _gertAnswerTile(
    {String title, Color backgroundColor, Color textColor, String subTitle}) {
  return Expanded(
    child: Container(
      height: 40,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.pixels_5)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: Dimensions.pixels_14,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  color: textColor,
                  fontSize: Dimensions.pixels_14,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
