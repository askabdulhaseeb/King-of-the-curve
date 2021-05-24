import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';

import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/size_config.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';
import 'package:provider/provider.dart';

import 'institution_leadership_pages/global_leaderboard_high_score_page.dart';
import 'institution_leadership_pages/institution_leadership_high_score_page.dart';

class EndLessLeaderShipModule extends StatefulWidget {
  @override
  _EndLessLeaderShipModuleState createState() =>
      _EndLessLeaderShipModuleState();
}

class _EndLessLeaderShipModuleState extends State<EndLessLeaderShipModule>
    with BaseClass {
  @override
  Widget build(BuildContext context) {
    var sharedPref = Provider.of<SharedPreferenceProvider>(context);
    return Scaffold(
      backgroundColor: timedModeBackgroundColor,
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
                      child: Row(
                        children: [
                          Text(
                            "Leaderboards",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.pixels_33,
                            ),
                          ),
                          Container(
                              margin:
                                  EdgeInsets.only(bottom: Dimensions.pixels_30),
                              child: Image(
                                image: AssetImage(crown),
                                height: Dimensions.pixels_51,
                                width: Dimensions.pixels_51,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.pixels_30),
                        decoration: getScreenBackgroundDecoration(),
                        child: Column(
                          //fit: StackFit.expand,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Dimensions.pixels_40,
                                  ),
                                  HomeCardWidget(
                                    cardHeight: Dimensions.pixels_160,
                                    leftMargin: Dimensions.pixels_30,
                                    rightMargin: Dimensions.pixels_30,
                                    cardRadius: Dimensions.pixels_15,
                                    onCardClicked: (value) {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination:
                                              GlobalLeaderBoardHighScorePage());
                                    },
                                    context: context,
                                    cardTitle: "Global\nHigh Score",
                                    cardTextFontSize: Dimensions.pixels_24,
                                    cardTextColor: Colors.white,
                                    cardBackgroundColor: editButtonColor,
                                    cardTrailingImage: planet,
                                  ),
                                  SizedBox(
                                    height: Dimensions.pixels_30,
                                  ),
                    /*              HomeCardWidget(
                                    cardHeight: Dimensions.pixels_160,
                                    leftMargin: Dimensions.pixels_30,
                                    rightMargin: Dimensions.pixels_30,
                                    cardTextFontSize: Dimensions.pixels_24,
                                    cardRadius: Dimensions.pixels_15,
                                    onCardClicked: (value) {
                                      if(sharedPref.userDataModel.instituteName.trim().isNotEmpty) {
                                        pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination:
                                              InstitutionLeaderBoardHighScorePage());
                                      }else{
                                        showError(context, "Please first add your institute name in your\nprofile sections to check Institution high score");
                                      }
                                    },
                                    context: context,
                                    cardTitle: "Institution\nHigh Score",
                                    cardTextColor: Colors.white,
                                    cardTrailingImage: university,
                                    cardBackgroundColor: successColor,
                                  ),*/
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(top: Dimensions.pixels_51),
                                child: Image(
                                  height: Dimensions.pixels_200,
                                  image: AssetImage(leader_background),
                                ),
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
