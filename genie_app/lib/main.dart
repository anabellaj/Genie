import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/initial.dart';
import 'view/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:genie_app/view/screens/add_group.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: MyApp(),
    theme: genieThemeDataDemo,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  

  @override
 State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> { 

  late bool isUser;

  getLoggedInUser() async{
    final prefs = await SharedPreferences.getInstance();
    var answer = await prefs.getBool("isLoggedIn");
    if(answer!=null){
      if(answer){
        setState(() {
          isUser =true;
        });
      }else{
        setState(() {
          isUser =false;
        });
      }
    }else{
      setState(() {
          isUser =false;
        });
    }
  }
  
  @override
  void initState(){
    super.initState();

    getLoggedInUser();
    Timer(
      const Duration(seconds: 3),
      ()=>Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>
          isUser? 
            const AddGroupScreen(): 
            const SplashPage(title: "SplashPage")
        

  )
      )
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Shared Preferences",
      debugShowCheckedModeBanner: false,
      theme: genieThemeDataDemo,
      home: const Scaffold(
         body: Center(
       child: CircularProgressIndicator(),
     )),
   );
  }
}
