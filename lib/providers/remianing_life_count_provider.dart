import 'package:flutter/foundation.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class RemainingLifeCountProvider with ChangeNotifier, BaseClass {
  int _remainingLife;

  RemainingLifeCountProvider() {
    _remainingLife = 5;
  }

  int get getRemainingLivesCount => _remainingLife;

  void subtractLife(int lifeTobeSubtracted) {
    if (_remainingLife > 0) {
      _remainingLife -= lifeTobeSubtracted;
      notifyListeners();
    }
  }

  void resetLife() {
    _remainingLife = 5;
    /*notifyListeners();*/
  }
}
