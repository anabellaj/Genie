import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/screens/initial.dart';
import 'package:genie_app/view/screens/settings.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/viewModel/validator.dart';
import 'package:image_picker/image_picker.dart';

class ModifyProfile extends StatefulWidget {
  const ModifyProfile({super.key});

  @override
  State<ModifyProfile> createState() => _ModifyProfile();
}

class _ModifyProfile extends State<ModifyProfile> {
  late User loggedUser;
  late bool isLoading = true;
  final validate = Validator();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  void getUser() async {
    User ans = await Controller.getUserInfo();
    if (ans.email.isNotEmpty) {
      setState(() {
        loggedUser = ans;
        isLoading = false;
      });
    } else {
      ans.initialize();
      loggedUser = ans;
      isLoading = false;
    }

    if (loggedUser.profilePicture != '') {
      _imageFile = await loggedUser.fileFromBase64String();
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _compressImage();
      });
    }
  }

  void _compressImage() async {
    if (_imageFile != null) {
      final imageBytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      setState(() {
        loggedUser.profilePicture = base64Image;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body:  Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading? 
          const Center(child: CircularProgressIndicator())
          : Column(
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
              Expanded(
                child: Card(
                  color: genieThemeDataDemo.colorScheme.surface,
                  shadowColor: genieThemeDataDemo.colorScheme.onSurface,
                  elevation: 4,
                  child: 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      child: ListView(
                        children:[ 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Modificar Perfil',
                                style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                child: Form(key:_formKey,child: 
                                Column(
                                  children: [
                                    TextFormField(
                                      initialValue: loggedUser.name,
                                      onSaved:(value){
                                        if(value!=null){
                                          loggedUser.name = value;
                                        }
                                      }, 
                                      
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: genieThemeDataDemo.colorScheme.onError,
                                        ),
                                        hintText: 'Nombre',
                                        prefixIcon: Icon(
                                          Icons.account_circle,
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
                                    initialValue: loggedUser.email,
                                    onSaved:(value){
                                      if(value!=null){
                                        loggedUser.email=value;
                                      }
                                    }, 
                                    validator: (value) {
                                      return validate.validateEmail(value);
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        color: genieThemeDataDemo.colorScheme.onError,
                                      ),
                                      hintText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
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
                                  initialValue: loggedUser.password,
                                  onSaved:(value){
                                    if(value!=null){
                                      loggedUser.password=value;
                                    }
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
                                TextFormField(
                                  initialValue: loggedUser.university,
                                  onSaved:(value){
                                    if(value!=null){
                                      loggedUser.university=value;
                                    }
                                  }, 
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: genieThemeDataDemo.colorScheme.onError,
                                    ),
                                    hintText: 'Universidad',
                                    prefixIcon: Icon(
                                      Icons.school,
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
                                  initialValue: loggedUser.career,
                                  onSaved:(value){
                                    if(value!=null){
                                      loggedUser.career=value;
                                    }
                                  }, 
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: genieThemeDataDemo.colorScheme.onError,
                                    ),
                                    hintText: 'Carrera',
                                    prefixIcon: Icon(
                                      Icons.book,
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
                                  initialValue: loggedUser.interests.isEmpty? "": Controller.getListInfo(loggedUser.interests),
                                  onSaved:(value){
                                    if(value!=null){
                                      if(value==""){
                                        loggedUser.interests=[];
                                      }else{
                                         loggedUser.interests=value.split(",");
                                      }
                                     
                                    }
                                  }, 
                                  decoration: InputDecoration(
                                    helperText: 'Ingrese sus intereses separados por comas',
                                    helperStyle: TextStyle(
                                      color: genieThemeDataDemo.colorScheme.onSurface,
                                      fontSize: 10
                                    ),
                                    errorStyle: TextStyle(
                                      color: genieThemeDataDemo.colorScheme.onError,
                                    ),
                                    hintText: 'Intereses',
                                    prefixIcon: Icon(
                                      Icons.favorite,
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
                                    String answer = await Controller.updateUserInfo(loggedUser);
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
                                        content: const Text("Cambios guardados con éxito"), 
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
                                child: const Text('Guardar Cambios'))
                                ,
                              
                              ),
                              
                              
                              
                            ]),
                          Container(
                            margin: const EdgeInsets.only(top:16),
                            child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FilledButton(
                                      onPressed: ()async{
                                        setState(() {
                                          isLoading=true;
                                        });
                                        String ans = await Controller.logOutUser();
                                        setState(() {
                                          isLoading=false;
                                        });
                                        if(ans == "success"){
                                          Navigator.pushReplacement(context, 
                                          MaterialPageRoute(builder: (context)=> const SplashPage(title: "Splash")));
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Hubo un error')
                                          ));
                                        }
                                      }, 
                                      style: smallButtonStyle,
                                      child: const Text('Cerrar Sesión')),
                                    FilledButton(
                                      onPressed: ()async {
                                        setState(() {
                                          isLoading=true;
                                        });
                                        String ans = await Controller.removeUser(loggedUser);
                                        setState(() {
                                          isLoading=false;
                                        });
                                        if(ans == "success"){
                                          Navigator.pushReplacement(context, 
                                          MaterialPageRoute(builder: (context)=> const SplashPage(title: "Splash")));
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Hubo un error')
                                          ));
                                        }
                                      }, 
                                      style: deleteButtonStyle,
                                      child: const Text('Eliminar Cuenta'))
                                  ],)
                                
                                
                                ,
                          )    
                      ],),
                    )
              )
              )
              ,
            ])
        ),
        bottomNavigationBar: BottomNavBar());
  }
}