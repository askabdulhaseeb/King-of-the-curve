import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/options_module/options_page.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/card_widget_with_hint.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';

class FlashCardPage extends StatefulWidget {
  @override
  _FlashCardPageState createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> with  BaseClass{
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
                        "Flashcards",
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
                            SizedBox(height: Dimensions.pixels_30,),
                            CardWidgetWithHint(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "Study\nFlashcards",
                              cardTextFontSize: Dimensions.pixels_24,
                              cardTextColor: Colors.white,
                              cardBackgroundColor: editButtonColor,
                              cardTrailingImage: study_flash_card,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            CardWidgetWithHint(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardRadius: Dimensions.pixels_15,
                              cardTextFontSize: Dimensions.pixels_24,
                              onCardClicked: (value) {},
                              context: context,
                              cardTextColor: Colors.white,
                              cardTitle: "Create\nFlashcards",
                              cardBackgroundColor: flashcardsModeColor,

                              cardTrailingImage: create_flash_card,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),

                            CardWidgetWithHint(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "Decks",
                              cardTextColor: Colors.white,
                              cardTrailingImage: decks,
                              cardBackgroundColor: endlessMOdeColor,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            CardWidgetWithHint(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {
                                pushToNextScreenWithFadeAnimation(context: context, destination: OptionsPage());
                              },
                              context: context,
                              cardTitle: "Options",
                              cardTextColor: Colors.white,
                              cardTrailingImage: options_icon,
                              cardBackgroundColor: successColor,
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
