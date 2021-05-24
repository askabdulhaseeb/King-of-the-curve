import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/edittext_with_hint.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';

class EditEmailPage extends StatefulWidget {
  @override
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> with BaseClass{
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
                      getCustomAppBar(context, topMargin: appbarTopMargin),
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.pixels_15, left: Dimensions.pixels_30),
                        child: Text(
                          "Settings",
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
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: Dimensions.pixels_33, left: Dimensions.pixels_30, right: Dimensions.pixels_30),
                                child: Text(
                                  "Edit Email",
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.pixels_24),
                                ),
                              ),
                              EditTextWithHint(
                                hintText: "Old Email",
                                context: context,
                                leftMargin: Dimensions.pixels_30,
                                isObscure: false,
                                rightMargin: Dimensions.pixels_30,
                                topMargin: Dimensions.pixels_40,
                              ),

                              EditTextWithHint(
                                hintText: "New Email",
                                context: context,
                                leftMargin: Dimensions.pixels_30,
                                isObscure: false,
                                rightMargin: Dimensions.pixels_30,
                                topMargin: Dimensions.pixels_40,
                              ),
                              SizedBox(
                                height: Dimensions.pixels_40,
                              ),
                              RoundedEdgeButton(
                                  color: primaryColor,
                                  text: "Save",
                                  leftMargin: Dimensions.pixels_30,
                                  rightMargin: Dimensions.pixels_30,
                                  bottomMargin: Dimensions.pixels_30,
                                  height: Dimensions.pixels_60,
                                  textFontSize: Dimensions.pixels_18,
                                  buttonRadius: Dimensions.pixels_14,
                                  textColor: Colors.white,
                                  onPressed: (value) {
                                    popToPreviousScreen(context: context);
                                  },
                                  context: context)
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
        ));
  }
}
