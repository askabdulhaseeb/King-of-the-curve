import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/authentification/confirm_institute_email.dart';
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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with BaseClass {
  bool isPasswordShow = true;
  bool isConfirmPasswordShow = true;
  FocusNode _emailFocusNode = new FocusNode();

  FocusNode _passwordFocusNode = new FocusNode();

  FocusNode _confirmPasswordFocusNode = new FocusNode();

  FocusNode _usernameFocusNode = new FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  StreamSubscription<User> loginStateSubscription;
  final auth = FirebaseAuth.instance;
  String instituteName = "";
  String instituteEmail = "";
  String instituteId = "";
  bool isRemoveFocus = true;

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

    if (isRemoveFocus) {
      removeFocusFromEditText(context: context);

      isRemoveFocus = false;
    }
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('email');
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('password');
      }
    });
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('username');
      }
    });
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        validationProvider.changeValidationStatus('confirmPassword');
      }
    });

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
                "Create Your\nAccount",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_33,
                    fontWeight: FontWeight.w800),
              ),
            ),
            EditTextWithHint(
              hintText: "Email",
              context: context,
              key: Key('email'),
              leftMargin: Dimensions.pixels_30,
              isObscure: false,
              rightMargin: Dimensions.pixels_30,
              focusNode: _emailFocusNode,
              topMargin: Dimensions.pixels_30,
              textEditingController: _emailController,
              errorText: validationProvider.email.isValidating
                  ? validationProvider.email.error
                  : null,
              onChanged: (String value) =>
                  validationProvider.changeEmail(value),
            ),
            EditTextWithHint(
              hintText: "User name",
              key: Key('user-name'),
              context: context,
              leftMargin: Dimensions.pixels_30,
              textEditingController: _userNameController,
              isObscure: false,
              rightMargin: Dimensions.pixels_30,
              topMargin: Dimensions.pixels_20,
              focusNode: _usernameFocusNode,
              errorText: validationProvider.userName.isValidating
                  ? validationProvider.userName.error
                  : null,
              onChanged: (String value) =>
                  validationProvider.changeUserName(value),
            ),
            EditTextWithHint(
              hintText: "Password",
              context: context,
              key: Key('password'),
              leftMargin: Dimensions.pixels_30,
              isObscure: isPasswordShow,
              focusNode: _passwordFocusNode,
              textEditingController: _passwordController,
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
              topMargin: Dimensions.pixels_20,
              errorText: validationProvider.password.isValidating
                  ? validationProvider.password.error
                  : null,
              onChanged: (String value) =>
                  validationProvider.changePassword(value),
            ),
            EditTextWithHint(
              hintText: "Confirm Password",
              context: context,
              key: Key('confirmPassword'),
              textEditingController: _confirmPasswordController,
              leftMargin: Dimensions.pixels_30,
              isObscure: isConfirmPasswordShow,
              focusNode: _confirmPasswordFocusNode,
              toggleObscure: (value) {
                setState(() {
                  if (value) {
                    isConfirmPasswordShow = false;
                  } else {
                    isConfirmPasswordShow = true;
                  }
                });
              },
              isPassword: true,
              rightMargin: Dimensions.pixels_30,
              topMargin: Dimensions.pixels_20,
              errorText: validationProvider.confirmPassword.isValidating
                  ? validationProvider.confirmPassword.error
                  : null,
              onChanged: (String value) =>
                  validationProvider.changeConfirmPassword(value),
            ),
            SizedBox(
              height: Dimensions.pixels_30,
            ),
            RoundedEdgeButton(
                color: primaryColor,
                text: "Sign Up",
                leftMargin: Dimensions.pixels_30,
                rightMargin: Dimensions.pixels_30,
                height: Dimensions.pixels_60,
                textFontSize: Dimensions.pixels_18,
                buttonRadius: Dimensions.pixels_14,
                bottomMargin: Dimensions.pixels_30,
                textColor: Colors.white,
                onPressed: (value) async {
                  if (validationProvider.isSignUpValid) {
                    try {
                      showCircularDialog(context);

                      UserCredential response =
                          await auth.createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());
                      validationProvider.resetValidation();
                      fireStoreProvider.addAuthUserLogin(
                          displayName: _userNameController.text.trim(),
                          email: _emailController.text.trim(),
                          user_id: response.user.uid,
                          context: context,
                          mInstituteEmail: instituteEmail,
                          mInstituteName: instituteName,
                          mInstituteId: instituteId);
                      popToPreviousScreen(context: context);
                      pushReplaceAndClearStack(
                          context: context, destination: HomePage());
                    } catch (error) {
                      popToPreviousScreen(context: context);
                      if (error.toString() ==
                          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                        showError(context,
                            "The email address is already in use by another account.");
                      }
                    }
                  } else {
                    validationProvider.changeValidationStatus('username');
                    validationProvider.changeValidationStatus('email');
                    validationProvider.changeValidationStatus('password');
                    validationProvider
                        .changeValidationStatus('confirmPassword');
                  }
                },
                context: context),
            SizedBox(
              height: Dimensions.pixels_20,
            ),
            GestureDetector(
              onTap: () {
                validationProvider.resetValidation();
                popToPreviousScreen(context: context);
              },
              child: Center(
                child: Text(
                  "Already have an account?\nSign in!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: hintTextColor, fontSize: Dimensions.pixels_16),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.pixels_11,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  //validationProvider.resetValidation();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ConfirmInstituteEmailPage(
                        isRegister: true,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                      transitionDuration: Duration(milliseconds: 100),
                    ),
                  ).then((value) {
                    try {
                      Map<String, String> params = value as Map<String, String>;
                      instituteName = params['institute'];
                      instituteEmail = params['email'];
                      instituteId = params['id'];
                    } catch (error) {
                      instituteName = "";
                      instituteEmail = "";
                      instituteId = "";
                      print(error);
                    }
                  });
                  /* pushToNextScreenWithFadeAnimation(
                    context: context,
                    destination: ConfirmInstituteEmailPage(
                      isRegister: true,
                    ),
                  );*/
                },
                child: FittedBox(
                  child: Text(
                    "Want to link your institution?\nConfirm your institution email here! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: hintTextColor, fontSize: Dimensions.pixels_16),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimensions.pixels_30,
                  right: Dimensions.pixels_30,
                  top: Dimensions.pixels_30),
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
                    "Or Sign Up With",
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
                      onTap: () {
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
                              image: AssetImage(fbImage),
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
                            onTap: () {
                              authBloc.signInApple(context);
                              authBloc.currentUser.listen((appleUser) {
                                if (appleUser != null) {
                                  fireStoreProvider.addUserLogin(
                                    displayName: appleUser.displayName,
                                    email: appleUser.email,
                                    user_id: appleUser.uid,
                                    context: context,
                                  );
                                  /*FireStoreService().addUser(
                              userEmail: fbUser.email,
                              userId: fbUser.uid,
                            );*/
                                  navigateToHomeScreen(context);
                                }
                              });
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
