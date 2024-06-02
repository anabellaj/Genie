

import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/forum_list.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/validator.dart';
import 'package:genie_app/viewModel/controller.dart';



class AddForum extends StatefulWidget{
  final Groups groupId;
  const AddForum({super.key, required this.groupId});

  @override
  State<AddForum> createState() =>  _AddForum();
}

class _AddForum extends State<AddForum>{
  final _formKey = GlobalKey<FormState>();
  late bool isLoading = false;
  String title=""; 
  String description="";

  final validate = Validator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: isLoading?
      const Center(child: CircularProgressIndicator()):
      
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TextButton(
                    
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.pushReplacement(context, 
                        MaterialPageRoute(builder: (context)=> ForumsListPage(groupId: widget.groupId,))
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:24, horizontal: 24),
                  child:Card(
                  color: genieThemeDataDemo.colorScheme.surface,
                  shadowColor: genieThemeDataDemo.colorScheme.onSurface,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: ListView(
                        children: [
                              Text(
                                'Crear Foro',
                                style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
                              ),
                              Container(
                                
                                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                                child: 
                                Form(key:_formKey,child: 
                                  Column(
                                   children: [
                                    TextFormField(
                                      onSaved:(value){
                                        if(value!=null){
                                          title = value;
                                        }
                                      }, 
                                      validator: (value){
                                        return validate.validateEmpty(value);
                                      },
                                      
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: genieThemeDataDemo.colorScheme.onError,
                                        ),
                                        hintText: 'Título',
                                        prefixIcon: Icon(
                                          Icons.edit,
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
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    maxLines: 5,
                                    textAlignVertical: TextAlignVertical.center,

                                    onSaved:(value){
                                      if(value!=null){
                                        description=value;
                                      }
                                    }, 
                                    validator: (value) {
                                      return validate.validateEmpty(value);
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        color: genieThemeDataDemo.colorScheme.onError,
                                      ),
                                      hintText: 'Descripción',
                                      
                                      prefixIcon: Icon(
                                        Icons.comment,
                                        color: Theme.of(context).colorScheme.secondary,),
                                      enabledBorder: OutlineInputBorder(
                                        gapPadding: 8,
                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        borderSide: BorderSide(
                                          color: genieThemeDataDemo.colorScheme.primary
                                        )
                                        ),
                                      errorBorder: OutlineInputBorder(
                                        gapPadding: 8,
                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        borderSide: BorderSide(
                                          color: genieThemeDataDemo.colorScheme.error
                                        )
                                        ),  
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 8,
                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        borderSide: BorderSide(
                                          color: genieThemeDataDemo.colorScheme.primary
                                        )
                                        ),),
                                    style: Theme.of(context).textTheme.displayLarge,
                                  ),
                                
                                  ],
                                )),
                              ),
                              
                              Container(
                                margin: const EdgeInsets.only(top:12),
                                child: FilledButton(
                                onPressed: () async{

                                  if(_formKey.currentState!.validate()){
                                    _formKey.currentState!.save();
                                    setState(() {
                                      isLoading=true;
                                    });
                                    String answer = await Controller.createNewForum(title, description);
                                    if(answer=="success"){  
                                      setState(() {
                                        isLoading=false;
                                      });
                                      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                                        backgroundColor: genieThemeDataDemo.colorScheme.secondary,
                                        contentTextStyle: TextStyle(
                                          color: genieThemeDataDemo.colorScheme.onSecondary,
                                          fontSize: 12
                                        ),
                                        content: const Text("Foro creado con éxito"), 
                                        actions: [IconButton(
                                          onPressed: ()=>
                                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
                                            icon: Icon(Icons.check, color: genieThemeDataDemo.colorScheme.onSecondary,))]));
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Hubo un error')
                                      ));
                                    }
                                  }
                                }, 
                                
                                style: mainButtonStyle,
                                child: const Text('Crear Foro'))
                                ,
                              
                              ),
                            ]),
              ))
        
            ),
          )
        ]
      )
    );
  }
}