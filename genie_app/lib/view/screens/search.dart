
import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/joined_groups.dart';
import 'package:genie_app/view/theme.dart';

class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool nameButtonPressed = true;
  bool careerButtonPressed = false;
  bool univButtonPressed = false;

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
        ],
      ),
    );
  }
}