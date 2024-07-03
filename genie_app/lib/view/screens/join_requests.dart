import 'package:genie_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/join_request.dart';

class JoinRequestPage extends StatefulWidget{
  const JoinRequestPage({super.key});

  @override State<JoinRequestPage> createState() => _JoinRequestPageState();
}

class _JoinRequestPageState extends State<JoinRequestPage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body:Column(
        children: [
           Container(
        color: genieThemeDataDemo.colorScheme.secondary,
        
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.chevron_left,
                  color: genieThemeDataDemo.colorScheme.onSecondary),
                Text(
                  'Regresar',
                  style: TextStyle(
                    color: genieThemeDataDemo.colorScheme.onSecondary),
                )
              ],
            )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
            "Solicitudes",
            style: genieThemeDataDemo.primaryTextTheme.headlineSmall,
          ),
            )
        ],
      ),
      ),
      JoinRequest(),
      JoinRequest(),
        ],),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}