import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/review_screens_module/review_mode_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/timed_mode_module/timed_mode_page.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/card_widget_with_hint.dart';

import 'package:provider/provider.dart';

import 'end_less_mode_module/endless_mode_page.dart';

class SinglePlayerPage extends StatefulWidget {
  @override
  _SinglePlayerPageState createState() => _SinglePlayerPageState();
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

class _SinglePlayerPageState extends State<SinglePlayerPage> with BaseClass {
  final String iapId = "single_month_subscription";
  final String iapId2 = "twelve_month_subscription";
  final String iapId3 = "six_month_subsciption";
  List<IAPItem> _items = [];

  /*InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);

  }*/

  @override
  void initState() {
    // TODO: implement initState
    /*  final provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();*/
    final sharedPref =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    super.initState();
    if (mounted) {
      if (sharedPref.userDataModel.isPremium != null) {
        if (!sharedPref.userDataModel.isPremium) {
          initPlatformState(context);
        }
      } else {
        initPlatformState(context);
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    final sharedPref = Provider.of<SharedPreferenceProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(builder: (context, constraint) {
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
                        top: Dimensions.pixels_15, left: Dimensions.pixels_30),
                    child: Text(
                      "Single Player",
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Image(
                              image: AssetImage(modes_bottom_right_background),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.pixels_30,
                                    right: Dimensions.pixels_30,
                                    top: Dimensions.pixels_30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: FlipInX(
                                        //  spins: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            pushToNextScreenWithFadeAnimation(
                                                context: context,
                                                destination: EndlessModePage());
                                          },
                                          child: Container(
                                            height: Dimensions.pixels_135,
                                            decoration: BoxDecoration(
                                                color: endlessMOdeColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.pixels_10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showToolTip(
                                                          "Survive with five lives against the onslaught of questions!",
                                                          "Endless Mode",
                                                          endlessMOdeColor);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: Dimensions
                                                              .pixels_10),
                                                      child: Image(
                                                        image: AssetImage(
                                                            question_mark),
                                                        height: Dimensions
                                                            .pixels_20,
                                                        width: Dimensions
                                                            .pixels_20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Image(
                                                  image:
                                                      AssetImage(endless_mode),
                                                  height: Dimensions.pixels_35,
                                                  width: Dimensions.pixels_78,
                                                ),
                                                Text(
                                                  "Endless Mode",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Dimensions.pixels_16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.pixels_25,
                                    ),
                                    Expanded(
                                      child: FlipInX(
                                        // spins: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            pushToNextScreenWithFadeAnimation(
                                                context: context,
                                                destination: TimedModePage());
                                          },
                                          child: Container(
                                            height: Dimensions.pixels_135,
                                            decoration: BoxDecoration(
                                                color: timedModeColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.pixels_10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showToolTip(
                                                          "60 seconds to prove yourself victorious!",
                                                          "Timed Mode",
                                                          timedModeColor);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: Dimensions
                                                              .pixels_10),
                                                      child: Image(
                                                        image: AssetImage(
                                                            question_mark),
                                                        height: Dimensions
                                                            .pixels_20,
                                                        width: Dimensions
                                                            .pixels_20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Image(
                                                  image: AssetImage(timed_mode),
                                                  height: Dimensions.pixels_35,
                                                  width: Dimensions.pixels_78,
                                                ),
                                                Text(
                                                  "Timed Mode",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Dimensions.pixels_16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.pixels_30,
                              ),
                              FlipInX(
                                child: CardWidgetWithHint(
                                  cardHeight: Dimensions.pixels_120,
                                  leftMargin: Dimensions.pixels_30,
                                  rightMargin: Dimensions.pixels_30,
                                  cardRadius: Dimensions.pixels_5,
                                  onQuestionMarkClicked: (value) {
                                    showToolTip(
                                        "Review your flagged questions!",
                                        "Review Mode",
                                        reviewModeColor);
                                  },
                                  cardTextFontSize: Dimensions.pixels_18,
                                  onCardClicked: (value) async {
                                    if (!sharedPref.userDataModel.isPremium) {
                                      _inAppBottomSheet(context);
                                    } else {
                                      pushToNextScreenWithFadeAnimation(
                                          context: value,
                                          destination: ReviewModePage());
                                    }

                                    /*   if (provider.available) {
                                      print("Available");
                                      for (var prod in provider.products) {
                                        print(prod);
                                        if (provider.hasPurchased(prod.id) != null) {
                                          print("Has purchased");
                                        } else {
                                          print(prod);
                                          ProductDetails productss = prod ;
                                          print(productss.id);
                                          _buyProduct(prod);
                                        }
                                      }
                                    } else {
                                      print("Not avaioable");
                                    }*/
                                  },
                                  context: context,
                                  cardTitle: "Review Mode",
                                  cardTextColor: Colors.white,
                                  cardBackgroundColor: reviewModeColor,
                                  cardTrailingImage: review_mode_icon,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.pixels_30,
                              ),
                              /*   FlipInX(
                                child: CardWidgetWithHint(
                                  cardHeight: Dimensions.pixels_120,
                                  leftMargin: Dimensions.pixels_30,
                                  rightMargin: Dimensions.pixels_30,
                                  cardTextFontSize: Dimensions.pixels_18,
                                  cardRadius: Dimensions.pixels_5,
                                  onCardClicked: (value) {
                                    if (!sharedPref.userDataModel.isPremium) {
                                      _inAppBottomSheet(context);
                                    } else {
                                      pushToNextScreenWithFadeAnimation(
                                          context: value,
                                          destination: OverViewModePage());
                                    }
                                  },
                                  context: context,
                                  cardTextColor: Colors.white,
                                  cardTitle: "Overview Mode",
                                  cardBackgroundColor: overviewModeColor,
                                  cardTrailingImage: overview_mode_icon,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.pixels_30,
                              ),
                              FlipInX(
                                child: CardWidgetWithHint(
                                  cardHeight: Dimensions.pixels_120,
                                  leftMargin: Dimensions.pixels_30,
                                  rightMargin: Dimensions.pixels_30,
                                  bottomMargin: Dimensions.pixels_30,
                                  cardRadius: Dimensions.pixels_5,
                                  cardTextFontSize: Dimensions.pixels_18,
                                  onCardClicked: (value) {
                                    if (!sharedPref.userDataModel.isPremium) {
                                      _inAppBottomSheet(context);
                                    } else {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: FlashCardPage());
                                    }
                                  },
                                  context: context,
                                  cardTitle: "Flashcards",
                                  cardTextColor: Colors.white,
                                  cardBackgroundColor: flashcardsModeColor,
                                  cardTrailingImage: flashcards_icon,
                                ),
                              ),*/
                            ],
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
      }),
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

  void showToolTip(String message, String title, Color selectedModeColor) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => Center(
        child: Card(
          margin: EdgeInsets.only(
              left: Dimensions.pixels_56, right: Dimensions.pixels_56),
          elevation: Dimensions.pixels_5,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(Dimensions.pixels_10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      popToPreviousScreen(context: context);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: selectedModeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: Dimensions.pixels_5,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: Dimensions.pixels_8, top: Dimensions.pixels_8),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: Dimensions.pixels_5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
