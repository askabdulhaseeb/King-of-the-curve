

class TimedOptionsModel {
  String categoryName;
  String categoryDocumentId;
  bool isCategorySelected;
  bool isSubCategoriesVisible ;
  List<TImedSubCatList> subCategoryList;

  TimedOptionsModel.fromMap(Map<String, dynamic> categoryMap, String categoryDocId,
      bool catSelected, List userUnSelectedSubCategories) {
    //categoryName = categoryMap['endless_mode_category_name'];
    categoryName = categoryMap['option_category_name'];
    categoryDocumentId = categoryDocId;
    isCategorySelected = catSelected;
    isSubCategoriesVisible =false ;
    subCategoryList = <TImedSubCatList>[];
    try {
   //   categoryMap['endless_mode_subcategories'].forEach((e) {
      /*categoryMap['endless_mode_subcategories']*/categoryMap['sub_categories'].forEach((e) {
        if (!isCategorySelected) {
          subCategoryList.add(new TImedSubCatList.fromJson(e, false));
        } else {
         // if (userUnSelectedSubCategories.contains(e['endless_mode_subcategory_id'])) {
          if (userUnSelectedSubCategories.contains(e['subcategory_id']/*e['endless_mode_subcategory_id']*/)) {
            subCategoryList.add(new TImedSubCatList.fromJson(e, false));
          } else {
            subCategoryList.add(new TImedSubCatList.fromJson(e, true));
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }
}

class TImedSubCatList {
  String subCatId;
  String subCategoryName;
  bool isSubCatSelected;

  TImedSubCatList({this.subCatId, this.subCategoryName, this.isSubCatSelected});

  TImedSubCatList.fromJson(
      Map<String, dynamic> docRef,
      bool isSubCategorySelected,
      ) {
    // subCategoryName = docRef['endless_mode_subcategory_name'];
    subCategoryName = docRef['subcategory_name'];
    isSubCatSelected = isSubCategorySelected;
    //  subCatId = docRef['endless_mode_subcategory_id'];
    subCatId = docRef['subcategory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*data['endless_mode_subcategory_name'] = this.subCategoryName;
    data['endless_mode_subcategory_id'] = this.subCatId;*/
    data['subcategory_name'] = this.subCategoryName;
    data['subcategory_id'] = this.subCatId;
    return data;
  }
}