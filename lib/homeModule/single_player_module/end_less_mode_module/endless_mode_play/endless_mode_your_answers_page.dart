import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:kings_of_the_curve/models/question_with_answers_model.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/blur_widget_filter.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class YourAnswersEndlessMode extends StatefulWidget {
  @override
  _YourAnswersEndlessModeState createState() => _YourAnswersEndlessModeState();
}

extension CopyWithAdditional on DateTime {
  DateTime copyWithAdditional({
    int years,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    return DateTime(
      year + years,
      month + months,
      day + days,
      hour + hours,
      minute + minutes,
      second + seconds,
      millisecond + milliseconds,
      microsecond + microseconds,
    );
  }
}

class _YourAnswersEndlessModeState extends State<YourAnswersEndlessMode>
    with BaseClass {
  final String iapId = "single_month_subscription";
  final String iapId2 = "twelve_month_subscription";
  final String iapId3 = "six_month_subscription";
  List<IAPItem> _items = [];

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _connectionSubscription;

  @override
  void initState() {
    // TODO: implement initState
    /*  final provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();*/
    final sharedPref =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!sharedPref.userDataModel.isPremium) {
        if (isShowPremiumDialog) {
          Future.delayed(const Duration(milliseconds: 500), () {
            premiumDialog(context);
            isShowPremiumDialog = false;
          });
        }
      }
      if (!sharedPref.userDataModel.isPremium)
        initPlatformState(context, questionProvider);
      /*saveEndlessCorrectQuestionCount(
          questionProvider, sharePrefProvider, context);*/
    });
  }

  Future<void> initPlatformState(
      BuildContext context, QuestionProvider questionProvider) async {
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

      _connectionSubscription =
          FlutterInappPurchase.connectionUpdated.listen((connected) {
        print('connected: $connected');
      });

      _purchaseUpdatedSubscription =
          FlutterInappPurchase.purchaseUpdated.listen((productItem) {
        print("Android" + productItem.dataAndroid.toString());
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
        } else if (productItem.productId == "six_month_subscription") {
          _questionProvider.switchToPremium(
              productItem.transactionId,
              productItem.transactionDate,
              DateTime.now().copyWithAdditional(years: 0, months: 6));
          print(DateTime.now().copyWithAdditional(years: 0, months: 6));
        }
        print('purchase-updated: ${productItem.productId}');
        print('purchase-updated: ${productItem.transactionReceipt}');
        questionProvider.setNewQuestion();
        questionProvider.clearAnsweredQuestionsList();
        questionProvider.setSelectedMode(0);
        popToPreviousScreen(context: context);
        popToPreviousScreen(context: context);
        popToPreviousScreen(context: context);
      });

      _purchaseErrorSubscription =
          FlutterInappPurchase.purchaseError.listen((purchaseError) {
        //   popToPreviousScreen(context: context);
        //    popToPreviousScreen(context: context);

        showError(context, purchaseError.message);
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
    if (_connectionSubscription != null) {
      _connectionSubscription.cancel();
      _connectionSubscription = null;
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
      //popToPreviousScreen(context: context);

      print('$error');
    }
  }

  bool isShowPremiumDialog = true;

  @override
  Widget build(BuildContext context) {
    var questionProvider = Provider.of<QuestionProvider>(context);
    var optionProvider = Provider.of<OptionProvider>(context);
    var sharedPrefProvider = Provider.of<SharedPreferenceProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomAppBar(context, topMargin: appBarTopMargin),
              Container(
                margin: EdgeInsets.only(
                    top: Dimensions.pixels_15, left: Dimensions.pixels_30),
                child: Text(
                  "Your Answers",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.pixels_33,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.pixels_30,
                  ),
                  padding: EdgeInsets.only(bottom: Dimensions.pixels_30),
                  decoration: getScreenBackgroundDecoration(
                      color: settingAccountDetailBackgroundColor),
                  child: questionProvider.getAnsweredQuestions.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              questionProvider.getAnsweredQuestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.pixels_30,
                                  right: Dimensions.pixels_30,
                                  top: Dimensions.pixels_30),
                              child: _getQuestionsWithAnswersWidget(
                                  questionProvider.getAnsweredQuestions
                                      .elementAt(index),
                                  optionProvider,
                                  questionProvider,
                                  sharedPrefProvider,
                                  title: "Question ${index + 1}",
                                  position: index),
                            );
                          })
                      : Container(
                          child: Center(
                            child: Text(
                              "You haven't answered any questions in this round.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: titleColor,
                              ),
                            ),
                          ),
                        ),
                ),
              )
            ],
          );
        },
      ),
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

  Widget _getQuestionsWithAnswersWidget(
      QuestionWithAnswersModel fourQuestionModel,
      OptionProvider optionProvider,
      QuestionProvider questionProvider,
      SharedPreferenceProvider sharedPreferenceProvider,
      {String title,
      int position}) {
    return Container(
      padding: EdgeInsets.all(Dimensions.pixels_20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.pixels_5)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: Dimensions.pixels_16,
                    fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (sharedPreferenceProvider.userDataModel.isPremium) {
                        if (sharedPreferenceProvider
                            .userDataModel.bookMarkedQuestions
                            .contains(fourQuestionModel.documentId)) {
                          // remove from user review list
                          showCircularDialog(context);
                          bool value =
                              await questionProvider.removeEndlessReview(
                                  fourQuestionModel,
                                  sharedPreferenceProvider
                                      .userDataModel.userId);
                          popToPreviousScreen(context: context);
                          setState(() {});
                        } else {
                          // add in user review list
                          showCircularDialog(context);
                          bool value = await questionProvider.addEndlessReview(
                              fourQuestionModel,
                              sharedPreferenceProvider.userDataModel.userId);
                          popToPreviousScreen(context: context);
                          setState(() {});
                        }
                      } else {
                        premiumDialog(context);
                      }
                    },
                    child: Image(
                      image: AssetImage(bookmark_fill),
                      height: Dimensions.pixels_20,
                      width: Dimensions.pixels_30,
                      color: sharedPreferenceProvider
                              .userDataModel.bookMarkedQuestions
                              .contains(fourQuestionModel.documentId)
                          ? singlePlayerTextColor
                          : Colors.grey,
                    ),
                  ),
                  /* SizedBox(
                    width: Dimensions.pixels_10,
                  ),*/
                  /*  GestureDetector(
                    onTap: () async {
                      if (sharedPreferenceProvider
                          .userDataModel.flaggedQuestions
                          .contains(fourQuestionModel.documentId)) {
                        // remove from user review list
                        showCircularDialog(context);
                        bool value = await questionProvider.removeFlag(
                            fourQuestionModel,
                            sharedPreferenceProvider.userDataModel.userId);
                        popToPreviousScreen(context: context);
                        setState(() {});
                      } else {
                        // add in user review list
                        showCircularDialog(context);
                        bool value = await questionProvider.addFlag(
                            fourQuestionModel,
                            sharedPreferenceProvider.userDataModel.userId);
                        popToPreviousScreen(context: context);
                        setState(() {});
                      }
                    },
                    child: Image(
                      image: AssetImage(flag_bug_report),
                      height: Dimensions.pixels_20,
                      width: Dimensions.pixels_20,
                      color: sharedPreferenceProvider
                              .userDataModel.flaggedQuestions
                              .contains(fourQuestionModel.documentId)
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),*/
                ],
              )
            ],
          ),
          SizedBox(
            height: Dimensions.pixels_20,
          ),
          Text(
            fourQuestionModel.question,
            style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.pixels_16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: Dimensions.pixels_20,
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: Dimensions.pixels_5,
                mainAxisSpacing: Dimensions.pixels_5),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return Container(
                child: _getAnswerTile(
                    backgroundColor: getOptionBackgroundColor(
                        correctAnswer: fourQuestionModel.answer,
                        selectedAnswer: fourQuestionModel.selectedAnswer,
                        optionIndex: (index + 1).toString()),
                    textColor: getOptionTextColor(
                        correctAnswer: fourQuestionModel.answer,
                        selectedAnswer: fourQuestionModel.selectedAnswer,
                        optionIndex: (index + 1).toString()),
                    title:
                        fourQuestionModel.options.elementAt(index).optionText,
                    subTitle: "10%"),
              );
            },
            itemCount: fourQuestionModel.options.length,
          ),
          SizedBox(
            height: Dimensions.pixels_15,
          ),
          SizedBox(
            height: Dimensions.pixels_10,
          ),
          getDivider(),
          SizedBox(
            height: Dimensions.pixels_10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: sharedPreferenceProvider.userDataModel.isPremium
                ? getQuestionExplanation(fourQuestionModel)
                : position > 2
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          BlurFilter(
                            child: getQuestionExplanation(fourQuestionModel),
                          ),
                          GestureDetector(
                            onTap: () {
                              _inAppBottomSheet(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.pixels_15),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.pixels_5),
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: Text(
                                "Premium",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      )
                    : getQuestionExplanation(fourQuestionModel),
          ),
          SizedBox(
            height: Dimensions.pixels_10,
          ),
          fourQuestionModel.questionImages != null
              ? fourQuestionModel.questionImages.length > 0
                  ? sharedPreferenceProvider.userDataModel.isPremium
                      ? getQuestionImages(fourQuestionModel)
                      : position > 2
                          ? BlurFilter(
                              child: getQuestionImages(fourQuestionModel),
                            )
                          : getQuestionImages(fourQuestionModel)
                  : Container()
              : Container(),
          SizedBox(
            height: Dimensions.pixels_10,
          )
        ],
      ),
    );
  }

  ClipRRect getQuestionImages(QuestionWithAnswersModel fourQuestionModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.pixels_15),
      child: Container(
        height: Dimensions.pixels_250,
        decoration: BoxDecoration(
            /* borderRadius:
                              BorderRadius.circular(Dimensions.pixels_15),*/
            ),
        child: Carousel(
          images: fourQuestionModel.questionImages,
          autoplay: false,
          dotSize: Dimensions.pixels_7,
          dotVerticalPadding: Dimensions.pixels_5,
          dotBgColor: Colors.transparent,
          onImageTap: (int index) {
            _imageViewBottomSheet(
              context,
              fourQuestionModel.questionImages.elementAt(index),
            );
          },
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          //boxFit: BoxFit.cover,
          dotSpacing: Dimensions.pixels_20,
          indicatorBgPadding: Dimensions.pixels_5,
          dotColor: Colors.white,
          dotIncreasedColor: Colors.white,
          borderRadius: false,
        ),
      ),
    );
  }

  Text getQuestionExplanation(QuestionWithAnswersModel fourQuestionModel) {
    return Text(
      fourQuestionModel.explanation,
      style: TextStyle(
          color: notAttemptedAnswerTextColor,
          fontSize: Dimensions.pixels_16,
          fontWeight: FontWeight.w400),
    );
  }
}

