import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/authentification/confirm_institute_email.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/settingsModule/editEmailPage.dart';
import 'package:kings_of_the_curve/settingsModule/editPasswordPage.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/edittext_with_hint.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class AccountDetailPage extends StatefulWidget {
  @override
  _AccountDetailPageState createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> with BaseClass {
  bool isLeaderBoard = false;
  bool isPasswordShow = true;
  TextEditingController _userNameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _instituteEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    var sharedPrefProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: false);
    _userNameEditingController.text = sharedPrefProvider.userDataModel.userName;
    _emailEditingController.text = sharedPrefProvider.userDataModel.userEmail;
    if(sharedPrefProvider.userDataModel.instituteName!=null){
      _instituteEditingController.text = sharedPrefProvider.userDataModel.instituteName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sharedPref = Provider.of<SharedPreferenceProvider>(context);
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
                                    top: Dimensions.pixels_33,
                                    left: Dimensions.pixels_30,
                                    right: Dimensions.pixels_30),
                                child: Text(
                                  "Account Details",
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.pixels_24),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: EditTextWithHint(
                                      hintText: "Username",
                                      isEnabled: false,
                                      context: context,
                                      leftMargin: Dimensions.pixels_30,
                                      topMargin: Dimensions.pixels_30,
                                      textEditingController:
                                          _userNameEditingController,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions.pixels_45),
                                  ),
                                  /*   GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: Dimensions.pixels_30,
                                      width: Dimensions.pixels_30,
                                      margin: EdgeInsets.only(
                                          right: Dimensions.pixels_15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.pixels_20),
                                          color: primaryColor),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: Dimensions.pixels_15,
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: EditTextWithHint(
                                      hintText: "Password",
                                      context: context,
                                      isObscure: isPasswordShow,
                                      leftMargin: Dimensions.pixels_30,
                                      isPassword: true,
                                      toggleObscure: (value) {
                                        setState(() {
                                          if (value) {
                                            isPasswordShow = false;
                                          } else {
                                            isPasswordShow = true;
                                          }
                                        });
                                      },
                                      topMargin: Dimensions.pixels_30,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: EditPasswordPage(),
                                          duration: 100);
                                    },
                                    child: Container(
                                      height: Dimensions.pixels_30,
                                      width: Dimensions.pixels_30,
                                      margin: EdgeInsets.only(
                                          right: Dimensions.pixels_15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.pixels_20),
                                          color: primaryColor),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: Dimensions.pixels_15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: EditTextWithHint(
                                      hintText: "Email",
                                      context: context,
                                      isEnabled: false,
                                      leftMargin: Dimensions.pixels_30,
                                      topMargin: Dimensions.pixels_30,
                                      textEditingController:
                                          _emailEditingController,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      /* pushToNextScreenWithFadeAnimation(
                                          context: context,
                                          destination: EditEmailPage(),
                                          duration: 100);*/
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: Dimensions.pixels_45),
                                    ) /*Container(
                                      height: Dimensions.pixels_30,
                                      width: Dimensions.pixels_30,
                                      margin: EdgeInsets.only(
                                          right: Dimensions.pixels_15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.pixels_20),
                                          color: primaryColor),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: Dimensions.pixels_15,
                                      ),
                                    )*/
                                    ,
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: EditTextWithHint(
                                      hintText: "Institution",
                                      context: context,
                                      leftMargin: Dimensions.pixels_30,
                                      textEditingController: _instituteEditingController,
                                      isEnabled: sharedPref.userDataModel
                                                      .instituteName ==
                                                  null ||
                                              sharedPref.userDataModel
                                                  .instituteName.isEmpty
                                          ? true
                                          : false,
                                      topMargin: Dimensions.pixels_30,
                                    ),
                                  ),
                                  sharedPref.userDataModel.instituteName ==
                                              null ||
                                          sharedPref.userDataModel.instituteName
                                              .isEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    ConfirmInstituteEmailPage(),
                                                transitionsBuilder: (context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child) =>
                                                    FadeTransition(
                                                        opacity: animation,
                                                        child: child),
                                                transitionDuration:
                                                    Duration(milliseconds: 100),
                                              ),
                                            ).then((value) {
                                              print( sharedPref
                                                  .userDataModel
                                                  .instituteName);
                                              print("YOYOYOYOYOYY");
                                              if (value != null) {


                                                setState(() {
                                                  sharedPref.userDataModel
                                                      .instituteName ==
                                                      null ||
                                                      sharedPref
                                                          .userDataModel
                                                          .instituteName
                                                          .isEmpty
                                                      ? _instituteEditingController
                                                      .text = ""
                                                      : _instituteEditingController
                                                      .text =
                                                      sharedPref.userDataModel
                                                          .instituteName;
                                                });

                                              }
                                            });
                                            /*pushToNextScreenWithFadeAnimation(
                                                context: context,
                                                destination:
                                                    ConfirmInstituteEmailPage(),
                                                duration: 100);*/
                                          },
                                          child: Container(
                                            height: Dimensions.pixels_30,
                                            width: Dimensions.pixels_30,
                                            margin: EdgeInsets.only(
                                                right: Dimensions.pixels_15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.pixels_20),
                                                color: primaryColor),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: Dimensions.pixels_15,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                           SizedBox(height: Dimensions.pixels_33,),
                           /*   Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.pixels_30,
                                    right: Dimensions.pixels_30,
                                    bottom: Dimensions.pixels_30,
                                    top: Dimensions.pixels_33),
                                child: CheckboxListTile(
                                  value: isLeaderBoard,
                                  contentPadding: EdgeInsets.zero,
                                  checkColor: backgroundColor,
                                  activeColor: hintEditTextColor,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      isLeaderBoard = value;
                                    });
                                  },
                                  title: Text(
                                    "Show My Institution on Leaderboards",
                                    style: TextStyle(
                                        color: hintEditTextColor,
                                        fontSize: Dimensions.pixels_14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),*/
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
