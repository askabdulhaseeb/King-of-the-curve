import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/options_module/options_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/review_screens_module/review_mode_option_module.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/review_screens_module/review_mode_play_screens/review_mode_questions_page.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';

class ReviewModePage extends StatefulWidget {
  @override
  _ReviewModePageState createState() => _ReviewModePageState();
}

class _ReviewModePageState extends State<ReviewModePage> with BaseClass {
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
                        "Review Mode",
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
                                pushToNextScreenWithFadeAnimation(
                                    context: context,
                                    destination: QuestionsPageReviewMode());
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
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {
                                pushToNextScreenWithFadeAnimation(
                                  context: context,
                                  destination: ReviewOptionsPage(),
                                );
                              },
                              context: context,
                              cardTitle: "Options",
                              cardTextColor: Colors.white,
                              cardTrailingImage: options_icon,
                              cardBackgroundColor: successColor,
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: Dimensions.pixels_30,
                                        right: Dimensions.pixels_30,
                                        top: Dimensions.pixels_30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Image(
                                              image:
                                                  AssetImage(review_mode_one)),
                                        ),
                                        Container(
                                          child: Image(
                                              image:
                                                  AssetImage(review_mode_two)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      child: Image(
                                          image: AssetImage(
                                              review_mode_background_image)),
                                    ),
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
