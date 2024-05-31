import 'package:mongo_dart/mongo_dart.dart';


class Forum{
  late ObjectId id;
  late String title;
  late String description;
  late String creator;
  late DateTime date;
  late List<dynamic> answers;

  Forum(String titleParam, String descriptionParam, String creatorParam, DateTime dateParam){
    title=titleParam;
    description= descriptionParam;
    creator = creatorParam;
    date = dateParam;

  }
  void initialize(){
    answers = [];
  }

  Map<String,dynamic> toJson() =>{
    'id':id,
    'title':title,
    'description':description,
    'creator':creator,
    'date':date,
    'answers':answers
  };

  Forum.fromJson(Map<String,dynamic> json):
    id= json['_id'],
    title = json['title'],
    description = json['description'],
    creator = json['creator'],
    date = json['date'],
    answers = json['answers'];



  


}