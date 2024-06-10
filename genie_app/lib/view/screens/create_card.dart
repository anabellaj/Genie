import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';

class CreateCardScreen extends StatefulWidget {
  const CreateCardScreen({super.key});

  @override
  State<CreateCardScreen> createState() {
    return _CreateCardScreenState();
  }
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _terminoController = TextEditingController();
  final _defController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          const SizedBox(
                      height: 20,
                    ),
          TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: genieThemeDataDemo.colorScheme.secondary,
                  ),
                  Text(
                    'Regresar',
                    style: TextStyle(
                        color: genieThemeDataDemo.colorScheme.secondary),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'Añadir Ficha',
              style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 172, 174, 188),
                      spreadRadius: 1,
                      blurRadius: 10,
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Termino
                    Text(
                      'Término',
                      style: genieThemeDataDemo.textTheme.headlineMedium
                          ?.copyWith(
                              color: genieThemeDataDemo.colorScheme.secondary),
                      textAlign: TextAlign.left,
                    ),
                    TextField(
                      controller: _terminoController,
                      maxLines: null,
                      maxLength: 250,
                      decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 221, 221, 221), // Set the desired color here
                              ),
                    ), enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
                          ),
                    )
                    ),


                    const SizedBox(
                      height: 60,
                    ),

                    
                    //Definicion
                    Text(
                      'Definición',
                      style: genieThemeDataDemo.textTheme.headlineMedium
                          ?.copyWith(
                              color: genieThemeDataDemo.colorScheme.secondary),
                      textAlign: TextAlign.left,
                    ),
                    TextField(
                      controller: _defController,
                      maxLines: null,
                      maxLength: 500,
                      decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 221, 221, 221), // Set the desired color here
                              ),
                    ), enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
                          ),
                    )),

                  ],
                ),
              ),
            ),  
          ),
                    const SizedBox(
                      height: 20,
                    ),
          Center(
            child: SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        genieThemeDataDemo.colorScheme.primary,
                  ),
                  child: const Text(
                    'Guardar Ficha',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
