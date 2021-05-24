import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/services/firestore_service.dart';

class QuestionsProvider with ChangeNotifier{

  FireStoreService _fireStoreService;

  /*= FireStoreService();*/

  QuestionsProvider(BuildContext context) {
    _fireStoreService = FireStoreService(context);
  }
}