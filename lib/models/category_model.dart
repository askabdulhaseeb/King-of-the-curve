class CategoryModel {
  String categoryName;
  String categoryBackgroundColor;
  String categoryImage;
  String categoryTextColor;
  String screenName;
  List<String> modesId;

  CategoryModel(
      {this.categoryName,
      this.categoryBackgroundColor,
      this.categoryImage,
      this.categoryTextColor,
      this.screenName,
      this.modesId});

  CategoryModel.fromMap(Map<String, dynamic> data, String documentId)
      : categoryName = data['categoryName'],
        categoryBackgroundColor = data['categoryBackgroundColor'],
        categoryImage = data['categoryImage'],
        screenName = data['screenName'],
        categoryTextColor = data['categoryTextColor'];
// modesId = data['modesId'];
}
