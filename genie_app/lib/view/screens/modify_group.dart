import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/validator.dart';

class ModifyGroupPage extends StatefulWidget {
  Groups currentGroup;
  ModifyGroupPage({super.key, required this.currentGroup});

  @override
  State<ModifyGroupPage> createState() => _ModifyGroupPageState();
}

class _ModifyGroupPageState extends State<ModifyGroupPage> {

final _formKey = GlobalKey<FormState>();
  final validate = Validator();
  String name = "";
  String description = "";
  String answer = "";
  late User loggedUser;
  late Groups newGroup;
  late String userId;
  bool isLoading =true;
  late var insertedStGroupId;
  

  void getUser() async{
    User userNow = await Controller.getUserInfo();
    if(userNow.email.isNotEmpty){
    setState(() {
      isLoading = false;
    });
    }else {
      userNow.initialize();
      loggedUser = userNow;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopBar(),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:isLoading? 
          const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                        Navigator.pushReplacement(context, 
                          MaterialPageRoute(builder: (context)=> GroupView(group: widget.currentGroup))
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
                          Text('Modificar Grupo',
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
                        setState(() {
                          name = value as String;
                        });
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
                      obscureText: false,
                    ),
                      Container(
                        margin: const EdgeInsets.only(top:24),
                        child: FilledButton(
                          style: mainButtonStyle,
                          child: const Text(
                          'Guardar Cambios'
                        ),
                          onPressed: () async=>{
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState!.save()
                            ,
                            setState(() {
                              isLoading = true;
                            }),
                            widget.currentGroup = await Controller.updateGroupInfo(widget.currentGroup, description, name),
                            setState(() {
                              isLoading = false;
                            }),

                            Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=> GroupView(group: widget.currentGroup)))
                            
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
    ,bottomNavigationBar: BottomNavBar());
  }
}

