import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class HomeCardWidget extends StatelessWidget {
  final Color cardBackgroundColor;
  final Color cardTextColor;
  final String cardTrailingImage;
  final double cardHeight;
  final double cardTextFontSize;
  final double cardRadius;
  final Function onCardClicked;
  final BuildContext context;
  final String cardTitle;
  final double leftMargin;
  final bool isCustomHeight;

  final double rightMargin;

  final double topMargin;

  final double bottomMargin;

  HomeCardWidget(
      {@required this.cardBackgroundColor,
      this.cardTextColor,
      this.cardTrailingImage,
      @required this.cardHeight,
      this.cardTextFontSize,
      @required this.onCardClicked,
      this.cardRadius = 13,
      @required this.context,
      @required this.cardTitle,
      this.isCustomHeight = false,
      this.leftMargin = 0,
      this.rightMargin = 0,
      this.topMargin,
      this.bottomMargin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCardClicked(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
        width: double.infinity,
        height: cardHeight,
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FadeInLeft(
              duration: Duration(milliseconds: 300),
              child: Container(
                margin: EdgeInsets.only(left: Dimensions.pixels_40),
                child: Text(
                  cardTitle,
                  style: TextStyle(
                      color: cardTextColor,
                      fontSize: cardTextFontSize,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            FadeInRight(
              duration: Duration(milliseconds: 300),
              child: Container(
                margin: EdgeInsets.only(right: Dimensions.pixels_20),
                padding: EdgeInsets.only(
                    top: Dimensions.pixels_5, bottom: Dimensions.pixels_5),
                child: Image(
                  image: AssetImage(
                    cardTrailingImage,
                  ),
                  height:
                      isCustomHeight ? Dimensions.pixels_50 : double.infinity,
                  width: Dimensions.pixels_70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
