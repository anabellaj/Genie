import "package:genie_app/models/user.dart";

class Groups{

  Groups(String descriptionNew, String nameNew){
      name= nameNew;
      description = descriptionNew;
      creator = "";
      topics=[];
      forums=[];
    }
      
  late String id;
  late String name;
  late String description;
  late List<dynamic> topics;
  late List<dynamic> forums;
  late String creator;
  late List<dynamic> members;
  late List<String> admins;

  void initialize(){
      name="";
      description="";
      id= "";
      creator="";
      admins= [];
      topics= []; 
      forums = [];
}
}