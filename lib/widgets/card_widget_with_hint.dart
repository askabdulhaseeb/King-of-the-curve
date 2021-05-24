import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class CardWidgetWithHint extends StatelessWidget {
  final Color cardBackgroundColor;
  final Color cardTextColor;
  final String cardTrailingImage;
  final double cardHeight;
  final double cardTextFontSize;
  final double cardRadius;
  final Function onCardClicked;
  final Function onQuestionMarkClicked ;
  final BuildContext context;
  final String cardTitle;
  final double leftMargin;

  final double rightMargin;

  final double topMargin;

  final double bottomMargin;

  CardWidgetWithHint(
      {@required this.cardBackgroundColor,
        this.cardTextColor,
        this.cardTrailingImage,
        @required this.cardHeight,
        this.cardTextFontSize ,
        @required this.onCardClicked,
        this.cardRadius = 13,
        @required this.context,
        @required this.cardTitle,
        this.onQuestionMarkClicked,
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.pixels_40),
                    child: Text(
                      cardTitle,
                      style: TextStyle(
                          color: cardTextColor,
                          fontSize: cardTextFontSize,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Dimensions.pixels_20),
                    child: Image(
                      image: AssetImage(cardTrailingImage,),
                      height: Dimensions.pixels_35,
                      width: Dimensions.pixels_78,
                    ),
                  ),

                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: (){
                  onQuestionMarkClicked(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: Dimensions.pixels_10,top: Dimensions.pixels_10),
                  child: Image(
                    image: AssetImage(question_mark),
                    height: Dimensions.pixels_20,
                    width: Dimensions.pixels_20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}