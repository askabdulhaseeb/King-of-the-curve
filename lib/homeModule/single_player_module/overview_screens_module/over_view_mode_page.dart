import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';

class OverViewModePage extends StatefulWidget {
  @override
  _OverViewModePageState createState() => _OverViewModePageState();
}

class _OverViewModePageState extends State<OverViewModePage> with BaseClass {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: overviewModeColor,
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
                    getCustomAppBar(context, topMargin: appBarTopMargin),
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.pixels_15,
                          left: Dimensions.pixels_30),
                      child: Text(
                        "Overview Mode",
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
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            HomeCardWidget(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "Behavioral Science",
                              cardTextFontSize: Dimensions.pixels_24,
                              cardTextColor: Colors.white,
                              cardBackgroundColor:
                                  behavioralScienceBackgroundColor,
                              cardTrailingImage: brain,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            HomeCardWidget(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardRadius: Dimensions.pixels_15,
                              cardTextFontSize: Dimensions.pixels_24,
                              onCardClicked: (value) {},
                              context: context,
                              cardTextColor: Colors.white,
                              cardTitle: "Biology",
                              cardBackgroundColor: biologyBackgroundColor,
                              cardTrailingImage: biology,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            HomeCardWidget(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "General Chemistry",
                              cardTextColor: Colors.white,
                              cardTrailingImage: chemistry,
                              cardBackgroundColor:
                                  generalChemistryBackgroundColor,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            HomeCardWidget(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "Organic Chemistry",
                              cardTextColor: Colors.white,
                              cardTrailingImage: organic_chemistry,
                              cardBackgroundColor:
                                  organicChemistryBackgroundColor,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            HomeCardWidget(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "Physics",
                              cardTextColor: Colors.white,
                              cardTrailingImage: physics,
                              cardBackgroundColor: physicsBackgroundColor,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
                            ),
                            HomeCardWidget(
                              cardHeight: Dimensions.pixels_120,
                              leftMargin: Dimensions.pixels_30,
                              rightMargin: Dimensions.pixels_30,
                              cardTextFontSize: Dimensions.pixels_24,
                              cardRadius: Dimensions.pixels_15,
                              onCardClicked: (value) {},
                              context: context,
                              cardTitle: "BioChemistry",
                              cardTextColor: Colors.white,
                              cardTrailingImage: bio_chemistry,
                              cardBackgroundColor: bioChemistryBackgroundColor,
                            ),
                            SizedBox(
                              height: Dimensions.pixels_30,
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
