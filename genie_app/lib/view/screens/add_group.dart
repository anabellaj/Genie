import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
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
      body: Center(
        child: FilledButton(
          style: mainButtonStyle,
          child: const Text(
            'Salir'
          ),
          onPressed: () async=>{
             await removeUser()

          },
        ),
      )
    );
  }
}
