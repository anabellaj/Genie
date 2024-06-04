import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {

  removeUser()async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopBar(),
      body:  const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            

          ]
        )

      )

    );
  }
}