import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/authentification/forgotPasswordPage.dart';
import 'package:kings_of_the_curve/authentification/registerPage.dart';
import 'package:kings_of_the_curve/blocs/auth_bloc.dart';
import 'package:kings_of_the_curve/homeModule/homePage.dart';
import 'package:kings_of_the_curve/providers/options_provider.dart';
import 'package:kings_of_the_curve/providers/validations.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/edittext_with_hint.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with BaseClass {
  bool isPasswordShow = true;
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _usernameFocusNode = new FocusNode();
  FocusNode _emailFocusNode = new FocusNode();
  StreamSubscription<User> loginStateSubscription;
  final auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final validationProvider = Provider.of<Validations>(context);
    final fireStoreProvider = Provider.of<OptionProvider>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('password');
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('email');
      }
    });
    /*_usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('username');
      }
    });*/
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.pixels_30,
                  right: Dimensions.pixels_30,
                  top: Dimensions.pixels_40),
              child: Text(
                "Welcome\nback",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_33,
                    fontWeight: FontWeight.w800),
              ),
            ),
            EditTextWithHint(
              hintText: "Email",
              context: context,
              leftMargin: Dimensions.pixels_30,
              focusNode: /*_usernameFocusNode*/ _emailFocusNode,
              textEditingController: _emailController,
              isObscure: false,
              rightMargin: Dimensions.pixels_30,
              topMargin: Dimensions.pixels_30,
              /*errorText: validationProvider.userName.isValidating
                  ? validationProvider.userName.error
                  : null,*/
              errorText: validationProvider.email.isValidating
                  ? validationProvider.email.error
                  : null,
              onChanged: (String value) =>
                  validationProvider. /*changeUserName*/ changeEmail(value),
            ),
            EditTextWithHint(
              hintText: "Password",
              context: context,
              focusNode: _passwordFocusNode,
              leftMargin: Dimensions.pixels_30,
              textEditingController: _passwordController,
              isObscure: isPasswordShow,
              onChanged: (String value) =>
                  validationProvider.changePassword(value),
              errorText: validationProvider.password.isValidating
                  ? validationProvider.password.error
                  : null,
              toggleObscure: (value) {
                setState(() {
                  if (value) {
                    isPasswordShow = false;
                  } else {
                    isPasswordShow = true;
                  }
                });
              },
              isPassword: true,
              rightMargin: Dimensions.pixels_30,
              topMargin: Dimensions.pixels_30,
            ),
            SizedBox(
              height: Dimensions.pixels_40,
            ),
            RoundedEdgeButton(
                color: primaryColor,
                text: "Login now",
                leftMargin: Dimensions.pixels_30,
                height: Dimensions.pixels_60,
                textFontSize: Dimensions.pixels_18,
                buttonRadius: Dimensions.pixels_15,
                rightMargin: Dimensions.pixels_30,
                bottomMargin: Dimensions.pixels_30,
                textColor: Colors.white,
                onPressed: (value) async {
                  if (validationProvider.isSignInValid) {
                    showCircularDialog(context);
                    try {
                      UserCredential userCred =
                          await auth.signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      fireStoreProvider.addUserLogin(
                          displayName: userCred.user.displayName,
                          email: _emailController.text.trim(),
                          user_id: userCred.user.uid,
                          context: context);
                      popToPreviousScreen(context: context);
                      navigateToHomeScreen(context);
                    } catch (error) {
                      print(error);

                      popToPreviousScreen(context: context);
                      if (error.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                        showError(context, "Email or Password is not correct");
                      } else if (error.toString() ==
                          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                        showError(context,
                            "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.");
                      } else {
                        showError(context, error.toString());
                      }
                    }
                    /*  pushToNextScreenWithFadeAnimation(
                        context: context,
                        destination: HomePage(),
                        duration: 100); //500*/
                  } else {
                    //validationProvider.changeValidationStatus('username');
                    validationProvider.changeValidationStatus('email');
                    validationProvider.changeValidationStatus('password');
                  }
                },
                context: context),
            SizedBox(
              height: Dimensions.pixels_30,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.pixels_30, right: Dimensions.pixels_30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      validationProvider.resetValidation();
                      pushToNextScreenWithFadeAnimation(
                          context: context, destination: ForgotPasswordPage());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.pixels_8,
                          bottom: Dimensions.pixels_8),
                      child: Text(
                        "Forgot password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.pixels_14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      validationProvider.resetValidation();
                      removeFocusFromEditText(context: context);
                      pushToNextScreenWithFadeAnimation(
                          context: context,
                          destination: RegisterPage(),
                          duration: 100);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.pixels_8,
                          bottom: Dimensions.pixels_8),
                      child: Text(
                        "Create account",
                        style: TextStyle(
                          color: multiPlayerTextColor,
                          fontSize: Dimensions.pixels_14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.pixels_30,
                  right: Dimensions.pixels_30,
                  top: Dimensions.pixels_40),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 0.5,
                      color: dividerColor,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.pixels_5,
                  ),
                  Text(
                    "Or Sign With",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.pixels_14,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.pixels_5,
                  ),
                  Expanded(
                    child: Divider(
                      height: 0.5,
                      color: dividerColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.pixels_30,
                  right: Dimensions.pixels_30,
                  top: Dimensions.pixels_30,
                  bottom: Dimensions.pixels_40),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        authBloc.loginGoogle(context);
                        loginStateSubscription =
                            authBloc.currentUser.listen((googleUser) {
                          if (googleUser != null) {
                            fireStoreProvider.addUserLogin(
                              displayName: googleUser.displayName,
                              email: googleUser.email,
                              user_id: googleUser.uid,
                              context: context,
                            );
                            /*FireStoreService().addUser(
                                userEmail: googleUser.email,
                                userId: googleUser.uid);*/
                            navigateToHomeScreen(context);
                          }
                        });
                      },
                      child: Container(
                        height: Dimensions.pixels_51,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.pixels_5),
                            color: Colors.white,
                            border: Border.all(color: hintEditTextColor)),
                        child: Center(
                          child: SizedBox(
                            height: Dimensions.pixels_20,
                            child: Image(
                              image: AssetImage(googleImage),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.pixels_5,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          authBloc.loginFacebook(context);
                          loginStateSubscription =
                              authBloc.currentUser.listen((fbUser) {
                            if (fbUser != null) {
                              fireStoreProvider.addUserLogin(
                                displayName: fbUser.displayName,
                                email: fbUser.email,
                                user_id: fbUser.uid,
                                context: context,
                              );
                              /*FireStoreService().addUser(
                              userEmail: fbUser.email,
                              userId: fbUser.uid,
                            );*/
                              navigateToHomeScreen(context);
                            }
                          });
                        } catch (error) {
                          print("It is an error");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.pixels_5),
                          color: fbButtonColor,
                        ),
                        height: Dimensions.pixels_51,
                        child: Center(
                          child: SizedBox(
                            height: Dimensions.pixels_20,
                            child: Image(
                              image: AssetImage(
                                fbImage,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Platform.isIOS
                      ? SizedBox(
                          width: Dimensions.pixels_5,
                        )
                      : Container(),
                  Platform.isIOS
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                showCircularDialog(context);
                                final result =
                                    await authBloc.signInApple(context);
                                if (result != null) {
                                  print(result.displayName);
                                  fireStoreProvider.addUserLogin(
                                    displayName: result.displayName,
                                    email:
                                        result.providerData.elementAt(0).email,
                                    user_id: result.uid,
                                    context: context,
                                  );
                                  popToPreviousScreen(context: context);
                                  navigateToHomeScreen(context);
                                }
                              } catch (error) {
                                popToPreviousScreen(context: context);
                                showError(context, error.toString());
                              }
/*                              authBloc.currentUser.listen((appleUser) {

                                print("APLEE USER");
                                if (appleUser != null) {
                                  print(appleUser.email);
                                  print(appleUser.displayName);
                                  print(appleUser.providerData.elementAt(0).email);

                                  fireStoreProvider.addUserLogin(
                                    displayName: appleUser.displayName,
                                    email: appleUser.providerData.elementAt(0).email,
                                    user_id: appleUser.uid,
                                    context: context,
                                  );

                                  navigateToHomeScreen(context);
                                }
                              });*/
                            },
                            child: Container(
                              height: Dimensions.pixels_51,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.pixels_5),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: Dimensions.pixels_20,
                                  child: Image(
                                    image: AssetImage(appleImage),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateToHomeScreen(BuildContext context) {
    pushReplaceAndClearStack(
      context: context,
      destination: HomePage(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (loginStateSubscription != null) loginStateSubscription.cancel();
    super.dispose();
  }
}
