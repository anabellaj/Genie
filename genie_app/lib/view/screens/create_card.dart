import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/view/screens/flashcards_list.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/controllerStudy.dart';
import 'package:genie_app/viewModel/validator.dart';

class CreateCardScreen extends StatefulWidget {
  const CreateCardScreen({super.key, required this.topicId});
  final String topicId;

  @override
  State<CreateCardScreen> createState() {
    return _CreateCardScreenState();
  }
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _terminoController = TextEditingController();
  final _defController = TextEditingController();
   bool _validateTerm = true;
   bool _validateDefinition = true;
   bool isLoading = false;

  void _saveCard()async{
    if(!Validator.validateController(_terminoController)){
      setState(() {
        _validateTerm=false;
      });
    }else{
      setState(() {
        _validateTerm=true;
      });
    }
    if(!Validator.validateController(_defController)){
      setState(() {
        _validateDefinition=false;
      });
    }else{
      setState(() {
        _validateDefinition=true;
      });
    }
    if(_validateDefinition&&_validateTerm){
      setState(() {
        isLoading=true;
      });
      String res =await  ControllerStudy.addNewFlashCard(_terminoController.text, _defController.text, "665e2318f29fdd64c7000000");
      setState(() {
        isLoading=false;
      });
      if(res == 'success'){
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: genieThemeDataDemo.colorScheme.secondary,
          contentTextStyle: TextStyle(
            color: genieThemeDataDemo.colorScheme.onSecondary,
            fontSize: 12
          ),
          content: const Text("Ficha creada con éxito"), 
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
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: isLoading?
      const Center(child: CircularProgressIndicator(),):
      
      SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          const SizedBox(
                      height: 20,
                    ),
          TextButton(
              onPressed: () {
                 Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  FlashcardListPage(topicId: widget.topicId)));
              },
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
                      decoration:  InputDecoration(
                            errorText: _validateTerm? null:"Campo Obligatorio",
                            errorStyle: TextStyle(
                                          color: genieThemeDataDemo.colorScheme.onError,
                                        ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 221, 221, 221), // Set the desired color here
                              ),
                    ), enabledBorder: const UnderlineInputBorder(
                            borderSide:  BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
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
                      decoration:  InputDecoration(
                            errorText:  _validateDefinition? null:"Campo Obligatorio",
                            errorStyle: TextStyle(
                                          color: genieThemeDataDemo.colorScheme.onError,
                                        ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 221, 221, 221), // Set the desired color here
                              ),
                    ), enabledBorder: const UnderlineInputBorder(
                            borderSide:  BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
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
                    _saveCard();
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
