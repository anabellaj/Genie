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

  Map<String, dynamic> jsonifica() {
    return {
      'name': name,
      'description': description,
      'label': label,
    };
  }

  Topic deJsonificacion(String response) {
    final result = json.decode(response);
    return Topic(
        id: result['_id'],
        name: result['name'],
        description: result['description'],
        label: result['label'],
        files: result['files']);
  }
}
