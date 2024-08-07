import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/settings.dart';
import 'package:genie_app/view/theme.dart';

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
          onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context)=>  SettingsPage())
            );
          },
        )
      ],
    );
  }
}
