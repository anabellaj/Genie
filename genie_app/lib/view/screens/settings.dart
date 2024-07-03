import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/follow_request.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/theme.dart';


class SettingsPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: TopBar(),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      TextButton(
              onPressed: () {
               Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: genieThemeDataDemo.colorScheme.secondary,
                  ),
                  Text(
                    'Regresar',
                    style: TextStyle(
                        color: genieThemeDataDemo.colorScheme.secondary),
                  )
                ],
              )),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: 
        Text("Ajustes", 
          style: genieThemeDataDemo.primaryTextTheme.headlineLarge?.copyWith(color: genieThemeDataDemo.colorScheme.primary),),
      ),
      GestureDetector(
        onTap: (){
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context)=> const ModifyProfile())
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide( color: genieThemeDataDemo.colorScheme.primary, width: 2))
          ),
          child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Modificar cuenta",),
                   Icon(Icons.chevron_right, color: genieThemeDataDemo.colorScheme.primary, size: 32,)
                ],
              ), 
            )
        )
      ),
      GestureDetector(
        onTap: (){
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context)=> const FollowRequestPage())
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide( color: genieThemeDataDemo.colorScheme.primary, width: 2))
          ),
          child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Solicitudes de amistad",),
                   Icon(Icons.chevron_right, color: genieThemeDataDemo.colorScheme.primary, size: 32,)
                ],
              ), 
            )
        )
      )

    ],),
    bottomNavigationBar: BottomNavBar(),
   );
  }

}
