

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
  late List<dynamic> interests;
  late List<dynamic> chats;
  late List<dynamic> studyGroups;
  late List<dynamic> flashCardsStudied;
  late List<dynamic> replysLiked;

  void initialize(){
      career="";
      university="";
      id= "";
      career="";
      interests = [];
      chats = [];
      studyGroups= []; 
      flashCardsStudied=[];
      replysLiked=[];
    }

  Map<String, dynamic> toJson()=>
    {
      "id":id,
      "name":name,
      "email":email,
      "password":password,
      "username":username,
      "university":university,
      "career":career,
      "interests":interests,
      "chats": chats,
      "studyGroups":studyGroups,
      "flashCardsStudied":flashCardsStudied,
      "replysLiked": replysLiked

    };
  User.fromJson(Map<String,dynamic> json):
    id = json["_id"]!=null ?  json['_id'].oid.toString():json['id'],
    name = json['name'],
    email = json['email'],
    password = json['password'],
    username = json['username'] ?? "",
    university = json['university'] ?? "",
    career = json['career'] ?? "",
    interests = json['interests'] ?? [],
    chats = json['chats'] ?? [],
    studyGroups = json['studyGroups'] ?? [],
    flashCardsStudied= json['flashCardsStudied']??[],
    replysLiked =json['replysLiked']??[];
  
  User.fromShared(Map<String,dynamic> json):
    id = json["id"],
    name = json['name'],
    email = json['email'],
    password = json['password'],
    username = json['username'] ?? "",
    university = json['university'] ?? "",
    career = json['career'] ?? "",
    interests = json['interests'] ?? [],
    chats = json['chats'] ?? [],
    studyGroups = json['studyGroups'] ?? [],
    flashCardsStudied= json['flashCardsStudied']??[],
    replysLiked = json['replysLiked']??[];
  
  
}
