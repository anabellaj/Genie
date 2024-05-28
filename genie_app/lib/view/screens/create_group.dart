import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/add_group.dart';
import 'package:genie_app/view/screens/initial.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/models/user.dart';

import 'package:genie_app/viewModel/validator.dart';
class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.pushReplacement(context, 
                        MaterialPageRoute(builder: (context)=>const HomeScreen())
                      );
                    },
                    child:Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: genieThemeDataDemo.colorScheme.secondary,),
                        Text(
                          'Regresar',
                          style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.secondary
                          ),
                        )],
                        )
                    
                    ),
          ],
        ),
      )
    );
  }
}