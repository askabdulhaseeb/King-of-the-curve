import 'package:flutter/foundation.dart';
import 'package:kings_of_the_curve/models/question_category_subcategory_model.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class OptionValueChangeProvider with ChangeNotifier, BaseClass {
  bool isValueSelected;
  List<EndlessQuestionCategorySubcategoryModel> _endlessOption;

  OptionValueChangeProvider() {
    isValueSelected = false;
    _endlessOption = [];
  }

  void setEndlessOptions(
      List<EndlessQuestionCategorySubcategoryModel> options) {
    _endlessOption = options;
    notifyListeners();
    print(_endlessOption.length);
  }


  List<EndlessQuestionCategorySubcategoryModel> get endlessOptionsList => _endlessOption;

  bool get optionValue => isValueSelected;

  void setValue(bool optionValue) {
    isValueSelected = optionValue;
    notifyListeners();
    print(isValueSelected);
  }
}
