import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genie_app/view/screens/upload_study_material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadStudyMaterialScreen(),
      theme: genieThemeDataDemo,
    );
  }
}
