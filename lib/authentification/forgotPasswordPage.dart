import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/edittext_with_hint.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with BaseClass {
  final auth = FirebaseAuth.instance;
  TextEditingController _forgotPasswordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(builder: (context, constraint) {
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
                        top: Dimensions.pixels_15, left: appLeftMargin),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.pixels_33,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.pixels_33,
                  ),
                  Expanded(
                    child: Container(
                      decoration: getScreenBackgroundDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                         /* EditTextWithHint(
                            hintText: "Enter your username",
                            context: context,
                            leftMargin: Dimensions.pixels_30,
                            isObscure: false,
                            rightMargin: Dimensions.pixels_30,
                            topMargin: Dimensions.pixels_30,
                            textEditingController: _userNameController,
                          ),*/
                          EditTextWithHint(
                            hintText: "Email",
                            context: context,
                            leftMargin: Dimensions.pixels_30,
                            isObscure: false,
                            rightMargin: Dimensions.pixels_30,
                            topMargin: Dimensions.pixels_30,
                            textEditingController: _forgotPasswordController,
                          ),
                          RoundedEdgeButton(
                              color: primaryColor,
                              text: "Recover My Password",
                              leftMargin: Dimensions.pixels_30,
                              height: Dimensions.pixels_60,
                              rightMargin: Dimensions.pixels_30,
                              topMargin: Dimensions.pixels_30,
                              textColor: Colors.white,
                              textFontSize: Dimensions.pixels_18,
                              buttonRadius: Dimensions.pixels_14,
                              onPressed: (value) async {
                                /*if (_userNameController.text.trim().isEmpty) {
                                  showError(
                                      context, "Username cannot be empty");
                                } else*/ if (_forgotPasswordController.text
                                    .trim()
                                    .isEmpty) {
                                  showError(context, "Email cannot be empty");
                                } else if(!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(_forgotPasswordController.text.trim())){
                                  showError(context, "Email format is invalid");
                                }
                                else {
                                  try {
                                    showCircularDialog(context);
                                    await auth.sendPasswordResetEmail(
                                        email: _forgotPasswordController.text);
                                    popToPreviousScreen(context: context);
                                    showSuccess(
                                        context, "Please check your email");
                                    popToPreviousScreen(context: context);
                                  }
                                  catch(error){
                                    popToPreviousScreen(context: context);
                                    showError(context, error.message);
                                    print(error.message);
                                  }
                                  
                                }
                              },
                              context: context),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: Dimensions.pixels_30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(image: AssetImage(forgotPassOne)),
                                    Image(image: AssetImage(forgotPassTwo)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
