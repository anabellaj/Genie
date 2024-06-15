import 'package:flutter/material.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/flashcards_list.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/controllerStudy.dart';


class ModifyFlashcard extends StatefulWidget {
  const ModifyFlashcard({super.key, required this.flashcard, required this.topicId, required this.i, required this.flashcards});
  final Flashcard flashcard;
  final String topicId;
  final int i;
  final List<Flashcard> flashcards;
 

  @override
  State<ModifyFlashcard> createState() => _ModifyFlashcard();
}

class _ModifyFlashcard extends State<ModifyFlashcard> {
  final _termController = TextEditingController();
  final _defLabelController = TextEditingController();
  var isLoading = true;

  @override
  void initState() {
   
    _termController.text = widget.flashcard.term;
    _defLabelController.text = widget.flashcard.definition;
    super.initState();
  }

  void modifyFlashcard () async {
    if (_termController.text.isEmpty ||
        _defLabelController.text.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor llene todos los campos.')));
      return;
    }

    String newTerm = _termController.text;
    String newDef = _defLabelController.text;
    Flashcard newFlashCard = Flashcard(newTerm, newDef);
    
    //Confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Desea modificar la ficha?'),
          actions: [
            ElevatedButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Devuelve true cuando se acepta
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value){
        showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Modificando ficha...'),
                    ],
                  ),
                );
              },
           );
      final result = await ControllerStudy.updateFlashcard(newFlashCard, widget.flashcard.id);
      print (result);
        if (result == 'success'){
                  
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  FlashcardListPage(topicId: widget.topicId, flashcards: widget.flashcards,)));
        }
        else{
          ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Ha ocurrido un error.')));
        }
      } 
      else {
        return;
      }
    });

  }

  void deleteFile() async{
    //confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content:const  Text('¿Desea eliminar la ficha?'),
          actions: [
            ElevatedButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Devuelve true cuando se acepta
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value){
        showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Eliminando ficha...'),
                    ],
                  ),
                );
              },
  );
        final result = await ControllerStudy.deleteFlashcard(widget.flashcard.id, widget.topicId, widget.i);

        if (result == 'success'){
          //revisar como hay que pasar el id 
          // ObjectId id = ObjectId.fromHexString(topic.id);
          //final topicId = widget.topic.id;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  FlashcardListPage(topicId: widget.topicId, flashcards: widget.flashcards,)));
        }
        else{
          ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Ha ocurrido un error.')));
        }
      } else {
        return;
      }
    });
    
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: 
        // FutureBuilder(
        //   future: _loadMaterial(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //     if (snapshot.hasError) {
        //       //snackbar
        //       ScaffoldMessenger.of(context).clearSnackBars();
        //        ScaffoldMessenger.of(context)
        //             .showSnackBar(SnackBar(content: Text('Ha ocurrido un error.')));
        //       return const Center(
        //         child: Text('Ha ocurrido un error'),
        //       );
        //     }
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                
                // Boton de Regresar 
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  FlashcardListPage(topicId: widget.topicId, flashcards: widget.flashcards)));
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
                    const SizedBox(
                      height: 50,
                    ),
            
            // Contenedor blanco
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  20.0), 
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 172, 174, 188),
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              ]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Modificar Ficha',
                          style: genieThemeDataDemo.primaryTextTheme.headlineMedium
                        ),
                        
                        //Nombre 
                        TextField(
                          controller: _termController,
                          maxLength: 50,
                          decoration:  InputDecoration(
                            hintText: 'Término',
                            enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.secondary
                                          ),
                                        
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary
                                          ),)
                            
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        
                       
                        
                        TextField(
                          controller: _defLabelController,
                          maxLength: 50,
                          decoration:  InputDecoration(
                            hintText: 'Definición',
                            enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.secondary
                                          ),
                                        
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary
                                          ),)
                          ),
                        ),
                        
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                                modifyFlashcard();
                              },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff3d7f95))),
                            child: const Text(
                              'Modificar Ficha',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              deleteFile(); 
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll( Color.fromARGB(255, 255, 211, 217))),
                            child: const Text(
                              'Eliminar Ficha',
                              style: TextStyle(color: Color(0xffC5061D)),
                            ),
                          ),
                        )
              ], //children de columna
            ),
          )
          )
          )
            )
            ])
          )
    );
  }
}
