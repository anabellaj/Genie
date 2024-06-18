import 'package:genie_app/models/study_material.dart';

class Topic {
   Topic(
      {this.id = '',
      required this.name,
      required this.label,
      required this.files, 
      this.percent=0});

  final String id;
  final String name;
  final String label;
  final List<StudyMaterial> files;
  late double percent=0;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'label': label,
      'studyMaterial':[]
    };
  }

  Topic.forPreview(Map<String, dynamic> json):
    id = json["_id"] is String?  json['_id']:json['_id'].oid.toString(),
    name = json['name'],
    label = json['label'],
    files = [];

  Topic.fromJson(Map<String, dynamic> json)
      : id = json["_id"] is String?  json['_id']:json['_id'].oid.toString(),
        name = json['name'],
        label = json['label'],
        files = json['studyMaterial'];
}
