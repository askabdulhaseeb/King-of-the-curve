import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:kings_of_the_curve/blocs/auth_bloc.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/endless_mode_your_answers_page.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/remianing_life_count_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/progress_dialog.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class EndlessGameOverPage extends StatefulWidget {
  @override
  _EndlessGameOverPageState createState() => _EndlessGameOverPageState();
}

class _EndlessGameOverPageState extends State<EndlessGameOverPage>
    with BaseClass {
  @override
  void initState() {
    var remainingCount =
        Provider.of<RemainingLifeCountProvider>(context, listen: false);
    var questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    var sharePrefProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    remainingCount.resetLife();
    questionProvider.setSelectedMode(0);
    //  saveEndlessCorrectQuestionCount(questionProvider, sharePrefProvider);
    // TODO: implement initState

    super.initState();
    saveEndlessCorrectQuestionCount(
      questionProvider,
      sharePrefProvider, /*context*/
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!sharePrefProvider.userDataModel.isPremium) {
        if (isShowPremiumDialog) {
          Future.delayed(const Duration(milliseconds: 500), () {
            premiumDialog(context);
            isShowPremiumDialog = false;
          });
        }
      }
      if (!sharePrefProvider.userDataModel.isPremium)
        initPlatformState(context);
      /*saveEndlessCorrectQuestionCount(
          questionProvider, sharePrefProvider, context);*/
    });
  }

  final String iapId = "single_month_subscription";
  final String iapId2 = "twelve_month_subscription";
  final String iapId3 = "six_month_subsciption";
  List<IAPItem> _items = [];

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  Future<void> initPlatformState(BuildContext context) async {
    try {
      final _questionProvider =
          Provider.of<QuestionProvider>(context, listen: false);
      // prepare
      //var close = await FlutterInappPurchase.instance.endConnection;
      await FlutterInappPurchase.instance.clearTransactionIOS();

      var result = await FlutterInappPurchase.instance.initConnection;
      print('result: $result');

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      // refresh items for android
      /*String msg = await FlutterInappPurchase.instance.consumeAllItems;*/
      try {
        String msg = await FlutterInappPurchase.instance.consumeAllItems;
        print('consumeAllItems: $msg');
      } catch (err) {
        print('consumeAllItems error: $err');
      }

      _conectionSubscription =
          FlutterInappPurchase.connectionUpdated.listen((connected) {
        print('connected: $connected');
      });

      _purchaseUpdatedSubscription =
          FlutterInappPurchase.purchaseUpdated.listen((productItem) {
        print("ANDROIDDDDD" + productItem.dataAndroid.toString());
        print('purchase-updated: ${productItem.transactionId}');
        print('purchase-updated: ${productItem.transactionDate}');

        if (productItem.productId == "single_month_subscription") {
          _questionProvider.switchToPremium(
              productItem.transactionId,
              productItem.transactionDate,
              DateTime.now().copyWithAdditional(years: 0, months: 1));
          print(DateTime.now().copyWithAdditional(years: 0, months: 1));
        } else if (productItem.productId == "twelve_month_subscription") {
          _questionProvider.switchToPremium(
              productItem.transactionId,
              productItem.transactionDate,
              DateTime.now().copyWithAdditional(years: 0, months: 12));
          print(DateTime.now().copyWithAdditional(years: 0, months: 12));
        } else if (productItem.productId == "six_month_subsciption") {
          _questionProvider.switchToPremium(
              productItem.transactionId,
              productItem.transactionDate,
              DateTime.now().copyWithAdditional(years: 0, months: 6));
          print(DateTime.now().copyWithAdditional(years: 0, months: 6));
        }
        print('purchase-updated: ${productItem.productId}');
        print('purchase-updated: ${productItem.transactionReceipt}');
        popToPreviousScreen(context: context);
        popToPreviousScreen(context: context);
      });

      _purchaseErrorSubscription =
          FlutterInappPurchase.purchaseError.listen((purchaseError) {
        popToPreviousScreen(context: context);
        popToPreviousScreen(context: context);
        print('purchase-error: $purchaseError');
      });

      // print('consumeAllItems: $msg');
      try {
        await _getProduct(context);
      } catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
  }

  Future<Null> _getProduct(BuildContext context) async {
    showCircularDialog(context);
    try {
      List<IAPItem> items = await FlutterInappPurchase.instance
          .getSubscriptions([iapId, iapId2, iapId3]);
      for (var item in items) {
        print('${item.toString()}');
        this._items.add(item);
      }
      setState(() {
        popToPreviousScreen(context: context);
        this._items = items;
        // this._purchases = [];
      });
    } catch (error) {
      popToPreviousScreen(context: context);
      print(error);
    }
  }

  Future<Null> _buyProduct(IAPItem item) async {
    try {
      //  print(await FlutterInappPurchase.instance.finishTransactionIOS("1000000797194283"));
      print(item.productId);
      showCircularDialog(context);
      PurchasedItem purchased =
          await FlutterInappPurchase.instance.requestPurchase(item.productId);
      print(purchased);
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (error) {
      popToPreviousScreen(context: context);
      print('$error');
    }
  }

  bool isShowPremiumDialog = true;
  bool isAnsweredUpdated = false;

  Future<void> saveEndlessCorrectQuestionCount(
    QuestionProvider questionProvider,
    SharedPreferenceProvider sharedPrefProvider,
    /*BuildContext context*/
  ) async {
    Map<String, Map<String, dynamic>> subCatCount = {};
    questionProvider.getAnsweredQuestions.forEach((element) async {
      if (subCatCount.containsKey(element.subCategory)) {
        // subCatCount[element.subCategory] = subCatCount[element.subCategory] + 1;
        if (element.selectedAnswer == element.answer) {
          subCatCount[element.subCategory] = {
            'subCatId': element.subCategoryId,
            'subCatName': element.subCategory,
            'category': element.category,
            'categoryId': element.categoryId,
            'questionCount':
                subCatCount[element.subCategory]['questionCount'] + 1,
            'correctCount':
                subCatCount[element.subCategory]['correctCount'] + 1,
          };
          // subCatCount[element.subCategory]=params;
        } else {
          subCatCount[element.subCategory] = {
            'subCatId': element.subCategoryId,
            'subCatName': element.subCategory,
            'category': element.category,
            'categoryId': element.categoryId,
            'questionCount':
                subCatCount[element.subCategory]['questionCount'] + 1,
            'correctCount': subCatCount[element.subCategory]['correctCount'],
          };
        }
      } else {
        if (element.selectedAnswer == element.answer) {
          Map<String, dynamic> params = {
            'subCatId': element.subCategoryId,
            'subCatName': element.subCategory,
            'category': element.category,
            'categoryId': element.categoryId,
            'questionCount': 1,
            'correctCount': 1,
          };
          subCatCount[element.subCategory] = params;
        } else {
          Map<String, dynamic> params = {
            'subCatId': element.subCategoryId,
            'subCatName': element.subCategory,
            'category': element.category,
            'categoryId': element.categoryId,
            'questionCount': 1,
            'correctCount': 0,
          };
          subCatCount[element.subCategory] = params;
        }
        // subCatCount[element.subCategory] = 1;
      }
      /*subCatCount[element.subCategory] =
          subCatCount.containsKey(element.subCategory)
              ? subCatCount[element.subCategory] + 1
              : 1;*/
      /* if (element.selectedAnswer == element.answer) {
        await questionProvider.saveEndlessCorrectQuestionCount(
          sharedPrefProvider.userDataModel.userId,
          element.subCategoryId,
          element.subCategory,
          element.categoryId,
          element.category,
        );
        print('Correct');
      } else {
        print("In correct");
      }*/
    });
    print(subCatCount);
    subCatCount.forEach((key, value) {
      if (value['correctCount'] != 0) {
        double percentageOutput =
            ((value['correctCount'] / value['questionCount']) * 100);
        int percentage = int.parse(percentageOutput.toStringAsFixed(0));
        questionProvider.saveEndlessCorrectQuestionCount(
          sharedPrefProvider.userDataModel.userId,
          value['subCatId'],
          value['subCatName'],
          value['categoryId'],
          value['category'],
          percentage,
        );
      }
    });

    /*setState(() {
      isAnsweredUpdated = true;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var fourQuestionsProvider = Provider.of<FourQuestionsProvider>(context);
    var questionProvider = Provider.of<QuestionProvider>(context);
    var sharePrefProvider = Provider.of<SharedPreferenceProvider>(context);
    var optionProvider = Provider.of<OptionProvider>(context);

    String highestScore;
    if (sharePrefProvider.userDataModel.endlessModeHighscore != null) {
      if ((sharePrefProvider
                  .userDataModel.endlessModeRemovedCategories.length ==
              0) &&
          (sharePrefProvider
                  .userDataModel.endlessModeRemovedSubcategories.length ==
              0)) {
        if (int.parse(sharePrefProvider.userDataModel.endlessModeHighscore) <
            questionProvider.getCorrectAnswersCount) {
          optionProvider.setUserEndlessHighScore(
              questionProvider.getCorrectAnswersCount.toString(),
              sharePrefProvider.userDataModel.userId);
          highestScore = questionProvider.getCorrectAnswersCount.toString();
        } else {
          highestScore = sharePrefProvider.userDataModel.endlessModeHighscore;
        }
      } else {
        highestScore = sharePrefProvider.userDataModel.endlessModeHighscore;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        questionProvider.setNewQuestion();
        questionProvider.clearAnsweredQuestionsList();
        questionProvider.setSelectedMode(0);

        // remainingCount.resetLife();
        popToPreviousScreen(context: context);
        popToPreviousScreen(context: context);

        return false;
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: appbarTopMargin,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: Dimensions.pixels_24,
                          ),
                          child: Text(
                            "Game Over!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.pixels_33,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(top: Dimensions.pixels_128),
                                decoration: getScreenBackgroundDecoration(),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: Dimensions.pixels_51,
                                    left: Dimensions.pixels_30,
                                    right: Dimensions.pixels_30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(Dimensions.pixels_10),
                                    topRight:
                                        Radius.circular(Dimensions.pixels_10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: Dimensions.pixels_20),
                                      child: Image(
                                        image: AssetImage(game_over),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.pixels_30,
                                    ),
                                    Text(
                                      "You got ${questionProvider.getCorrectAnswersCount} out of ${questionProvider.getAnsweredQuestions.length} correct",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: Dimensions.pixels_20,
                                    ),
                                    Text(
                                      "Your highest score is $highestScore",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    RoundedEdgeButton(
                                        color: Colors.black,
                                        text: "Try Again",
                                        textFontSize: Dimensions.pixels_18,
                                        height: Dimensions.pixels_60,
                                        textFontWeight: FontWeight.w400,
                                        topMargin: Dimensions.pixels_51,
                                        buttonRadius: 0,
                                        textColor: Colors.white,
                                        onPressed: (value) {
                                          questionProvider.setNewQuestion();
                                          questionProvider
                                              .clearAnsweredQuestionsList();
                                          questionProvider.setSelectedMode(1);
                                          /*
                                        fourQuestionsProvider
                                            .setCurrentQuestion(context);
                                        fourQuestionsProvider
                                            .clearAnsweredQuestionsList();
*/

                                          Navigator.pop(context);
                                        },
                                        context: context),
                                    RoundedEdgeButton(
                                        color: successColor,
                                        text: "See Answers",
                                        textFontSize: Dimensions.pixels_18,
                                        height: Dimensions.pixels_60,
                                        buttonRadius: 0,
                                        topMargin: Dimensions.pixels_18,
                                        textColor: Colors.white,
                                        textFontWeight: FontWeight.w400,
                                        onPressed: (value) {
                                          pushToNextScreenWithFadeAnimation(
                                            context: context,
                                            destination:
                                                YourAnswersEndlessMode(),
                                          );
                                        },
                                        context: context),
                                    RoundedEdgeButton(
                                        color: primaryColor,
                                        text: "Back to Menu",
                                        buttonRadius: 0,
                                        textFontSize: Dimensions.pixels_18,
                                        height: Dimensions.pixels_60,
                                        textFontWeight: FontWeight.w400,
                                        topMargin: Dimensions.pixels_18,
                                        bottomMargin: Dimensions.pixels_30,
                                        textColor: Colors.white,
                                        onPressed: (value) {
                                          questionProvider.setNewQuestion();
                                          questionProvider
                                              .clearAnsweredQuestionsList();
                                          questionProvider.setSelectedMode(0);
                                          // remainingCount.resetLife();
                                          popToPreviousScreen(context: context);
                                          popToPreviousScreen(context: context);
                                        },
                                        context: context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  premiumDialog(BuildContext ctx) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.pixels_24),
          ),
          child: Container(
            padding: EdgeInsets.all(Dimensions.pixels_15),
            /*  decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Dimensions.pixels_20,
              ),
              color: Colors.white,
            ),*/
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(pop_up_image),
                      //height: Dimensions.pixels_250,
                    ),
                    SizedBox(
                      height: Dimensions.pixels_20,
                    ),
                    Text(
                      "Go Premium Now!",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.pixels_25),
                    ),
                    SizedBox(
                      height: Dimensions.pixels_20,
                    ),
                    Text(
                      "Unlock over 3000 questions,\nleaderboards,a and more!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: hintGrey),
                    ),
                    SizedBox(
                      height: Dimensions.pixels_50,
                    ),
                    RoundedEdgeButton(
                        color: primaryColor,
                        text: "Buy now",
                        leftMargin: Dimensions.pixels_30,
                        height: Dimensions.pixels_50,
                        textFontSize: Dimensions.pixels_18,
                        buttonRadius: Dimensions.pixels_15,
                        rightMargin: Dimensions.pixels_30,
                        bottomMargin: Dimensions.pixels_30,
                        textColor: Colors.white,
                        onPressed: (value) {
                          popToPreviousScreen(context: context);
                          _inAppBottomSheet(context);
                        },
                        context: context),
                  ],
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      popToPreviousScreen(context: context);
                    },
                    child: Icon(
                      Icons.cancel,
                      size: Dimensions.pixels_30,
                      color: hintEditTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _inAppBottomSheet(BuildContext context) {
    _items.length == 0
        ? showCircularDialog(context)
        : showModalBottomSheet<dynamic>(
            barrierColor: hintGrey.withOpacity(0.3),
            backgroundColor: Colors.transparent,
            isDismissible: true,
            context: context,
            isScrollControlled: true,
            elevation: 15,
            /* shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),*/
            builder: (BuildContext bc) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.pixels_24),
                        topRight: Radius.circular(Dimensions.pixels_24)),
                    color: settingBackgroundColor,
                  ),
                  padding: EdgeInsets.only(top: Dimensions.pixels_20),
                  child: new Wrap(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        //   margin: EdgeInsets.only(top: 24.0),
                        width: double.infinity,
                        //   color: AppColors.white,
                        child: Text(
                          "Go Premium",
                          style: TextStyle(
                              fontSize: Dimensions.pixels_20,
                              fontWeight: FontWeight.w900,
                              color: primaryColor),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: Dimensions.pixels_24,
                            left: Dimensions.pixels_20),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(discount),
                              height: Dimensions.pixels_30,
                              width: Dimensions.pixels_30,
                              color: settingTextColor,
                            ),
                            SizedBox(
                              width: Dimensions.pixels_5,
                            ),
                            Text(
                              "Unlimited Access to 3900+ Questions",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.pixels_16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.pixels_15,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: Dimensions.pixels_24,
                            left: Dimensions.pixels_20),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(discount),
                              height: Dimensions.pixels_30,
                              width: Dimensions.pixels_30,
                              color: settingTextColor,
                            ),
                            SizedBox(
                              width: Dimensions.pixels_5,
                            ),
                            Text(
                              "Bookmark questions for further review",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.pixels_16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.pixels_15,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: Dimensions.pixels_24,
                            left: Dimensions.pixels_20),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(discount),
                              height: Dimensions.pixels_30,
                              width: Dimensions.pixels_30,
                              color: settingTextColor,
                            ),
                            SizedBox(
                              width: Dimensions.pixels_5,
                            ),
                            Text(
                              "Detailed explanations for every question",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.pixels_16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.pixels_15,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: Dimensions.pixels_24,
                            left: Dimensions.pixels_20),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(discount),
                              height: Dimensions.pixels_30,
                              width: Dimensions.pixels_30,
                              color: settingTextColor,
                            ),
                            SizedBox(
                              width: Dimensions.pixels_5,
                            ),
                            Text(
                              "Get early access to  new features",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.pixels_16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.pixels_30,
                      ),
                      Container(
                        height: Dimensions.pixels_250,
                        margin: EdgeInsets.only(
                            top: Dimensions.pixels_30,
                            left: Dimensions.pixels_16,
                            right: Dimensions.pixels_16),
                        child: GridView.builder(
                            itemCount: this._items.length,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _buyProduct(_items.elementAt(index));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: settingTextColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.pixels_12),
                                      ),
                                      padding:
                                          EdgeInsets.all(Dimensions.pixels_8),
                                      child: Column(
                                        children: [
                                          Text(
                                            _items.elementAt(index).title,
                                            softWrap: true,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.pixels_12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Dimensions.pixels_5,
                                          ),
                                          Text(
                                            Platform.isAndroid
                                                ? _items
                                                    .elementAt(index)
                                                    .localizedPrice
                                                : _items
                                                    .elementAt(index)
                                                    .localizedPrice,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            });
  }
}
