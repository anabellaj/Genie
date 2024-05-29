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
class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {

final _formKey = GlobalKey<FormState>();
  final validate = Validator();
  String name = "";
  String description = "";
  String answer = "";

  String verifyNameDescription(){
    String answer ="";
    return answer;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Center(
        child: Padding(
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    
                      children: [
                          Text('Crear Grupo de Estudio',
                          style: Theme.of(context).primaryTextTheme.headlineLarge,
                          textAlign: TextAlign.start),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                      onSaved: (value){
                        if(value !=null){
                          name=value;
                        }
                      },
                      validator: (value) {
                          return validate.validateEmpty(value);
                        },
                      decoration: InputDecoration(
                        hintText: 'Nombre del Grupo',
                        errorStyle: TextStyle(
                          color: genieThemeDataDemo.colorScheme.onError,
                        ),
                        prefixIcon: Icon(
                          Icons.arrow_forward,
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

                    ), TextFormField(
                      onSaved: (value){
                        if(value !=null){
                          description=value;
                        }
                        setState(() {
                          description = value as String;
                        });
                      },
                      validator: (value){
                        return validate.validateEmpty(value);
                      },
                      
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: genieThemeDataDemo.colorScheme.onError,
                        ),
                        hintText: 'Descripción del Grupo',
                        prefixIcon: Icon(
                          Icons.abc_outlined,
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
                        child: FilledButton(
                          style: mainButtonStyle,
                          child: const Text(
                          'Iniciar Sesión'
                        ),
                          onPressed: () async=>{
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState!.save()
                            ,
                            print(description),
                            Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=>const HomeScreen()))
                            }
                          },
                        )
                      )],
                            ),

                          ),
                      ],
                    ),
                  ),
              ),],
          ),
        ),
      )
    );
  }
}