import 'package:flutter/material.dart';
import 'package:genie_app/models/tf_question.dart';
import 'package:genie_app/models/tf_quiz.dart';
import 'package:genie_app/view/screens/fichas_menu.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/screens/initial.dart';
import 'package:genie_app/view/screens/test_menu.dart';
import 'package:genie_app/view/screens/tf_quiz.dart';
import 'package:genie_app/view/widgets/tabs.dart';
import 'view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Tabs(
      fichasContent:
          FichasView(), // Custom content widget for Fichas tab (if applicable)
      pruebasContent:
          TestView(), // Custom content widget for Pruebas tab (if applicable)
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
                    ? const HomeScreen()
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
