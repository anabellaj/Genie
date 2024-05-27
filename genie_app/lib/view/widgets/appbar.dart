import 'package:flutter/material.dart';
// import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/theme.dart';

class TopBar extends AppBar {
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'genie',
        style: genieThemeDataDemo.primaryTextTheme.headlineSmall,
      ),
      shadowColor: const Color(0xff212227),
      backgroundColor: genieThemeDataDemo.colorScheme.primary,
      elevation: 4,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings,
            color: genieThemeDataDemo.colorScheme.onPrimary,
          ),
          // onPressed: () {
          //   Navigator.pushReplacement(context,
          //   MaterialPageRoute(builder: (context)=> (const ModifyProfile()))
          //   );
          // },
          onPressed: () {},
        )
      ],
    );
  }
}
