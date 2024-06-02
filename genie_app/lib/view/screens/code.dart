import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/screens/register.dart';
import 'package:genie_app/viewModel/authentication.dart';
import 'package:genie_app/viewModel/validator.dart';
import '../theme.dart';

class CodePage extends StatelessWidget{

  final Groups group;
  const CodePage({super.key, required this.group});

  Widget build(BuildContext context){
    return Scaffold(
      body:
      Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                Navigator.pushReplacement(context, 
                                  MaterialPageRoute(builder: (context)=> GroupView(group: group))
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
                              const SizedBox(height: 15),
                              Container(
                                height: MediaQuery.of(context).size.height/2.3,
                                width: MediaQuery.of(context).size.width,
          
                                decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(10.0), // Add some border radius for better effect
                                boxShadow: [
                                  BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with some transparency
                                  spreadRadius: 3.0, // Adjusts how far the shadow spreads
                                  blurRadius: 6.0, // Adjusts how blurry the shadow is
                                  offset: const Offset(0.0, 4.0), // Shifts the shadow position (optional)
                                ),
                              ],
                              ),
                              child: Padding(
                                padding:  const EdgeInsets.all(8.0),
                                child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('¡Invita a tus amigos!',
                                    style: Theme.of(context).primaryTextTheme.headlineLarge,
                                    textAlign: TextAlign.start),
                                    const SizedBox(height: 20),
                                    Text('El código de invitación para tu grupo de estudio es:',
                                    style: Theme.of(context).textTheme.displayMedium,
                                    textAlign: TextAlign.start),
                                    const SizedBox(height: 20),
                                    Text(group.entranceCode,
                                      style: Theme.of(context).primaryTextTheme.headlineMedium
                                    )
                                    ]

                                ),
                              ),
                              )
            ],
          ),
        ),
      ),
    );
  }

}