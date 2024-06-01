import 'dart:convert';

import 'package:genie_app/models/study_material.dart';

class Topic {
  const Topic(
      {this.id = '',
      required this.name,
      required this.label,
      required this.files});

  final String id;
  final String name;
  final String label;
  final List<StudyMaterial> files;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'label': label,
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
        files = json['files'];
}