Color getOptionBackgroundColor({
  @required String correctAnswer,
  @required String selectedAnswer,
  @required String optionIndex,
}) {
  if (selectedAnswer == optionIndex) {
    if (correctAnswer == selectedAnswer) {
      return correctAnswerBackgroundColor;
    } else {
      return wrongAnswerBackground;
    }
  } else {
    if (correctAnswer == optionIndex) {
      return correctAnswerBackgroundColor;
    } else {
      return dividerColor;
    }
  }
}

Color getOptionTextColor({
  @required String correctAnswer,
  @required String selectedAnswer,
  @required String optionIndex,
}) {
  if (selectedAnswer == optionIndex) {
    if (correctAnswer == selectedAnswer) {
      return successColor;
    } else {
      return wrongAnswerTextColor;
    }
  } else {
    if (correctAnswer == optionIndex) {
      return successColor;
    } else {
      return notAttemptedAnswerTextColor;
    }
  }
}

Widget _getAnswerTile(
    {String title, Color backgroundColor, Color textColor, String subTitle}) {
  return Container(
    padding: EdgeInsets.all(Dimensions.pixels_15),
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.pixels_5)),
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: Dimensions.pixels_14,
          ),
        ),
      ),
    ),
  );
}

void _imageViewBottomSheet(BuildContext context, NetworkImage imageView) {
  showModalBottomSheet<dynamic>(
      barrierColor: hintGrey.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      elevation: 15,
      builder: (BuildContext bc) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.pixels_24),
                topRight: Radius.circular(Dimensions.pixels_24),
              ),
              color: Colors.black,
            ),
            padding: EdgeInsets.only(
                top: Dimensions.pixels_25, bottom: Dimensions.pixels_25),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      color: hintGrey,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Image(image: imageView),
                ],
              ),
            ),
          ),
        );
      });
}
