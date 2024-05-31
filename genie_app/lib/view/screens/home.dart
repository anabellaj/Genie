import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/add_group.dart';
import 'package:genie_app/view/screens/code.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/screens/join_group.dart';
import 'package:genie_app/view/screens/joined_groups.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/widgets/appbar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;
  List<Widget> body = const [CodePage(), JoinGroupPage(), JoinedGroups()];
  removeUser()async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex){
          setState(() {
            
            _currentIndex = newIndex;
            
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: "Crear Grupo",
            icon: Icon(Icons.add)),
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat)),
        ]
      ),
    );
  }
}
