import 'package:flutter/material.dart';

import '../../../models/question_category_subcategory_model.dart';
import '../../../utils/appColors.dart';
import '../../../utils/appImages.dart';
import '../../../utils/constantWidgets.dart';
import '../../../utils/constantsValues.dart';
import '../../../utils/widget_dimensions.dart';
import '../../../widgets/options_expanded_tile_widget.dart';

class OptionsPage extends StatefulWidget {
  final bool isEndlessMode;

  OptionsPage({this.isEndlessMode});

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isBioChemistryVisible = false;
  bool isGetValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomAppBar(context, topMargin: appbarTopMargin),
          Container(
            margin: EdgeInsets.only(
              top: Dimensions.pixels_15,
              left: Dimensions.pixels_30,
            ),
            child: Text(
              "Options",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: Dimensions.pixels_33,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: Dimensions.pixels_15,
              left: Dimensions.pixels_30,
            ),
            child: Text(
              "Select Your Categories!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: Dimensions.pixels_20,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: Dimensions.pixels_30,
              ),
              decoration: getScreenBackgroundDecoration(
                color: settingAccountDetailBackgroundColor,
              ),
              child:
                  FutureBuilder<List<EndlessQuestionCategorySubcategoryModel>>(
                future: null,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    print("ERROR");
                    return null;
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Wrap(
                        children: [
                          SizedBox(
                            height: Dimensions.pixels_30,
                          ),
                          OptionsExpandedCardWidget(
                            cardHeight: Dimensions.pixels_120,
                            leftMargin: Dimensions.pixels_30,
                            rightMargin: Dimensions.pixels_30,
                            cardRadius: Dimensions.pixels_15,
                            onCategoryCheckboxTap: () {},
                            onCardClicked: () {},
                            context: context,
                            cardTitle: snapshot.data.elementAt(index).category,
                            isSubCategoryVisible: true,
                            cardTextFontSize: Dimensions.pixels_24,
                            cardTextColor: headingColor,
                            childrenWidget: Column(
                              children: [
                                ...snapshot.data
                                    .elementAt(index)
                                    .subCategoryList
                                    .map((subCat) {
                                  return _getSubCategoryOptionWidget(
                                    subCat,
                                  );
                                }),
                                getDivider(),
                              ],
                            ),
                            cardBackgroundColor: Colors.white,
                            cardTrailingImage: snapshot.data
                                    .elementAt(index)
                                    .isCategorySelected
                                ? icon_check
                                : icon_uncheck,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSubCategoryOptionWidget(SubCategoryList list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(
              Dimensions.pixels_25,
            ),
            child: Text(
              list.subCategoryName,
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.pixels_16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            right: Dimensions.pixels_20,
          ),
          child: Image(
            image: list.isSubCategorySelected
                ? AssetImage(icon_check)
                : AssetImage(icon_uncheck),
          ),
        ),
      ],
    );
  }
}
