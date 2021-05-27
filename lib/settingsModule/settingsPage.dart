import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:kings_of_the_curve/authentication/loginPage.dart';
import 'package:kings_of_the_curve/blocs/auth_bloc.dart';
import 'package:kings_of_the_curve/providers/question_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/settingsModule/accountDetailsPage.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/settingsOptionWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_stats_page.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/end_less_mode_module/endless_mode_play/endless_mode_your_answers_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with BaseClass {
  double sizedBoxHeight = Dimensions.pixels_20;
  final String iapId = "single_month_subscription";
  final String iapId2 = "twelve_month_subscription";
  final String iapId3 = "six_month_subscription";
  List<IAPItem> _items = [];

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _connectionSubscription;

  /*@override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchaseDetailsList) {
      // handle purchase details
      _listenToPurchaseUpdated(purchaseDetailsList);
    });
    super.initState();
    getProducts();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showError(context, "Pending");
        print("PENDING");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          showError(context, "SOmething went wrong");
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          if (purchaseDetails.productID == "single_month_subscription") {
            print("ONE MONTH");
          } else if (purchaseDetails.productID == "twelve_month_subscription") {
            print("YEAR");
          } else if (purchaseDetails.productID == "six_month_subscription") {
            print("6 months");
          }
          */ /*    bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }*/ /*
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  static InAppPurchaseConnection get instance => _getOrCreateInstance();
  static InAppPurchaseConnection _instance;

  static InAppPurchaseConnection _getOrCreateInstance() {
    if (Platform.isAndroid) {
      _instance = InAppPurchaseConnection.instance;
    } else if (Platform.isIOS) {
      _instance = InAppPurchaseConnection.instance;
    }
    return _instance;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  List<ProductDetails> detailProduct;

  final String iapId = "single_month_subscription";
  final String iapId2 = "twelve_month_subscription";
  final String iapId3 = "six_month_subscription";

  StreamSubscription<List<PurchaseDetails>> _subscription;

  getProducts() async {
    detailProduct = await retrieveProducts();
  }

  Future<List<ProductDetails>> retrieveProducts() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (!available) {
      // Handle store not available
      print("No Product Available");
      return null;
    } else {
      showCircularDialog(context);
      Set<String> _kIds = <String>[iapId, iapId2, iapId3].toSet();
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error if desired
        print("No Id Found");
      }
      popToPreviousScreen(context: context);
      print(response);
      return new Future(() => response.productDetails);
    }
  }

  void purchaseItem(ProductDetails productDetails) {
    showCircularDialog(context);
    FlutterInappPurchase.instance.clearTransactionIOS().then((value) {
      PurchaseParam purchaseParam = PurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          sandboxTesting: false);
      sleep(const Duration(seconds: 1));
      popToPreviousScreen(context: context);
      InAppPurchaseConnection.instance
          .buyNonConsumable(purchaseParam: purchaseParam);
    });
  }*/

  @override
  void initState() {
    final sharedPref =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        print("ANDROID" + productItem.dataAndroid.toString());
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
        if (purchaseError.code == "E_USER_CANCELLED") {
          popToPreviousScreen(context: context);
          popToPreviousScreen(context: context);
        }
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

  void _inAppBottomSheet(BuildContext context) {
    /*detailProduct.length == 0*/ _items.length == 0
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
                            itemCount: this. /*detailProduct*/ _items.length,
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
                                      /*purchaseItem(
                                          detailProduct.elementAt(index));*/
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
                                            /*detailProduct*/
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
                                                ? /*detailProduct*/ _items
                                                    .elementAt(index)
                                                    .localizedPrice
                                                : /*detailProduct*/ _items
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

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    final sharedPrefProvider = Provider.of<SharedPreferenceProvider>(context);
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
                    getCustomAppBar(context, topMargin: appBarTopMargin),
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.pixels_15,
                          left: Dimensions.pixels_30),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: Dimensions.pixels_33,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.pixels_30),
                      decoration: getScreenBackgroundDecoration(),
                      child: Column(
                        children: [
                          Container(
                            decoration: getScreenBackgroundDecoration(
                                color: settingAccountDetailBackgroundColor),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.pixels_30,
                                  right: Dimensions.pixels_30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: Dimensions.pixels_30),
                                        child: Text(
                                          "Account Details",
                                          style: TextStyle(
                                              color: titleColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: Dimensions.pixels_24),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          pushToNextScreenWithFadeAnimation(
                                              context: context,
                                              destination: AccountDetailPage(),
                                              duration: 100);
                                        },
                                        child: Container(
                                          width: Dimensions.pixels_67,
                                          height: Dimensions.pixels_30,
                                          margin: EdgeInsets.only(
                                              top: Dimensions.pixels_30),
                                          decoration: BoxDecoration(
                                              color: editButtonColor,
                                              borderRadius:
                                                  BorderRadius.circular(17)),
                                          child: Center(
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimensions.pixels_35,
                                  ),
                                  SettingsOptionWidget(
                                    leadingImage: upgrade_premium,
                                    trailingImage: arrowRight,
                                    height: Dimensions.pixels_51,
                                    optionTitle: "Upgrade to premium",
                                    onClickOption: (value) {
                                      if (sharedPrefProvider
                                          .userDataModel.isPremium) {
                                        showError(context,
                                            "You are already a premium user");
                                      } else {
                                        _inAppBottomSheet(context);
                                      }

                                      /* pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: ChooseAPlanPage());*/
                                    },
                                  ),
                                  /* SizedBox(
                                    height: sizedBoxHeight,
                                  ),*/
                                  /* getDivider(),
                                  SizedBox(
                                    height: sizedBoxHeight,
                                  ),*/
                                  /* SettingsOptionWidget(
                                    leadingImage: redeem_code,
                                    trailingImage: arrowRight,
                                    height: Dimensions.pixels_51,
                                    optionTitle: "Redeem Code",
                                    onClickOption: (value) async {
                                      await InAppPurchaseConnection.instance
                                          .presentCodeRedemptionSheet();
                                    },
                                  ),*/
                                  /*SizedBox(
                                    height: sizedBoxHeight,
                                  ),*/
                                  getDivider(),
                                  SizedBox(
                                    height: sizedBoxHeight,
                                  ),
                                  SettingsOptionWidget(
                                    leadingImage: my_stats,
                                    trailingImage: arrowRight,
                                    optionTitle: "My Stats",
                                    bottomMargin: Dimensions.pixels_15,
                                    height: Dimensions.pixels_51,
                                    onClickOption: (value) {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: MyStatsPage());
                                    },
                                  ),
                                  getDivider(),
                                  SizedBox(
                                    height: sizedBoxHeight,
                                  ),
                                  SettingsOptionWidget(
                                    leadingImage: my_stats,
                                    trailingImage: arrowRight,
                                    optionTitle: "Logout",
                                    bottomMargin: Dimensions.pixels_15,
                                    height: Dimensions.pixels_51,
                                    onClickOption: (value) async {
                                      await sharedPrefProvider
                                          .clearPreference();
                                      authBloc.logout();
                                      pushReplaceAndClearStack(
                                          context: context,
                                          destination: LoginPage());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: settingAccountDetailBackgroundColor,
                            child: Container(
                              decoration: getScreenBackgroundDecoration(
                                  color: Colors.white),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.pixels_30,
                                    right: Dimensions.pixels_30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: Dimensions.pixels_30),
                                      child: Text(
                                        "App Information",
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Dimensions.pixels_24),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.pixels_35,
                                    ),
                                    /* SettingsOptionWidget(
                                      leadingImage: siri_shortcut,
                                      trailingImage: arrowRight,
                                      height: Dimensions.pixels_51,
                                      optionTitle: "Siri Shortcuts",
                                      onClickOption: () {},
                                    ),
                                    SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    getDivider(),*/
                                    /*    SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    SettingsOptionWidget(
                                      leadingImage: rate_in_app,
                                      trailingImage: arrowRight,
                                      height: Dimensions.pixels_51,
                                      optionTitle: Platform.isIOS
                                          ? "Rate in the App Store"
                                          : "Rate in the Play Store",
                                      onClickOption: () {},
                                    ),*/
                                    /* SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    getDivider(),
                                    SizedBox(
                                      height: sizedBoxHeight,
                                    ),*/
                                    SettingsOptionWidget(
                                      leadingImage: share_with_friend,
                                      trailingImage: arrowRight,
                                      height: Dimensions.pixels_51,
                                      optionTitle: "Share With a Friend",
                                      onClickOption: () {},
                                    ),
                                    SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    getDivider(),
                                    SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    SettingsOptionWidget(
                                      leadingImage: contact_us,
                                      trailingImage: arrowRight,
                                      height: Dimensions.pixels_51,
                                      bottomMargin: Dimensions.pixels_15,
                                      optionTitle: "Contact Us!",
                                      onClickOption: (value) {
                                        launchInBrowser(
                                            "https://www.instagram.com/mcatkingofthecurve/");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Container(
                              decoration: getScreenBackgroundDecoration(
                                  color: settingLegalBackgroundColor),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.pixels_30,
                                    right: Dimensions.pixels_30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: Dimensions.pixels_30),
                                      child: Text(
                                        "Legal",
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Dimensions.pixels_24),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.pixels_35,
                                    ),
                                    SettingsOptionWidget(
                                      leadingImage: privacy_policy,
                                      trailingImage: arrowRight,
                                      optionTitle: "Privacy Policy",
                                      height: Dimensions.pixels_51,
                                      onClickOption: (value) {
                                        launchInBrowser(
                                            "https://kingofthecurve.carrd.co/");
                                      },
                                    ),
                                    SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    getDivider(),
                                    SizedBox(
                                      height: sizedBoxHeight,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: Dimensions.pixels_30),
                                      color: settingLegalBackgroundColor,
                                      child: SettingsOptionWidget(
                                        leadingImage: terms_of_service,
                                        trailingImage: arrowRight,
                                        height: Dimensions.pixels_51,
                                        optionTitle: "Terms of Service",
                                        onClickOption: (value) {
                                          launchInBrowser(
                                              "https://kingofthecurve.carrd.co/");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
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

  Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    }
  }
}
