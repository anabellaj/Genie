import 'package:flutter/material.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/home.dart';  
import 'package:genie_app/view/screens/initial.dart';
import 'view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
    theme: genieThemeDataDemo,  
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _myAppState();
}

// ignore: camel_case_types
class _myAppState extends State<MyApp> {
  late bool isUser = false;
  late User user;
  void checkState() async {
    bool ans = await Controller.getLoggedInUser();
    user = await Controller.getUserInfo();
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
