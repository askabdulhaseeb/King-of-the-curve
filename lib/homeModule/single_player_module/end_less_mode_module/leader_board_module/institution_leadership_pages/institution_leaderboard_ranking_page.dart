import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class InstitutionRankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: editButtonColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCustomAppBarWithText(
                    context,
                    "Florida Southern’s\nTop 100",
                    topMargin: appBarTopMargin,
                  ),
                  SizedBox(
                    height: Dimensions.pixels_45,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.pixels_30,
                        right: Dimensions.pixels_30),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text(
                                  "Rank",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.pixels_10,
                              ),
                              Container(
                                width: Dimensions.pixels_45,
                                color: Colors.white,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: _getTabBarItem("Score"),
                        ),
                        Flexible(
                          flex: 2,
                          child: _getTabBarItem("Institution"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.pixels_18,
                          right: Dimensions.pixels_18,
                          top: Dimensions.pixels_30,
                          bottom: Dimensions.pixels_51),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.pixels_15),
                        color: Colors.white,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(bottom: Dimensions.pixels_60),
                            child: ListView(
                              children: [
                                _getScoreWidgets(
                                    userName: "Rutgers University",
                                    score: "100",
                                    universityImage: score_one),
                                getDivider(),
                                _getScoreWidgets(
                                    userName: "Rutgers University",
                                    score: "100",
                                    universityImage: score_two),
                                getDivider(),
                                _getScoreWidgets(
                                    userName: "Rutgers University",
                                    score: "100",
                                    universityImage: score_three),
                                getDivider(),
                                _getScoreWidgets(
                                    userName: "Rutgers University",
                                    score: "100",
                                    universityImage: score_one),
                                getDivider(),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: Dimensions.pixels_45,
                              width: Dimensions.pixels_200,
                              margin: EdgeInsets.only(
                                  left: Dimensions.pixels_12,
                                  bottom: Dimensions.pixels_12),
                              decoration: BoxDecoration(
                                color: successLightColor,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.pixels_5),
                              ),
                              child: Center(
                                child: Text(
                                  "You: 300th",
                                  style: TextStyle(
                                      color: successColor,
                                      fontSize: Dimensions.pixels_16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getTabBarItem(String title) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.topRight,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: Dimensions.pixels_10,
        ),
      ],
    );
  }

  Widget _getScoreWidgets(
      {String score, String universityImage, String userName}) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.pixels_15, right: Dimensions.pixels_15),
      height: Dimensions.pixels_60,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Container(
                height: Dimensions.pixels_30,
                width: Dimensions.pixels_30,
                child: Image(
                  image: AssetImage(universityImage),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: Dimensions.pixels_5),
              width: double.infinity,
              child: Text(
                score,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: Dimensions.pixels_5),
              child: Text(
                userName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
