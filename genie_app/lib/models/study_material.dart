
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class StudyMaterial {
  const StudyMaterial({required this.title,required this.description,required this.file});

  final String title;
  final String description;
  final PlatformFile file;

}