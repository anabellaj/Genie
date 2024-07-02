
import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/joined_groups.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool nameButtonPressed = true;
  bool careerButtonPressed = false;
  bool univButtonPressed = false;
  bool isLoading = false;
  late List<Widget> foundUsers = [];
  final TextEditingController _controller = TextEditingController();

  void findUsers(String attribute) async{
    print("Hola");
    setState(() {
      isLoading = true;
    });
    List<Widget> found = await Controller.getFoundUsers(_controller.text, attribute);
    print(foundUsers);
    setState(() {
      foundUsers = found;
      isLoading = false;
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(12.0),
              color: genieThemeDataDemo.colorScheme.secondary,
              child: Column(children: [
                TextButton(
                    onPressed: () {
                       //CAMBIAR ROUTE A group_menu
                    },
                    child: Row(children: [
                      Icon(
                        Icons.chevron_left,
                        color: genieThemeDataDemo.colorScheme.onPrimary,
                      ),
                      Text(
                        'Regresar',
                        style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.onPrimary),
                      )
                    ])),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: genieThemeDataDemo
                                              .colorScheme.onSecondary,
                                          hintText: "Buscar...",
                                          hintStyle: genieThemeDataDemo
                                              .textTheme.titleMedium,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: genieThemeDataDemo
                                                      .colorScheme.secondary),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(50)))),
                                    ),
                        ),
                      ),

                      IconButton(onPressed: (){
                        if(nameButtonPressed){
                          findUsers("name");
                        } else if(univButtonPressed){
                          findUsers("university");
                        } else if(careerButtonPressed){
                          findUsers("career");
                        }
                        
                      }, icon: Icon(Icons.search_outlined, color: genieThemeDataDemo.colorScheme.onPrimary)),

                    ]), 
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                            "Filtrar por:", style: TextStyle(color: genieThemeDataDemo.colorScheme.onPrimary),
                            ),
                          ),
                          FilledButton(onPressed: (){
                            setState(() {
                              univButtonPressed = false;
                              careerButtonPressed = false;
                              nameButtonPressed = true;
                            });
                          },
                          style:nameButtonPressed?
                          mainButtonStyle:
                          outlinedButtonStyle ,
                          child: const Text("Nombre")),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton(onPressed: (){
                              setState(() {
                                nameButtonPressed = false;
                              univButtonPressed = false;
                              careerButtonPressed=true;
                              });
                              
                            },
                            style:careerButtonPressed?
                            mainButtonStyle:
                            outlinedButtonStyle 
                            , child: const Text("Carrera")),
                          ),
                          FilledButton(onPressed: (){
                            setState(() {
                              careerButtonPressed = false;
                              nameButtonPressed = false;
                              univButtonPressed = true;
                            });
                          },
                          style:univButtonPressed?
                          mainButtonStyle:
                          outlinedButtonStyle 
                          , child: const Text("Universidad")),

                        ],
                      ),
                    
              ])),
        isLoading? 
        const Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(child: const CircularProgressIndicator()),
            ),
          ],
        ): 
        foundUsers.isEmpty?
        Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*.70,
                    child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No se ha encontrado ningún usuario", 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xffB4B6BF)),),
                     
                    ],
                  )):
        Expanded(child: ListView(children: [...foundUsers]))],
      ),
    );
  }
}