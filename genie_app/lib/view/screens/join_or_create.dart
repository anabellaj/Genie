import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/screens/join_group.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import '../theme.dart';

class JoinOrCreate extends StatelessWidget {
  const JoinOrCreate({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                            height: MediaQuery.of(context).size.height/2.3,
                            width: MediaQuery.of(context).size.width,
                            
                            decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(10.0), // Add some border radius for better effect
                            boxShadow: [
                                  BoxShadow(
                                  color: genieThemeDataDemo.colorScheme.onSurface.withOpacity(0.25), // Shadow color with some transparency
                                  spreadRadius: 0, // Adjusts how far the shadow spreads
                                  blurRadius: 12.0, // Adjusts how blurry the shadow is
                                        offset: const Offset(0.0, 3.0), // Shifts the shadow position (optional)
                                      ),
                                    ],
                                    ),
                                     child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                          
                            children: [
                                Text('Únete o crea un grupo',
                                style: Theme.of(context).primaryTextTheme.headlineLarge,
                                textAlign: TextAlign.center),
                        Container(
                          margin: const EdgeInsets.only(top:24),
                          child: FilledButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=>const CreateGroupPage()));
                                  },
                          style: mainButtonStyle,
                          child: const Text(
                          'Crear un grupo'
                        )),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          
                          child: FilledButton(
                                    onPressed: (){
                                      Navigator.pushReplacement(context, 
                              MaterialPageRoute(builder: (context)=>const JoinGroupPage()));
                                    },
                            style: secondaryButtonStyle,
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
