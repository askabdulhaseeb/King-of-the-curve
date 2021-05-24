class StatsModel {
  String categoryName;
  String categoryId;
  int categoryPercentage;
  List<StatsSubCategory> statsSubCategory;

  StatsModel({this.categoryName, this.categoryId, this.statsSubCategory,this.categoryPercentage,});

  StatsModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
    categoryPercentage = json['categoryPercentage'];
    if (json['statsSubCategory'] != null) {
      statsSubCategory = <StatsSubCategory>[];
      json['statsSubCategory'].forEach((v) {
        statsSubCategory.add(new StatsSubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['categoryId'] = this.categoryId;
    data['categoryPercentage'] = this.categoryPercentage;
    if (this.statsSubCategory != null) {
      data['statsSubCategory'] =
          this.statsSubCategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatsSubCategory {
  String subCategoryId;
  int percentage;
  String categoryId;
  String userId;
  String categoryName;
  String subCategoryName;

  StatsSubCategory(
      {this.subCategoryId,
        this.percentage,
        this.categoryId,
        this.userId,
        this.categoryName,
        this.subCategoryName});

  StatsSubCategory.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subCategoryId'];
    percentage = json['percentage'];
    categoryId = json['categoryId'];
    userId = json['userId'];
    categoryName = json['categoryName'];
    subCategoryName = json['subCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subCategoryId'] = this.subCategoryId;
    data['percentage'] = this.percentage;
    data['categoryId'] = this.categoryId;
    data['userId'] = this.userId;
    data['categoryName'] = this.categoryName;
    data['subCategoryName'] = this.subCategoryName;
    return data;
  }
}