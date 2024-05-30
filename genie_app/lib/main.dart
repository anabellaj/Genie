import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/create_topic.dart';
import 'package:genie_app/view/screens/initial.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/view/screens/upload_study_material.dart';
import 'view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

import 'dart:async';
import 'package:genie_app/view/screens/add_group.dart';
/*TopicScreen(
      topic: Topic(
          name: 'Tema 1',
          description: 'Guia para saber esto',
          label: 'Parcial',
          files: [
            StudyMaterial(title: 'title1', description: 'description1'),
            StudyMaterial(title: 'title2', description: 'description2'),
            StudyMaterial(title: 'title3', description: 'description3'),
          ]), ),*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: UploadStudyMaterialScreen(
      topic: const Topic(
          id: '6657d49d7dca3271d92245a1',
          name: '',
          description: '',
          label: '',
          files: []),
    ),
    theme: genieThemeDataDemo,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> {
  late bool isUser = false;

  void checkState() async {
    bool ans = await Controller.getLoggedInUser();
    if (ans) {
      setState(() { 
        isUser = true;
      });
    } else {
      setState(() {
        isUser = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    checkState();

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => isUser
                    ? const AddGroupScreen()
                    : const SplashPage(title: "SplashPage"))));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "genie",
      debugShowCheckedModeBanner: false,
      theme: genieThemeDataDemo,
      home: const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
