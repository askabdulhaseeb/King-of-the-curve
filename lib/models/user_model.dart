class UserDataModel {
  String userId;
  String endlessModeHighScore;
  List<String> endlessModeRemovedCategories;
  List<String> endlessModeRemovedSubcategories;
  List<String> timedModeRemovedCategories;
  List<String> timedModeRemovedSubcategories;
  List<String> reviewModeRemovedCategories;
  List<String> reviewModeRemovedSubcategories;
  List<String> bookMarkedQuestions;
  List<String> flaggedQuestions;
  String timedModeHighScore;
  String reviewModeHighScore;
  bool isLoggedIn;
  String userEmail;
  bool isPremium;
  String instituteName;
  String instituteId;
  String instituteEmail;
  String userName;

  UserDataModel(
      {this.userId,
      this.endlessModeHighScore,
      this.endlessModeRemovedCategories,
      this.endlessModeRemovedSubcategories,
      this.timedModeRemovedCategories,
      this.timedModeRemovedSubcategories,
      this.timedModeHighScore,
      this.reviewModeRemovedCategories,
      this.reviewModeRemovedSubcategories,
      this.reviewModeHighScore,
      this.userEmail,
      this.bookMarkedQuestions,
      this.flaggedQuestions,
      this.userName,
      this.instituteEmail,
      this.isPremium,
      this.instituteId,
      this.instituteName,
      this.isLoggedIn = false});

  UserDataModel.fromJson(Map<String, dynamic> json, bool isLogin) {
    userId = json['user_id'].toString();
    endlessModeHighScore = json['endless_mode_highscore'].toString();
    endlessModeRemovedCategories =
        json['endless_mode_removed_categories'].cast<String>();
    endlessModeRemovedSubcategories =
        json['endless_mode_removed_subcategories'].cast<String>();
    timedModeRemovedCategories =
        json['timed_mode_removed_categories'].cast<String>();
    timedModeRemovedSubcategories =
        json['timed_mode_removed_subcategories'].cast<String>();
    reviewModeRemovedCategories = json['review_mode_removed_categories'] != null
        ? json['review_mode_removed_categories'].cast<String>()
        : [];
    reviewModeRemovedSubcategories =
        json['review_mode_removed_subcategories'] != null
            ? json['review_mode_removed_subcategories'].cast<String>()
            : [];
    bookMarkedQuestions = json['bookmarked_questions_id'] != null
        ? json['bookmarked_questions_id'].cast<String>()
        : [];
    flaggedQuestions = json['flagged_questions_id'] != null
        ? json['flagged_questions_id'].cast<String>()
        : [];
    timedModeHighScore = json['timed_mode_high_score'].toString();
    reviewModeHighScore = json['review_mode_high_score'].toString();
    userEmail = json['user_email'].toString();
    userName = json['user_name'].toString();
    isPremium = json['isPremium'];
    instituteId = json['institute_id'];
    instituteName = json['institute_name'];
    instituteEmail = json['institute_email'];
    isLoggedIn = isLogin;
  }

  Map<String, dynamic> toJson(UserDataModel userDataModel) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userDataModel.userId;
    data['endless_mode_highscore'] = userDataModel.endlessModeHighScore;
    data['endless_mode_removed_categories'] =
        userDataModel.endlessModeRemovedCategories;
    data['endless_mode_removed_subcategories'] =
        userDataModel.endlessModeRemovedSubcategories;
    data['timed_mode_removed_categories'] =
        userDataModel.timedModeRemovedCategories;
    data['timed_mode_removed_subcategories'] =
        userDataModel.timedModeRemovedSubcategories;

    data['review_mode_removed_categories'] =
        userDataModel.reviewModeRemovedCategories;

    data['review_mode_removed_subcategories'] =
        userDataModel.reviewModeRemovedSubcategories;
    data['bookmarked_questions_id'] = userDataModel.bookMarkedQuestions;
    data['flagged_questions_id'] = userDataModel.flaggedQuestions;
    data['timed_mode_high_score'] = userDataModel.timedModeHighScore;

    data['review_mode_high_score'] = userDataModel.reviewModeHighScore;
    data['isPremium'] = userDataModel.isPremium;

    data['isLoggedIn'] = userDataModel.isLoggedIn;
    data['user_email'] = userDataModel.userEmail;
    data['user_name'] = userDataModel.userName;
    data['institute_id'] = userDataModel.instituteId;
    data['institute_name'] = userDataModel.instituteName;
    data['institute_email'] = userDataModel.instituteEmail;
    return data;
  }
}
