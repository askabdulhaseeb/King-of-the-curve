import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/homeModule/single_player_module/single_player_page.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/settingsModule/settingsPage.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/homeCardWidget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseClass {
  @override
  Widget build(BuildContext context) {
    var sharedPrefProvider = Provider.of<SharedPreferenceProvider>(context);
    var optionProvider = Provider.of<OptionProvider>(context, listen: false);
    optionProvider.setOptionListForAll(sharedPrefProvider.userDataModel.userId);
    print(sharedPrefProvider.userDataModel.userName);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Container(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZoomIn(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                  left: Dimensions.pixels_30, right: Dimensions.pixels_30),
              child: Image(
                image: AssetImage(appTextIconImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.pixels_10,
          ),
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.pixels_30, right: Dimensions.pixels_30),
            child: Text(
              "Hello",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.pixels_18),
            ),
          ),
          SizedBox(
            height: Dimensions.pixels_7,
          ),
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.pixels_30, right: Dimensions.pixels_30),
            child: Text(
              sharedPrefProvider.userDataModel.userName != null
                  ? sharedPrefProvider.userDataModel.userName != "null"
                      ? sharedPrefProvider.userDataModel.userName
                      : ""
                  : "" /* "User name"*/,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.pixels_24),
            ),
          ),
          SizedBox(
            height: Dimensions.pixels_30,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: getScreenBackgroundDecoration(),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 5,
                    child: Container(
                      height: Dimensions.pixels_128,
                      child: Image.asset(home_background_two),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.pixels_16,
                  ),
                  Positioned(
                    top: Dimensions.pixels_130,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: Dimensions.pixels_250,
                      child: Image.asset(home_background_three),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.pixels_280,
                    left: 0,
                    right: 0,
                    child: Container(
                        height: Dimensions.pixels_250,
                        child: Image.asset(
                          home_background_one,
                          fit: BoxFit.fill,
                        )),
                  ),
                  Positioned(
                    left: 5,
                    bottom: 0,
                    child: Image.asset(home_background_four),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 0,
                    child: Image.asset(home_background_five),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: Dimensions.pixels_40,
                      ),
                      HomeCardWidget(
                          cardBackgroundColor: singlePlayerBackgroundColor,
                          cardHeight: Dimensions.pixels_128,
                          leftMargin: Dimensions.pixels_30,
                          rightMargin: Dimensions.pixels_30,
                          cardTextFontSize: Dimensions.pixels_24,
                          cardTextColor: singlePlayerTextColor,
                          onCardClicked: (value) {
                            pushToNextScreenWithFadeAnimation(
                                context: context,
                                destination: SinglePlayerPage());
                          },
                          cardTitle: "Single Player",
                          cardTrailingImage: singlePlayerCardImage,
                          context: context),
                      SizedBox(
                        height: Dimensions.pixels_40,
                      ),
                      /*      HomeCardWidget(
                          cardBackgroundColor: multiPlayerBackgroundColor,
                          cardHeight: Dimensions.pixels_128,
                          leftMargin: Dimensions.pixels_30,
                          rightMargin: Dimensions.pixels_30,
                          cardTextColor: multiPlayerTextColor,
                          cardTextFontSize: Dimensions.pixels_24,
                          onCardClicked: (value) {},
                          cardTrailingImage: multiPlayerCardImage,
                          cardTitle: "MultiPlayer",
                          context: context),*/
                      SizedBox(
                        height: Dimensions.pixels_40,
                      ),
                      HomeCardWidget(
                          cardBackgroundColor: settingBackgroundColor,
                          cardHeight: Dimensions.pixels_128,
                          leftMargin: Dimensions.pixels_30,
                          rightMargin: Dimensions.pixels_30,
                          cardTextFontSize: Dimensions.pixels_24,
                          cardTextColor: settingTextColor,
                          onCardClicked: (value) {
                            pushToNextScreenWithFadeAnimation(
                                context: value,
                                destination: SettingsPage(),
                                duration: 100);
                          },
                          cardTrailingImage: settingCardImage,
                          cardTitle: "Settings",
                          context: context),
                      SizedBox(
                        height: Dimensions.pixels_40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
