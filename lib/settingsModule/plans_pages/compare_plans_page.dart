import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class ComparePlansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.pixels_30,
          right: Dimensions.pixels_30,
          top: Dimensions.pixels_20),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.pixels_15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 2, child: Container()),
                Flexible(
                  flex: 1,
                  child: Text(
                    "Basic",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: headingColor,
                      fontSize: Dimensions.pixels_18,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text("Premium", textAlign: TextAlign.center,
                    style: TextStyle(
                      color: headingColor,
                      fontSize: Dimensions.pixels_18,
                    ),),
                ),
              ],
            ),
          ),
          getDivider(dividerColor: hintTextColor),
          _getPlanDataWidget("Access to 3000+ Questions", true, true),
          getDivider(dividerColor: hintTextColor),
          _getPlanDataWidget("Ad-free Multiplayer Mode", true, true),
          getDivider(dividerColor: hintTextColor),
          _getPlanDataWidget("Access to All Leaderboards", true, true),
          getDivider(dividerColor: hintTextColor),
          _getPlanDataWidget("Review Mode", true, true),
          getDivider(dividerColor: hintTextColor),
          _getPlanDataWidget("Overview Mode", false, true),
          getDivider(dividerColor: hintTextColor),
          _getPlanDataWidget("Flashcard Mode", false, true),
        ],
      ),
    );
  }

  Widget _getPlanDataWidget(String planTitle, bool isBasic, bool isPremium) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.pixels_15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Text(
                planTitle,
                style: TextStyle(
                  color: hintTextColor,
                  fontSize: Dimensions.pixels_14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          isBasic
              ? Flexible(
                  flex: 1,
                  child: Center(
                    child: Container(
                      child: Image(
                        image: AssetImage(plan_checkbox),
                      ),
                    ),
                  ),
                )
              : Flexible(
                  flex: 1,
                  child: Container(),
                ),
          isPremium
              ? Flexible(
                  flex: 1,
                  child: Center(
                    child: Container(
                      child: Image(
                        image: AssetImage(plan_checkbox),
                      ),
                    ),
                  ),
                )
              : Flexible(flex: 1, child: Container()),
        ],
      ),
    );
  }
}
