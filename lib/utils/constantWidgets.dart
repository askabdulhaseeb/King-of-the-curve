import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/size_config.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'appColors.dart';

BoxDecoration getScreenBackgroundDecoration({Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(Dimensions.pixels_30),
      topRight: Radius.circular(Dimensions.pixels_30),
    ),
  );
}

Widget getDivider({Color dividerColor = dividerColor}) {
  return Divider(
    height: 0.55 * SizeConfig.textMultiplier,
    color: dividerColor,
  );
}

Widget getCustomAppBar(BuildContext context,
    {double topMargin = 0,
    Color iconColor = Colors.white,
    Function onBackClick}) {
  return Container(
    width: double.infinity,
    height: Dimensions.pixels_56,
    margin: EdgeInsets.only(left: Dimensions.pixels_30, top: topMargin),
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () {
        if (onBackClick != null) {
          onBackClick();
        } else {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(Dimensions.pixels_8),
        child: Icon(
          Icons.arrow_back_ios,
          size: Dimensions.pixels_20,
          color: iconColor,
        ),
      ),
    ),
  );
}

Widget getCustomAppBarWithText(BuildContext context, String title,
    {double topMargin = 0, Color iconColor = Colors.white}) {
  return Container(
    width: double.infinity,
    //height: Dimensions.pixels_56,
    margin: EdgeInsets.only(left: Dimensions.pixels_30, top: topMargin),
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.all(Dimensions.pixels_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.pixels_5),
              child: Icon(
                Icons.arrow_back_ios,
                size: Dimensions.pixels_20,
                color: iconColor,
              ),
            ),
            SizedBox(
              width: Dimensions.pixels_8,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.pixels_24,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    ),
  );
}
