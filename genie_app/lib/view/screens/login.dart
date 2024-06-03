import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/screens/register.dart';
import 'package:genie_app/viewModel/authentication.dart';
import 'package:genie_app/viewModel/validator.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  

  final String title;
  

  @override
  State<LoginPage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final validate = Validator();
 

  bool isLoading=false;

  String email = "";
  String password = "";
  String answer = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.primary,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                
                children: [
                  Padding(padding: EdgeInsets.all(20),
                  child:Image(image: AssetImage('lib/view/assets/genie logo.png'), width: 150,)
                  )
                  
                 
                ],
                ),
            ),
            Expanded(

            child: 
            isLoading? const Center(
              child: CircularProgressIndicator()):
            Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
              
              children: [
                
               Text('Iniciar Sesión',
                style: Theme.of(context).primaryTextTheme.headlineMedium,
                textAlign: TextAlign.start),
                Form(
                key: _formKey,
                child: Padding(padding: const EdgeInsets.all(12),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      onSaved: (value){
                        if(value !=null){
                          email=value;
                        }
                      },
                      validator: (value) {
                          return validate.validateEmail(value);
                        },
                      decoration: InputDecoration(
                        hintText: 'Correo Electrónico',
                        errorStyle: TextStyle(
                          color: genieThemeDataDemo.colorScheme.onError,
                        ),
                        prefixIcon: Icon(
                          Icons.mail_outlined,
                          color: Theme.of(context).colorScheme.secondary,),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary
                          ),
                        
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary
                          ),
                      )),
                      textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.displayLarge,

                    ),
                    TextFormField(
                      onSaved: (value){
                        if(value !=null){
                          password=value;
                        }
                      },
                      validator: (value){
                        return validate.validateEmpty(value);
                      },
                      
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: genieThemeDataDemo.colorScheme.onError,
                        ),
                        hintText: 'Contraseña',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.secondary,),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary
                          ),
                        
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary
                          ),
                      )),
                      textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.displayLarge,
                      obscureText: true,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:24),
                      child:  FilledButton(
                      onPressed: ()async=> {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save(),
                          setState(()=>
                          isLoading=true),
                          answer = await Authenticate.loginUser(email, password),
                          setState(()=>
                          isLoading=false),

                          if(answer == "success"){
                            Navigator.pushReplacement(
                              context, 
                            MaterialPageRoute(builder: (context)=> const HomeScreen()))
                          }else if(answer == "wrong_credentials"){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El usuario o contraseña es incorrecto'))),
                          }else if(answer == "user_doesnt_exist"){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay usuario con estas credenciales'))),
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Hubo un error'))),
                          }
                          
                        }
                      }, 
                      style: mainButtonStyle,
                        child: const Text(
                          'Iniciar Sesión'
                        )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:10),
                      child:  FilledButton(
                      style: linkButtonStyle,
                      onPressed: ()=>{
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context)=> const RegisterPage(title: 'Registrar Página')))
                      }, 
                        child: const Text(
                          '¿No tienes cuenta? Crea tu cuenta aquí'
                        )),
                    )
                   
                  ],))

              
            )]))
             
            ),
            ],)
           
    ),
   );
            
          
          

        
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
      
  }
}