import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class OptionsExpandedCardWidget extends StatelessWidget {
  final Color cardBackgroundColor;
  final Color cardTextColor;
  final String cardTrailingImage;
  final double cardHeight;
  final double cardTextFontSize;
  final double cardRadius;
  final Function onCardClicked;
  final Function onCategoryCheckboxTap;
  final BuildContext context;
  final String cardTitle;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final bool isSubCategoryVisible;
  final double bottomMargin;
  final Widget childrenWidget;

  OptionsExpandedCardWidget(
      {@required this.cardBackgroundColor,
      this.cardTextColor,
      this.cardTrailingImage,
      this.cardHeight,
      this.cardTextFontSize,
      @required this.onCardClicked,
        @required this.onCategoryCheckboxTap,
      this.cardRadius = 13,
      @required this.context,
      @required this.cardTitle,
      this.leftMargin = 0,
      this.rightMargin = 0,
      this.childrenWidget,
      this.isSubCategoryVisible = false,
      this.topMargin,
      this.bottomMargin});

  @override
  Widget build(BuildContext context) {
  //  var optionProvider = Provider.of<OptionValueChangeProvider>(context);
    return InkWell(
      onTap: () {
        onCardClicked(context);
        //onCardClicked(context);
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.pixels_25),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cardTitle,
                          style: TextStyle(
                              color: cardTextColor,
                              fontSize: cardTextFontSize,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          onCategoryCheckboxTap(context);

                        },
                        child: Container(
                          margin: EdgeInsets.only(right: Dimensions.pixels_20),
                          child: Image(
                            image: AssetImage(cardTrailingImage),
                          ),
                        ),
                      ),
                    ],
                  ),
                 isSubCategoryVisible? childrenWidget:Container()

                  //SizedBox(height: Dimensions.pixels_10,),
                ],

              ),
            ),
          ),
          SizedBox(
            height: Dimensions.pixels_30,
          ),
        ],
      ),
    );
  }
}
