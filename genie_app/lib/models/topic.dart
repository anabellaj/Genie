import 'dart:convert';

import 'package:genie_app/models/study_material.dart';

class Topic {
  const Topic(
      {this.id = '',
      required this.name,
      required this.description,
      required this.label,
      required this.files});

  final String id;
  final String name;
  final String description;
  final String label;
  final List<StudyMaterial> files;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'label': label,
    };
  }

  Topic.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        description = json['description'],
        label = json['label'],
        files = json['files'];
}
