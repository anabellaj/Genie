import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/code.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/join_group.dart';
import 'package:genie_app/view/screens/joined_groups.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;
  List<Widget> body = const [JoinedGroups(), JoinGroupPage(), JoinedGroups()];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
