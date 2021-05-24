
class OptionsModel {
  String categoryName;

  String categoryDocumentId;

  bool isCategorySelected;
 bool isSubCategoriesVisible ;
  List<SubCatList> subCategoryList;

  OptionsModel.fromMap(Map<String, dynamic> categoryMap, String categoryDocId,
      bool catSelected, List userUnSelectedSubCategories) {
   // categoryName = categoryMap['endless_mode_category_name'];
    categoryName = categoryMap['option_category_name'];
    categoryDocumentId = categoryDocId;
    isCategorySelected = catSelected;
    isSubCategoriesVisible = false ;
    subCategoryList = <SubCatList>[];
    try {
      /*categoryMap['endless_mode_subcategories']*/categoryMap['sub_categories'].forEach((e) {
        if (!isCategorySelected) {
          subCategoryList.add(new SubCatList.fromJson(e, false));
        } else {
          if (userUnSelectedSubCategories.contains(e['subcategory_id']/*e['endless_mode_subcategory_id']*/)) {
            subCategoryList.add(new SubCatList.fromJson(e, false));
          } else {
            subCategoryList.add(new SubCatList.fromJson(e, true));
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }
}

class SubCatList {
  String subCatId;
  String subCategoryName;
  bool isSubCatSelected;

  SubCatList({this.subCatId, this.subCategoryName, this.isSubCatSelected});

  SubCatList.fromJson(
    Map<String, dynamic> docRef,
    bool isSubCategorySelected,
  ) {
    subCategoryName = docRef['subcategory_name'];
    isSubCatSelected = isSubCategorySelected;
    subCatId = docRef['subcategory_id']/*docRef['endless_mode_subcategory_id']*/;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['endless_mode_subcategory_name'] = this.subCategoryName;
    data['subcategory_name'] = this.subCategoryName;
    data['subcategory_id'] = this.subCatId;
   // data['endless_mode_subcategory_id'] = this.subCatId;
    return data;
  }
}
