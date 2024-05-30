import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class StudyMaterial {
  const StudyMaterial(
      {this.id = '',
      required this.title,
      required this.description,
      required this.fileContent});
  final String id;
  final String title;
  final String description;
  final Uint8List fileContent;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'fileContent': Uint8List.fromList(fileContent),
    };
  }

  Future<StudyMaterial> fromJson(String response) async {
    final result = json.decode(response);
    return StudyMaterial(
        id: result['_id'],
        title: result['name'],
        description: result['description'],
        fileContent: result['fileContent'] as Uint8List);
  }
}
