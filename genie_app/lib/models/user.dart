import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  User(
      {String? id,
      required this.name,
      required this.lastName,
      required this.username,
      required this.university,
      required this.career,
      required this.interests,
      required this.chats,
      required this.studyGroups})
      : id = id ?? uuid.v4();
  final String id;
  final String name;
  final String lastName;
  final String username;
  final String university;
  final String career;
  final List<String> interests;
  final List<String> chats;
  final List<String> studyGroups;
}
