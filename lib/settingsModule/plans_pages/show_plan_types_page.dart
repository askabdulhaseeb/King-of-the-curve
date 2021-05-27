import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class ShowPlanTypesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: Dimensions.pixels_40,
                right: Dimensions.pixels_40,
                top: Dimensions.pixels_20),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(Dimensions.pixels_8),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.pixels_20, bottom: Dimensions.pixels_20),
                  child: Text(
                    "Basic",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: Dimensions.pixels_24,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                _getPlanItems("All Test Banks", true),
                _getPlanItems("Review Mode", true),
                _getPlanItems("No ads", true),
                _getPlanItems("Leaderboards", true),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: Dimensions.pixels_200,
                    height: Dimensions.pixels_45,
                    margin: EdgeInsets.only(
                        bottom: Dimensions.pixels_20,
                        top: Dimensions.pixels_20),
                    decoration: BoxDecoration(
                      color: lightGrey,
                      border: Border.all(
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(Dimensions.pixels_4),
                    ),
                    child: Center(
                      child: Text(
                        "Select",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: Dimensions.pixels_40,
                right: Dimensions.pixels_40,
                top: Dimensions.pixels_33,
                bottom: Dimensions.pixels_33),
            decoration: BoxDecoration(
              color: editButtonColor,
              borderRadius: BorderRadius.circular(Dimensions.pixels_8),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Dimensions.pixels_20),
                  child: Text(
                    "Premier",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.pixels_24,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                _getPlanItems("All Test Banks", false),
                _getPlanItems("Review Mode", false),
                _getPlanItems("Flashcards", false),
                _getPlanItems("Overview Mode", false),
                _getPlanItems("No ads", false),
                _getPlanItems("Leaderboards", false),
                Container(
                  width: Dimensions.pixels_200,
                  height: Dimensions.pixels_45,
                  margin: EdgeInsets.only(
                      bottom: Dimensions.pixels_20, top: Dimensions.pixels_20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.pixels_4),
                  ),
                  child: Center(
                    child: Text(
                      "Select",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPlanItems(String itemName, bool isBasic) {
    return Container(
      padding: EdgeInsets.all(Dimensions.pixels_15),
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        itemName,
        style: TextStyle(
            color: isBasic ? hintTextColor : Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: Dimensions.pixels_18),
      ),
    );
  }
}
