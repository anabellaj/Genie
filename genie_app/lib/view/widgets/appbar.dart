import 'package:flutter/material.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/screens/profile.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class TopBar extends AppBar {
  TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('genie'),
      shadowColor: const Color(0xff212227),
      elevation: 4,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings,
            color: genieThemeDataDemo.colorScheme.onPrimary,
          ),
          onPressed: () async {
            User ans = await Controller.getUserInfo();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                          displayedUser: ans,
                          currentuUser: true,
                        )));
          },
        )
      ],
    );
  }
}
