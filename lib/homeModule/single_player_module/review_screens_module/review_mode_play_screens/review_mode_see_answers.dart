import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
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
import 'package:provider/provider.dart';

class ReviewSeeAnswersPage extends StatefulWidget {
  @override
  _ReviewSeeAnswersPageState createState() => _ReviewSeeAnswersPageState();
}

class _ReviewSeeAnswersPageState extends State<ReviewSeeAnswersPage>
    with BaseClass {
  @override
  Widget build(BuildContext context) {
    var questionProvider = Provider.of<QuestionProvider>(context);
    var reviewQuestionProvider = Provider.of<ReviewQuestionProvider>(context);
    var optionProvider = Provider.of<OptionProvider>(context);
    var sharedPrefProvider = Provider.of<SharedPreferenceProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Column(
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
                  child: reviewQuestionProvider.getAnsweredQuestions.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: reviewQuestionProvider
                              .getAnsweredQuestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.pixels_30,
                                  right: Dimensions.pixels_30,
                                  top: Dimensions.pixels_30),
                              child: _getQuestionsWithAnswersWidget(
                                  reviewQuestionProvider.getAnsweredQuestions
                                      .elementAt(index),
                                  optionProvider,
                                  reviewQuestionProvider,
                                  questionProvider,
                                  sharedPrefProvider,
                                  index,
                                  title: "Question ${index + 1}"),
                            );
                          })
                      : Container(
                          child: Center(
                            child: Text(
                              "You haven't answered any questions in this round.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: titleColor,
                              ),
                            ),
                          ),
                        ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _getQuestionsWithAnswersWidget(
      QuestionWithAnswersModel fourQuestionModel,
      OptionProvider optionProvider,
      ReviewQuestionProvider reviewQuestionProvider,
      QuestionProvider questionProvider,
      SharedPreferenceProvider sharedPreferenceProvider,
      int elementPosition,
      {String title}) {
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
                  GestureDetector(
                    onTap: () async {
                      if (sharedPreferenceProvider
                          .userDataModel.bookMarkedQuestions
                          .contains(fourQuestionModel.documentId)) {
                        // remove from user review list
                        showCircularDialog(context);
                        bool value = await questionProvider.removeEndlessReview(
                            fourQuestionModel,
                            sharedPreferenceProvider.userDataModel.userId);

                        /// remove locally
                        reviewQuestionProvider.removeQuestionFromList(
                            reviewQuestionProvider.getAnsweredQuestions
                                .elementAt(elementPosition),
                            context);
                        //reviewQuestionProvider.getAnsweredQuestions.removeAt(elementPosition);
                        popToPreviousScreen(context: context);

                        setState(() {});
                      } else {
                        // add in user review list
                        showCircularDialog(context);
                        bool value = await questionProvider.addEndlessReview(
                            fourQuestionModel,
                            sharedPreferenceProvider.userDataModel.userId);
                        popToPreviousScreen(context: context);
                        reviewQuestionProvider.addQuestionsToList(
                            fourQuestionModel, context);

                        /// add locally
                        setState(() {});
                      }
                    },
                    child: Image(
                      image: AssetImage(bookmark_fill),
                      height: Dimensions.pixels_20,
                      width: Dimensions.pixels_30,
                      color: sharedPreferenceProvider
                              .userDataModel.bookMarkedQuestions
                              .contains(fourQuestionModel.documentId)
                          ? singlePlayerTextColor
                          : Colors.grey,
                    ),
                  ),
                  /*SizedBox(
                    width: Dimensions.pixels_10,
                  ),*/
                  /*Image(
                    image: AssetImage(flag_bug_report),
                    height: Dimensions.pixels_20,
                    width: Dimensions.pixels_20,
                  ),*/
                ],
              )
            ],
          ),
          SizedBox(
            height: Dimensions.pixels_20,
          ),
          Text(
            fourQuestionModel.question,
            style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.pixels_16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: Dimensions.pixels_20,
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: Dimensions.pixels_5,
                mainAxisSpacing: Dimensions.pixels_5),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return Container(
                child: _gertAnswerTile(
                    backgroundColor: getOptionBackgroundColor(
                        correctAnswer: fourQuestionModel.answer,
                        selectedAnswer: fourQuestionModel.selectedAnswer,
                        optionIndex: (index + 1).toString()),
                    textColor: getOptionTextColor(
                        correctAnswer: fourQuestionModel.answer,
                        selectedAnswer: fourQuestionModel.selectedAnswer,
                        optionIndex: (index + 1).toString()),
                    title:
                        fourQuestionModel.options.elementAt(index).optionText,
                    subTitle: "10%"),
              );
            },
            itemCount: fourQuestionModel.options.length,
          ),
          SizedBox(
            height: Dimensions.pixels_15,
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
              fourQuestionModel.explanation,
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
}

Color getOptionBackgroundColor({
  @required String correctAnswer,
  @required String selectedAnswer,
  @required String optionIndex,
}) {
  if (selectedAnswer == optionIndex) {
    if (correctAnswer == selectedAnswer) {
      return correctAnswerBackgroundColor;
    } else {
      return wrongAnswerBackground;
    }
  } else {
    if (correctAnswer == optionIndex) {
      return correctAnswerBackgroundColor;
    } else {
      return dividerColor;
    }
  }
}

Color getOptionTextColor({
  @required String correctAnswer,
  @required String selectedAnswer,
  @required String optionIndex,
}) {
  if (selectedAnswer == optionIndex) {
    if (correctAnswer == selectedAnswer) {
      return successColor;
    } else {
      return wrongAnswerTextColor;
    }
  } else {
    if (correctAnswer == optionIndex) {
      return successColor;
    } else {
      return notAttemptedAnswerTextColor;
    }
  }
}

Widget _gertAnswerTile(
    {String title, Color backgroundColor, Color textColor, String subTitle}) {
  return Container(
    padding: EdgeInsets.all(Dimensions.pixels_15),
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.pixels_5)),
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: Dimensions.pixels_14,
          ),
        ),
      ),
    ),
  );
}
