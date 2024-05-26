import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
 User(String emailPam, String passwordPam,){
      name= "";
      email = emailPam;
      password = passwordPam;
      username="";
      university="";
      career="";
    }
      
  late String id;
  late String name;
  late String email;
  late String password;
  late String username;
  late String university;
  late String career;
  late List<String> interests;
  late List<String> chats;
  late List<String> studyGroups;

  Map<String, dynamic> toJson()=>
    {
      "id":id,
      "name":name,
      "email":email,
      "password":password,
      "username":username,
      "university":university,
      "career":career,
      "interests":interests.toString(),
      "chats": chats.toString(),
      "studyGroups":studyGroups.toString()

    };
  User.fromJson(Map<String,dynamic> json):
    id = json['id'],
    name = json['name'],
    email = json['email'],
    password = json['password'],
    username = json['username'],
    university = json['university'],
    career = json['career'];    
  
  
}
