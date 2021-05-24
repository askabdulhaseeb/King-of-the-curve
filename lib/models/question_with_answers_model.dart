import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';

class QuestionWithAnswersModel {
  String id;
  String category;
  List<OptionList> options;
  List<NetworkImage> questionImages ;
  String explanation;
  String answer;
  String categoryId;
  String optionTwo;
  String trial;
  String optionFour;
  String subCategoryId;
  String optionThree;
 // String image;
  String subCategory;
  String question;
  String optionOne;
  Color backgroundColor;
  String selectedAnswer;
  String documentId;

  QuestionWithAnswersModel(
   {
      this.id,
      this.category,
      this.options,
      this.explanation,
      this.answer,
      this.categoryId,
      this.optionTwo,
      this.trial,
      this.optionFour,
      this.subCategoryId,
      this.optionThree,
  //    this.image,
      this.subCategory,
      this.question,
      this.backgroundColor,
      this.optionOne,
      this.selectedAnswer,
     this.questionImages,
      this.documentId});

  QuestionWithAnswersModel.fromJson(Map<String, dynamic> json, String docId) {
    id = json['id'];
    category = json['category'];
    documentId = docId;
    /*options = json['options'].cast<String>();*/
    options = <OptionList>[];
    try {
      json['options'].forEach((e) {
        options.add(new OptionList(e, dividerColor));
      });
    } catch (error) {
      print(error);
    }
    questionImages = <NetworkImage>[];
    try {
      print(json['question_images'].length);
      if(json['question_images'].length > 0) {
        json['question_images'].forEach((e) {
          print(json['question_images']);
          questionImages.add(NetworkImage(e['image_url']));
        });
      }
      else{
        questionImages = [];
      }
    } catch (error) {

      print(error);
    }

    explanation = json['explanation'];
    answer = json['answer'];
    categoryId = json['category_id'];
  //  optionTwo = json['optionTwo'];
    trial = json['trial'];
 //   optionFour = json['optionFour'];
    subCategoryId = json['sub_category_id'];
 //   optionThree = json['optionThree'];
   // image = json['image'];
    subCategory = json['subCategory'];
    question = json['question'];
  //  optionOne = json['optionOne'];
    backgroundColor = dividerColor;
    selectedAnswer = json['selectedAnswer'];
  }

  Map<String, dynamic> toJson(
      QuestionWithAnswersModel questionWithAnswersModel) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<String> list=[];
    data['id'] = questionWithAnswersModel.id;
    data['category'] = questionWithAnswersModel.category;
    for(int i=0 ;i<questionWithAnswersModel.options.length;i++)
    {
       list.add(questionWithAnswersModel.options.elementAt(i).optionText);
    }
    data['options'] = list;
    data['explanation'] = questionWithAnswersModel.explanation;
    data['answer'] = questionWithAnswersModel.answer;
    data['category_id'] = questionWithAnswersModel.categoryId;
    data['question_images'] = questionWithAnswersModel.questionImages;
    data['optionTwo'] = questionWithAnswersModel.optionTwo;
    data['trial'] = questionWithAnswersModel.trial;
    data['optionFour'] = questionWithAnswersModel.optionFour;
    data['sub_category_id'] = questionWithAnswersModel.subCategoryId;
    data['optionThree'] = questionWithAnswersModel.optionThree;
  //  data['image'] = questionWithAnswersModel.image;
    data['subCategory'] = questionWithAnswersModel.subCategory;
    data['question'] = questionWithAnswersModel.question;
    data['optionOne'] = questionWithAnswersModel.optionOne;
    data['selectedAnswer'] = questionWithAnswersModel.selectedAnswer;
    data['documentId'] = questionWithAnswersModel.documentId;
    return data;
  }
}

class OptionList {
  String optionText;
  Color optionBackgroundColor;

  OptionList(
    this.optionText,
    this.optionBackgroundColor,
  );
}