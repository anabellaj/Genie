import "package:mongo_dart/mongo_dart.dart";

class Groups{

  Groups(String descriptionNew, String nameNew){
      name= nameNew;
      description = descriptionNew;
      creator = "";
      topics=[];
      forums=[];
      requests=[];
    }
      
  late ObjectId id;
  late String name;
  late String description;
  late List<dynamic> topics;
  late List<dynamic> forums;
  late String creator;
  late List<dynamic> members;
  late List<dynamic> admins;
  late String entranceCode;
  late List<dynamic> labels;
  late List<dynamic> requests;

  void initialize(){
      name="";
      description="";
      creator="";
      admins= [];
      topics= []; 
      forums = [];
      entranceCode = "";
      labels=[];
      requests=[];
      
}
  Groups.fromJson(Map<String,dynamic> json):
    id = json["_id"],
    name = json["name"],
    description = json["description"],
    creator = json["creator"],
    members = json["members"],
    admins = json["admins"],
    entranceCode = json["entrance_code"],
    labels = json['labels'],
    requests= json['requests'];
  
}