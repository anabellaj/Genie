import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/screens/join_group.dart';
import 'package:genie_app/view/screens/register.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/authentication.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/validator.dart';
import '../theme.dart';

class JoinOrCreate extends StatelessWidget {
  const JoinOrCreate({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                            height: MediaQuery.of(context).size.height/2.3,
                            width: MediaQuery.of(context).size.width,
                            
                            decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(10.0), // Add some border radius for better effect
                            boxShadow: [
                                  BoxShadow(
                                  color: Colors.grey.withOpacity(0.7), // Shadow color with some transparency
                                  spreadRadius: 5.0, // Adjusts how far the shadow spreads
                                  blurRadius: 6.0, // Adjusts how blurry the shadow is
                                        offset: const Offset(0.0, 4.0), // Shifts the shadow position (optional)
                                      ),
                                    ],
                                    ),
                                     child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          
                            children: [
                                Text('Únete o crea un grupo',
                                style: Theme.of(context).primaryTextTheme.headlineLarge,
                                textAlign: TextAlign.center),
                                FilledButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=>const CreateGroupPage()));
                                  },
                          style: mainButtonStyle,
                          child: const Text(
                          'Crear un grupo'
                        )),Container(
                          
                          child: FilledButton(
                                    onPressed: (){
                                      Navigator.pushReplacement(context, 
                              MaterialPageRoute(builder: (context)=>const JoinGroupPage()));
                                    },
                            style: mainButtonStyle,
                            child: const Text(
                            'Unirse a un grupo'
                          )),
                        )

                ]))),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar());
  }
}
