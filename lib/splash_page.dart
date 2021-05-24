import 'dart:async';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kings_of_the_curve/authentification/loginPage.dart';
import 'package:kings_of_the_curve/blocs/auth_bloc.dart';
import 'package:kings_of_the_curve/models/user_model.dart';
import 'package:kings_of_the_curve/providers/four_questions_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeModule/homePage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with BaseClass {
  List<List<dynamic>> data = [];
  bool isCalledFunc = true;

  StreamSubscription<User> splashStateSubscription;

  loadAsset(FourQuestionsProvider fourQuestionProvider) async {
    final myData =
        await rootBundle.loadString("assets/app_csv_files/FourAnswers.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    data = csvTable;
    fourQuestionProvider.setFourQuestions(csvTable);
    fourQuestionProvider.setCurrentQuestion(context);
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    /*var sharedPrefProvider =
        Provider.of<SharedPreferenceProvider>(context, listen: true);*/
    splashStateSubscription = authBloc.currentUser.listen((user) {
      if (user != null) {
        pushReplaceAndClearStack(
          context: context,
          destination: HomePage(),
        );
      } else {
        pushReplaceAndClearStack(
          context: context,
          destination: LoginPage(),
        );
      }
    });
  }

  getQuestionsFromFireStore() {}

  @override
  void initState() {
    /*var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();*/
    // var questionProvider =
    /*Provider.of<QuestionProvider>(context, listen: false);
    questionProvider.getAllQuestions();*/
    super.initState();
  }

  @override
  void dispose() {
    if (splashStateSubscription != null) splashStateSubscription.cancel();
    /*var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.subscription.cancel();*/
    super.dispose();
  }

  checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefData = prefs.getString(USER_DATA_KEY);
    if (prefData != null) {
      var response = json.decode(prefData);
      var result = UserDataModel.fromJson(
          json.decode(prefs.getString(USER_DATA_KEY)), response['isLoggedIn']);
      print(result.isLoggedIn);
      if (result.isLoggedIn == null || result.isLoggedIn == false) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          pushReplaceAndClearStack(
            context: context,
            destination: LoginPage(),
          );
        });
        /*pushReplaceAndClearStack(
          context: context,
          destination: LoginPage(),
        );*/
      } else {
        Future.delayed(const Duration(milliseconds: 1500), () {
          pushReplaceAndClearStack(
            context: context,
            destination: HomePage(),
          );
        });

        /*  pushReplaceAndClearStack(
          context: context,
          destination: HomePage(),
        );*/
      }
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        pushReplaceAndClearStack(
          context: context,
          destination: LoginPage(),
        );
      });

      /*
      pushReplaceAndClearStack(
        context: context,
        destination: LoginPage(),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    var fourQuestionProvider =
        Provider.of<FourQuestionsProvider>(context, listen: false);
    if (isCalledFunc) {
      /*loadAsset(fourQuestionProvider);*/
      checkLogin();
      //loadAsset(fourQuestionProvider);
      isCalledFunc = false;
    }
    return Scaffold(
      backgroundColor: headingColor,
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              left: Dimensions.pixels_30, right: Dimensions.pixels_30),
          child: Image(
            image: AssetImage(app_icon),
            height: Dimensions.pixels_200,
            width: Dimensions.pixels_200,
            //fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
