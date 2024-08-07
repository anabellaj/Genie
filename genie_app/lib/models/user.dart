import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
const idGenerator = Uuid();

class User {
  User(
    String emailPam,
    String passwordPam,
  ) {
    name = "";
    username = "";
    email = emailPam;
    password = passwordPam;
    username = "";
    university = "";
    career = "";
    profilePicture = '';
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
  late String profilePicture;
  late String following;

  void initialize() {
    career = "";
    university = "";
    id = "";
    career = "";
    interests = [];
    chats = [];
    studyGroups = [];
    flashCardsStudied = [];
    replysLiked = [];
    following = "";
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "username": username,
        "university": university,
        "career": career,
        "interests": interests,
        "chats": chats,
        "studyGroups": studyGroups,
        "flashCardsStudied": flashCardsStudied,
        "replysLiked": replysLiked,
        "profilePicture": profilePicture,
        "following":following
      };
  User.fromJson(Map<String, dynamic> json)
      : id = json["_id"] != null ? json['_id'].oid.toString() : json['id'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        username = json['username'] ?? "",
        university = json['university'] ?? "",
        career = json['career'] ?? "",
        interests = json['interests'] ?? [],
        chats = json['chats'] ?? [],
        studyGroups = json['studyGroups'] ?? [],
        flashCardsStudied = json['flashCardsStudied'] ?? [],
        profilePicture = json["profilePicture"] ?? "",
        replysLiked = json['replysLiked'] ?? [],
        following = json['following']?? "";

  User.fromShared(Map<String, dynamic> json)
      : id = json["id"],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        username = json['username'] ?? "",
        university = json['university'] ?? "",
        career = json['career'] ?? "",
        interests = json['interests'] ?? [],
        chats = json['chats'] ?? [],
        studyGroups = json['studyGroups'] ?? [],
        flashCardsStudied = json['flashCardsStudied'] ?? [],
        profilePicture = json["profilePicture"] ?? "",
        replysLiked = json['replysLiked'] ?? [],
        following = json['following']?? "";



  Future<File> fileFromBase64String() async  {
    final decodedBytes = base64Decode(profilePicture);
    final directory = await getApplicationDocumentsDirectory();
    var idString = idGenerator.v4();
    return File('${directory.path}/${idString}pp')..writeAsBytesSync(decodedBytes);
  }
}
