import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class SettingsOptionWidget extends StatelessWidget {
  final Color backgroundColor;

  final String leadingImage;

  final String trailingImage;

  final String optionTitle;

  final double leftMargin;

  final double rightMargin;

  final double topMargin;
  final Function onClickOption;

  final BuildContext context;

  final double bottomMargin;
  final double height;
  final isLeadingVisible;

  SettingsOptionWidget(
      {this.backgroundColor = Colors.transparent,
      @required this.leadingImage,
      @required this.trailingImage,
      @required this.optionTitle,
      this.leftMargin = 0,
      this.height = 51,
      this.rightMargin = 0,
      this.topMargin = 0,
      this.context,
      this.isLeadingVisible = true,
      @required this.onClickOption,
      this.bottomMargin = 0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClickOption(context);
      },
      child: Container(
        height: height,
        color: backgroundColor,
        margin: EdgeInsets.only(
            left: leftMargin,
            right: rightMargin,
            top: topMargin,
            bottom: bottomMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isLeadingVisible
                ? Image(
                    image: AssetImage(leadingImage),
                    height: Dimensions.pixels_30,
                    width: Dimensions.pixels_30,
                  )
                : Container(),
            SizedBox(
              width: Dimensions.pixels_20,
            ),
            Expanded(
              child: Text(
                optionTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Image(
              image: AssetImage(trailingImage),
              height: Dimensions.pixels_25,
              width: Dimensions.pixels_25,
            ),
          ],
        ),
      ),
    );
  }
}
