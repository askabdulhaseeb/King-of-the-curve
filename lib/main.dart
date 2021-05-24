import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'blocs/auth_bloc.dart';
import 'providers/four_questions_provider.dart';
import 'providers/in_app_provider.dart';
import 'providers/intitute_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/option_value_change_provider.dart';
import 'providers/options_provider.dart';
import 'providers/question_provider.dart';
import 'providers/remianing_life_count_provider.dart';
import 'providers/review_question_provider.dart';
import 'providers/shared_preference_provider.dart';
import 'providers/validations.dart';
import 'splash_page.dart';
import 'utils/baseClass.dart';
import 'utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  InAppPurchaseConnection.enablePendingPurchases();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget with BaseClass {
  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => OptionValueChangeProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Validations(),
                ),
                ChangeNotifierProvider(
                  create: (context) => FourQuestionsProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => RemainingLifeCountProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => SharedPreferenceProvider(),
                ),
                Provider(
                  create: (context) => AuthBloc(),
                ),
                ChangeNotifierProvider(
                  create: (context) => OptionProvider(context),
                ),
                ChangeNotifierProvider(
                  create: (context) => QuestionProvider(context),
                ),
                ChangeNotifierProvider(
                  create: (context) => ReviewQuestionProvider(context),
                ),
                ChangeNotifierProvider(
                  create: (context) => LeaderBoardProvider(context),
                ),
                ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                ),
                ChangeNotifierProvider(
                  create: (context) => InstituteProvider(context),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'King of the curve',
                theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.blue,
                  unselectedWidgetColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    brightness: Brightness.light,
                    elevation: 0,
                  ),
                ),
                home: SplashPage(),
              ),
            );
          },
        );
      },
    );
  }
}
