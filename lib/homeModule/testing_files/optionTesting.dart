import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/options_model.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/options_expanded_tile_widget.dart';
import 'package:provider/provider.dart';

class OptionTestingPage extends StatefulWidget {
  final bool isEndlessMode;

  OptionTestingPage({this.isEndlessMode});

  @override
  _OptionTestingPageState createState() => _OptionTestingPageState();
}

class _OptionTestingPageState extends State<OptionTestingPage> with BaseClass {
  bool isBioChemistryVisible = false;
  bool isGetValue = true;
  int currentVisibleChildIndex = -1;
  int previousVisibleChildIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    var _optionProvider = Provider.of<OptionProvider>(context, listen: false);
    // _optionProvider.setEndlessOptionList();
    super.initState();
  }

  getOptionsList(OptionProvider optionProvider) {
    /* _optionList.addAll(await optionProvider.getAsyncOptionList);
    setState(() {
      isShowOptionList = true;
    });*/

    _optionList.clear();
    _optionList.addAll(optionProvider.getAsyncOptionList);
    print(optionProvider.getAsyncOptionList);
    print("LENGTH");
    isShowOptionList = true;
    isAPiHit = false;
    print(isAPiHit);
  }

  List<OptionsModel> _optionList = [];

  bool isShowOptionList = false;
  bool isAPiHit = true;

  @override
  Widget build(BuildContext context) {
    var optionProvider = Provider.of<OptionProvider>(context);
    var sharePrefProvider = Provider.of<SharedPreferenceProvider>(context);

    getOptionsList(optionProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: optionProvider.getAsyncOptionList.length > 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCustomAppBar(context, topMargin: appBarTopMargin),
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
                          itemCount: optionProvider.getAsyncOptionList
                              .length /* _optionList.length*/,
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
                                    if (sharePrefProvider
                                        .userDataModel.isPremium) {
                                      if (/*_optionList*/ optionProvider
                                          .getAsyncOptionList
                                          .elementAt(index)
                                          .isCategorySelected) {
                                        optionProvider
                                            .changeEndlessCategoryStatus(
                                                optionProvider
                                                    .getAsyncOptionList
                                                    .elementAt(index)
                                                    .isCategorySelected,
                                                optionProvider
                                                    .getAsyncOptionList
                                                    .elementAt(index)
                                                    .categoryDocumentId,
                                                context,
                                                sharePrefProvider
                                                    .userDataModel.userId,
                                                index);
                                        //  setState(() {});
                                      } else {
                                        optionProvider
                                            .changeEndlessCategoryStatus(
                                                optionProvider
                                                    .getAsyncOptionList
                                                    .elementAt(index)
                                                    .isCategorySelected,
                                                optionProvider
                                                    .getAsyncOptionList
                                                    .elementAt(index)
                                                    .categoryDocumentId,
                                                context,
                                                sharePrefProvider
                                                    .userDataModel.userId,
                                                index);
                                      }
                                    } else {
                                      showError(context,
                                          "Upgrade to premium to select or unselect categories ");
                                    }
                                  },
                                  onCardClicked: (value) {
                                    print(index);
                                    setState(() {
                                      if (optionProvider.getAsyncOptionList
                                          .elementAt(index)
                                          .isSubCategoriesVisible) {
                                        optionProvider.getAsyncOptionList
                                            .elementAt(index)
                                            .isSubCategoriesVisible = false;
                                      } else {
                                        optionProvider.getAsyncOptionList
                                            .elementAt(index)
                                            .isSubCategoriesVisible = true;
                                      }
                                    });

                                    /* if (snapshot.data
                                        .elementAt(index)
                                        .isCategorySelected) {
                                      optionProvider
                                          .changeEndlessCategoryStatus(
                                          snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected,
                                          snapshot.data
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,
                                          sharePrefProvider.userDataModel
                                              .userId);
                                    //  setState(() {});
                                    } else {
                                      optionProvider
                                          .changeEndlessCategoryStatus(
                                          snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected,
                                          snapshot.data
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,sharePrefProvider.
                                          userDataModel.userId);
                                    }*/
                                  },
                                  context: context,
                                  cardTitle: optionProvider.getAsyncOptionList
                                      .elementAt(index)
                                      .categoryName /*"Biochemistry"*/,
                                  isSubCategoryVisible: optionProvider
                                      .getAsyncOptionList
                                      .elementAt(index)
                                      .isSubCategoriesVisible,
                                  cardTextFontSize: Dimensions.pixels_24,
                                  cardTextColor: headingColor,
                                  childrenWidget: Column(
                                    children: [
                                      ...optionProvider.getAsyncOptionList
                                          .elementAt(index)
                                          .subCategoryList
                                          .map((subCat) {
                                        //   print(subCat.subCategoryName);
                                        return _getSubCategoryOptionWidget(
                                            subCat,
                                            optionProvider,
                                            sharePrefProvider,
                                            index);
                                      }),
                                    ],
                                  ),
                                  cardBackgroundColor: Colors.white,
                                  cardTrailingImage: optionProvider
                                          .getAsyncOptionList
                                          .elementAt(index)
                                          .isCategorySelected
                                      ? icon_check
                                      : icon_uncheck,
                                ),
                                SizedBox(
                                  height: Dimensions.pixels_30,
                                ),
                              ],
                            );
                          }) /*StreamBuilder<List<OptionsModel>>(
                        stream: optionProvider.getOptionList,
                        builder: (context,
                            AsyncSnapshot<List<OptionsModel>> snapshot) {
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
                                      onCategoryCheckboxTap: (value) {
                                        if (snapshot.data
                                            .elementAt(index)
                                            .isCategorySelected) {
                                          optionProvider
                                              .changeEndlessCategoryStatus(
                                                  snapshot.data
                                                      .elementAt(index)
                                                      .isCategorySelected,
                                                  snapshot.data
                                                      .elementAt(index)
                                                      .categoryDocumentId,
                                                  context,
                                                  sharePrefProvider
                                                      .userDataModel.userId);
                                          //  setState(() {});
                                        } else {
                                          optionProvider
                                              .changeEndlessCategoryStatus(
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
                                      onCardClicked: (value) {
                                        print(index);

                                        snapshot.data
                                            .elementAt(index)
                                            .isSubCategoriesVisible = true;

                                        */ /* if (snapshot.data
                                        .elementAt(index)
                                        .isCategorySelected) {
                                      optionProvider
                                          .changeEndlessCategoryStatus(
                                          snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected,
                                          snapshot.data
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,
                                          sharePrefProvider.userDataModel
                                              .userId);
                                    //  setState(() {});
                                    } else {
                                      optionProvider
                                          .changeEndlessCategoryStatus(
                                          snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected,
                                          snapshot.data
                                              .elementAt(index)
                                              .categoryDocumentId,
                                          context,sharePrefProvider.
                                          userDataModel.userId);
                                    }*/ /*
                                      },
                                      context: context,
                                      cardTitle: snapshot.data
                                          .elementAt(index)
                                          .categoryName */ /*"Biochemistry"*/ /*,
                                      isSubCategoryVisible: snapshot.data
                                          .elementAt(index)
                                          .isSubCategoriesVisible,
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
                                        ],
                                      ),
                                      cardBackgroundColor: Colors.white,
                                      cardTrailingImage: snapshot.data
                                              .elementAt(index)
                                              .isCategorySelected
                                          ? icon_check
                                          : icon_uncheck,
                                    ),
                                    SizedBox(
                                      height: Dimensions.pixels_30,
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
            ),
    );
  }

  Widget _getSubCategoryOptionWidget(
      SubCatList list,
      OptionProvider optionProvider,
      SharedPreferenceProvider sharePrefProvider,
      int categoryIndex) {
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
            if (sharePrefProvider.userDataModel.isPremium) {
              if (list.isSubCatSelected) {
                optionProvider.changeEndlessSubCategoryStatus(
                  list.isSubCatSelected,
                  list.subCatId,
                  context,
                  sharePrefProvider.userDataModel.userId,
                  categoryIndex,
                  optionProvider.getAsyncOptionList
                      .elementAt(categoryIndex)
                      .subCategoryList
                      .indexOf(list),
                );
              } else {
                print(optionProvider.getAsyncOptionList
                    .elementAt(categoryIndex)
                    .subCategoryList
                    .indexOf(list));
                optionProvider.changeEndlessSubCategoryStatus(
                    list.isSubCatSelected,
                    list.subCatId,
                    context,
                    sharePrefProvider.userDataModel.userId,
                    categoryIndex,
                    optionProvider.getAsyncOptionList
                        .elementAt(categoryIndex)
                        .subCategoryList
                        .indexOf(list));
              }
            } else {
              showError(context,
                  "Upgrade to premium to select or unselect sub categories ");
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
