class FourQuestionModel {
  String category;
  String question;
/*  String optionOne;
  String optionTwo;
  String optionThree;
  String optionFour;*/
  String correctAnswerOption;
  String explanation;
  String trial;
  String subCategory;
  String image;
  String id;
  bool isAnswered;

  String selectedAnswerOption;

  FourQuestionModel({
    this.category,
    this.question,
/*    this.optionOne,
    this.optionTwo,
    this.optionThree,
    this.optionFour,*/
    this.correctAnswerOption,
    this.explanation,
    this.trial,
    this.subCategory,
    this.image,
    this.id,
    this.isAnswered,
    this.selectedAnswerOption,
  });

  Map<String, dynamic> toJson(FourQuestionModel fourQuestionModel) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = fourQuestionModel.category;
    data['question'] = fourQuestionModel.question;
/*    data['optionOne'] = fourQuestionModel.optionOne;
    data['optionTwo'] = fourQuestionModel.optionTwo;
    data['optionThree'] = fourQuestionModel.optionThree;
    data['optionFour'] = fourQuestionModel.optionFour;*/
    data['correctAnswerOption'] = fourQuestionModel.correctAnswerOption;
    data['explanation'] = fourQuestionModel.explanation;
    data['trial'] = fourQuestionModel.trial;
    data['subCategory'] = fourQuestionModel.subCategory;
    data['image'] = fourQuestionModel.image;
    data['id'] = fourQuestionModel.id;
    data['isAnswered'] = fourQuestionModel.isAnswered;
    data['selectedAnswerOption'] = fourQuestionModel.selectedAnswerOption;
    return data;
  }

  FourQuestionModel.fromJson(Map<String, dynamic> data) {
    category = data['category'];
    question = data['question'];/*
    optionOne = data['optionOne'];
    optionTwo = data['optionTwo'];
    optionThree = data['optionThree'];
    optionFour = data['optionFour'];*/
    correctAnswerOption = data['correctAnswerOption'];
    explanation = data['explanation'];
    trial = data['trial'];
    subCategory = data['subCategory'];
    image = data['image'];
    id = data['id'];
    isAnswered = data['isAnswered'];
    selectedAnswerOption = data['selectedAnswerOption'];
  }
}