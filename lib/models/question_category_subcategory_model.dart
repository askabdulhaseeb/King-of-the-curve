import 'package:cloud_firestore/cloud_firestore.dart';

class EndlessQuestionCategorySubcategoryModel {
  String category;
  bool isCategorySelected;
  String categoryId;
  List<SubCategoryList> subCategoryList;

  EndlessQuestionCategorySubcategoryModel(
      {this.category,
      this.isCategorySelected,
      this.categoryId,
      this.subCategoryList});

  EndlessQuestionCategorySubcategoryModel.fromMap(Map<String, dynamic> json,
      String id, bool catSelected, List userUnSelectedSubCategories) {
    category = json['category'];
    isCategorySelected = catSelected;

    categoryId = id;
    if (json['sub_category'] != null) {
      subCategoryList = <SubCategoryList>[];
      json['sub_category'].forEach((v) async {
        DocumentReference documentReference = v;
        DocumentSnapshot documentSnapshot =
            await documentReference.parent.doc(documentReference.id).get();

        if (!isCategorySelected) {
          subCategoryList.add(SubCategoryList.fromJson(
              documentReference,
              false,
              userUnSelectedSubCategories,
              documentSnapshot.data()['sub_category']));
        } else {
          if (userUnSelectedSubCategories.contains(documentReference.id)) {
            subCategoryList.add(new SubCategoryList.fromJson(
                documentReference,
                false,
                userUnSelectedSubCategories,
                documentSnapshot.data()['sub_category']));
          } else {
            subCategoryList.add(new SubCategoryList.fromJson(
                documentReference,
                true,
                userUnSelectedSubCategories,
                documentSnapshot.data()['sub_category']));
          }
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['isCategorySelected'] = this.isCategorySelected;
    data['categoryId'] = this.categoryId;
    if (this.subCategoryList != null) {
      data['sub_category'] =
          this.subCategoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryList {
  String subCatId;
  bool isSubCategorySelected;
  String subCategoryName;

  SubCategoryList(
      {this.subCatId, this.isSubCategorySelected, this.subCategoryName});

  SubCategoryList.fromJson(
    DocumentReference docRef,
    bool categorySelected,
    List userUnSelectedSubCategories,
    String subCatName,
  ) {
    subCategoryName = subCatName;

    subCatId = docRef.id;
    isSubCategorySelected = categorySelected;

    /*subCatName = json['subCatName'];
    subCatId = json['subCatId'];
    isSubCategorySelected = json['isSubCategorySelected'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subCatName'] = this.subCategoryName;
    data['subCatId'] = this.subCatId;
    data['isSubCategorySelected'] = this.isSubCategorySelected;
    return data;
  }
}
