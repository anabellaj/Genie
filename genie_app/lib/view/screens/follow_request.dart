import 'package:genie_app/view/screens/settings.dart';
import 'package:genie_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/follow_request.dart';

class FollowRequestPage extends StatefulWidget{
  const FollowRequestPage({super.key});

  @override State<FollowRequestPage> createState() => _FollowRequestPageState();
}

class _FollowRequestPageState extends State<FollowRequestPage>{


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
              Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (context)=>  SettingsPage())
          );
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
            "Solicitudes de Amistad",
            style: genieThemeDataDemo.primaryTextTheme.headlineSmall,
          ),
            )
        ],
      ),
      ),
      FollowRequest(),
      FollowRequest(),
        ],),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}