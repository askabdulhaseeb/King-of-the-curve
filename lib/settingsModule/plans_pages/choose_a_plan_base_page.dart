import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/settingsModule/plans_pages/compare_plans_page.dart';
import 'package:kings_of_the_curve/settingsModule/plans_pages/show_plan_types_page.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class ChooseAPlanPage extends StatefulWidget {
  @override
  _ChooseAPlanPageState createState() => _ChooseAPlanPageState();
}

class _ChooseAPlanPageState extends State<ChooseAPlanPage> {
  bool isPlanSelected = true;

  void onPlanSelected(bool isBasicSelected, BuildContext context) {}

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
                  children: [
                    getCustomAppBar(context, topMargin: appBarTopMargin),
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.pixels_15,
                          left: Dimensions.pixels_30),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isPlanSelected) {
                                  isPlanSelected = false;
                                } else {
                                  isPlanSelected = true;
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Plans",
                                  style: TextStyle(
                                    color: isPlanSelected
                                        ? editButtonColor
                                        : hintTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Dimensions.pixels_24,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                isPlanSelected
                                    ? Container(
                                        color: editButtonColor,
                                        width: Dimensions.pixels_67,
                                        height: Dimensions.pixels_4,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Dimensions.pixels_35,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isPlanSelected) {
                                  isPlanSelected = false;
                                } else {
                                  isPlanSelected = true;
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Compare",
                                  style: TextStyle(
                                    color: isPlanSelected
                                        ? hintTextColor
                                        : editButtonColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Dimensions.pixels_24,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                isPlanSelected
                                    ? Container()
                                    : Container(
                                        color: editButtonColor,
                                        width: Dimensions.pixels_67,
                                        height: Dimensions.pixels_4,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: Dimensions.pixels_30),
                        decoration: getScreenBackgroundDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.pixels_33,
                                  left: Dimensions.pixels_30,
                                  right: Dimensions.pixels_30),
                              child: Text(
                                isPlanSelected
                                    ? "Choose a plan"
                                    : "Compare Plans",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.pixels_33),
                              ),
                            ),
                            isPlanSelected
                                ? ShowPlanTypesPage()
                                : ComparePlansPage()
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
