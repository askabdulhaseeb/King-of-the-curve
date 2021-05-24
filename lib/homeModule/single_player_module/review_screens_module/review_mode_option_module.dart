import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/review_option_model.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/options_expanded_tile_widget.dart';
import 'package:provider/provider.dart';

class ReviewOptionsPage extends StatefulWidget {
  @override
  _ReviewOptionsPageState createState() => _ReviewOptionsPageState();
}

class _ReviewOptionsPageState extends State<ReviewOptionsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<ReviewOptionsModel> _optionList = [];

  bool isShowOptionList = false;
  bool isAPiHit = true;

  getOptionsList(OptionProvider optionProvider) {
    /* _optionList.addAll(await optionProvider.getAsyncTimedOptionList);
    setState(() {
      isShowOptionList = true;
    });*/

    _optionList.clear();
    _optionList.addAll(optionProvider.getAsyncReviewOptionList);
    print(optionProvider.getAsyncTimedOptionList);
    print("LENGTH");
    isShowOptionList = true;
    isAPiHit = false;
    print(isAPiHit);
  }

  @override
  Widget build(BuildContext context) {
    var optionProvider = Provider.of<OptionProvider>(context);
    var sharePrefProvider = Provider.of<SharedPreferenceProvider>(context);
    getOptionsList(optionProvider);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: optionProvider.getAsyncReviewOptionList.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCustomAppBar(context, topMargin: appbarTopMargin),
                  Container(
                    margin: EdgeInsets.only(
                        top: Dimensions.pixels_15, left: Dimensions.pixels_30),
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
                        top: Dimensions.pixels_15, left: Dimensions.pixels_30),
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
                      margin: EdgeInsets.only(top: Dimensions.pixels_30),
                      decoration: getScreenBackgroundDecoration(
                          color: settingAccountDetailBackgroundColor),
                      child: ListView.builder(
                          itemCount:
                              optionProvider.getAsyncReviewOptionList.length,
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
                                  onCategoryCheckboxTap: (value) {
                                    if (optionProvider.getAsyncReviewOptionList
                                        .elementAt(index)
                                        .isCategorySelected) {
                                      optionProvider.changeReviewCategoryStatus(
                                          optionProvider
                                              .getAsyncReviewOptionList
                                              .elementAt(index)
                                              .isCategorySelected,
                                          optionProvider
                                              .getAsyncReviewOptionList
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,
                                          sharePrefProvider
                                              .userDataModel.userId,index);
                                      setState(() {});
                                    } else {
                                      optionProvider.changeReviewCategoryStatus(
                                          optionProvider
                                              .getAsyncReviewOptionList
                                              .elementAt(index)
                                              .isCategorySelected,
                                          optionProvider
                                              .getAsyncReviewOptionList
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,
                                          sharePrefProvider
                                              .userDataModel.userId,index);
                                    }
                                  },
                                  onCardClicked: (value) {
                                    print(index);
                                    setState(() {
                                      if (optionProvider.getAsyncReviewOptionList
                                          .elementAt(index)
                                          .isSubCategoriesVisible) {
                                        optionProvider.getAsyncReviewOptionList
                                            .elementAt(index)
                                            .isSubCategoriesVisible = false;
                                      } else {
                                        optionProvider.getAsyncReviewOptionList
                                            .elementAt(index)
                                            .isSubCategoriesVisible = true;
                                      }
                                    });
                                  },
                                  context: context,
                                  cardTitle: optionProvider
                                      .getAsyncReviewOptionList
                                      .elementAt(index)
                                      .categoryName /*"Biochemistry"*/,
                                  isSubCategoryVisible: optionProvider
                                      .getAsyncReviewOptionList
                                      .elementAt(index)
                                      .isSubCategoriesVisible,
                                  cardTextFontSize: Dimensions.pixels_24,
                                  cardTextColor: headingColor,
                                  childrenWidget: Column(
                                    children: [
                                      ...optionProvider.getAsyncReviewOptionList
                                          .elementAt(index)
                                          .subCategoryList
                                          .map((subCat) {
                                        //   print(subCat.subCategoryName);
                                        return _getSubCategoryOptionWidget(
                                            subCat,
                                            optionProvider,
                                            sharePrefProvider,index);
                                      }),
                                      getDivider(),
                                    ],
                                  ),
                                  cardBackgroundColor: Colors.white,
                                  cardTrailingImage: optionProvider
                                          .getAsyncReviewOptionList
                                          .elementAt(index)
                                          .isCategorySelected
                                      ? icon_check
                                      : icon_uncheck,
                                ),
                              ],
                            );
                          }), /*StreamBuilder<List<ReviewOptionsModel>>(
                    stream: optionProvider.getReviewOptionList,
                    builder: (context,
                        AsyncSnapshot<List<ReviewOptionsModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
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
                                  onCardClicked: (value) {
                                    if (snapshot.data
                                        .elementAt(index)
                                        .isCategorySelected) {
                                      optionProvider.changeReviewCategoryStatus(
                                          snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected,
                                          snapshot.data
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,
                                          sharePrefProvider
                                              .userDataModel.userId);
                                      setState(() {});
                                    } else {
                                      optionProvider.changeReviewCategoryStatus(
                                          snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected,
                                          snapshot.data
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,
                                          sharePrefProvider
                                              .userDataModel.userId);
                                    }
                                  },
                                  context: context,
                                  cardTitle: snapshot.data
                                      .elementAt(index)
                                      .categoryName */ /*"Biochemistry"*/ /*,
                                  isSubCategoryVisible: true,
                                  cardTextFontSize: Dimensions.pixels_24,
                                  cardTextColor: headingColor,
                                  childrenWidget: Column(
                                    children: [
                                      ...snapshot.data
                                          .elementAt(index)
                                          .subCategoryList
                                          .map((subCat) {
                                        //   print(subCat.subCategoryName);
                                        return _getSubCategoryOptionWidget(
                                            subCat,
                                            optionProvider,
                                            sharePrefProvider);
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
                          });
                    }),*/
                    ),
                  )
                ],
              )
            : Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      primaryColor,
                    ),
                  ),
                ),
              ));
  }

  Widget _getSubCategoryOptionWidget(
      ReviewSubCatList list,
      OptionProvider optionProvider,
      SharedPreferenceProvider sharePrefProvider,int categoryIndex) {
    //print(list.isSubCategorySelected);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(Dimensions.pixels_25),
            child: Text(
              list.subCategoryName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.pixels_16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (list.isSubCatSelected) {
              optionProvider.changeReviewSubCategoryStatus(
                  list.isSubCatSelected,
                  list.subCatId,
                  context,
                  sharePrefProvider.userDataModel.userId, categoryIndex,
                optionProvider.getAsyncReviewOptionList
                    .elementAt(categoryIndex)
                    .subCategoryList
                    .indexOf(list),);
            } else {
              optionProvider.changeReviewSubCategoryStatus(
                  list.isSubCatSelected,
                  list.subCatId,
                  context,
                  sharePrefProvider.userDataModel.userId,categoryIndex,
                optionProvider.getAsyncReviewOptionList
                    .elementAt(categoryIndex)
                    .subCategoryList
                    .indexOf(list),);
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: Dimensions.pixels_20),
            child: Image(
              image: list.isSubCatSelected
                  ? AssetImage(icon_check)
                  : AssetImage(icon_uncheck),
            ),
          ),
        ),
      ],
    );
  }
}
