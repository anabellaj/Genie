

class Forum{
  late String id;
  late String title;
  late String description;
  late String creator;
  late String creator_id;
  late DateTime date;
  late List<dynamic> answers;

  Forum(String titleParam, String descriptionParam, String creatorParam, String creator_idParam, DateTime dateParam){
    title=titleParam;
    description= descriptionParam;
    creator = creatorParam;
    date = dateParam;
    creator_id = creator_idParam;

  }
  void initialize(){
    answers = [];
  }

  Map<String,dynamic> toJson() =>{
    'id':id,
    'title':title,
    'description':description,
    'creator':creator,
    'creator_id': creator_id,
    'date':date,
    'answers':answers
  };

  Forum.fromJson(Map<String,dynamic> json):
    id= json['_id'].oid.toString(),
    title = json['title'],
    description = json['description'],
    creator = json['creator'],
    creator_id = json["creator_id"] is String?  json['creator_id']:json['creator_id'].oid.toString(),
    date = json['date'],
    answers = json['answers'];



  


}