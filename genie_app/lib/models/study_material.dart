import 'dart:convert';
import 'dart:typed_data';

class StudyMaterial {
  StudyMaterial({
    this.id = '',
    required this.title,
    required this.description,
  });
  String id;
  final String title;
  final String description;

  Map<String, dynamic> toJson(Uint8List fileContent) {
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
    );
  }
}
