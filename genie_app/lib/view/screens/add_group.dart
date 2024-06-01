import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/forum_list.dart';
import 'package:genie_app/view/widgets/appbar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddGroupScreen extends StatelessWidget {
  const AddGroupScreen({super.key});

  removeUser()async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body:  Center(
        child:  FilledButton(onPressed: ()=>{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForumsListPage()))}, 
          child: const Text('foros')),
      )
    );
  }
}
