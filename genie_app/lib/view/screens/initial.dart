import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/register.dart';
import 'package:genie_app/view/screens/login.dart';
import '../theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.title});

  

  final String title;

  @override
  State<SplashPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        
        child:  Container(
              color: genieThemeDataDemo.colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(padding: EdgeInsets.all(20),
                        child:Image(image: AssetImage('lib/view/assets/genie logo.png'), 
                        width: 150,
                        height: 130,)
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    child:  FilledButton(
                      style: outlinedButtonStyle,
                      onPressed: ()=>{
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=> const RegisterPage(title: 'Crea tu Cuenta')))
                        }, 
                      child: const Text(
                        'Crea tu Cuenta'
                        )
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    child:  FilledButton(
                      style: secondaryButtonStyle,
                      onPressed: ()=>{
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=> const LoginPage(title: 'Inicia Sesión')))
                        }, 
                      child: const Text(
                        'Inicia Sesión'
                        )
                      ),
                    )
                ],)
          )
    ));
            
          
          

       
      
  }
}