import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';

class ModifyTopicScreen extends StatefulWidget {
  const ModifyTopicScreen({super.key, required this.topic});
  final Topic topic;

  @override
  State<ModifyTopicScreen> createState() => _ModifyTopicScreen();
}

class _ModifyTopicScreen extends State<ModifyTopicScreen> {
  final _titleController = TextEditingController();
  final otherLabelController = TextEditingController();
  late List<String> evaluationLabels;
  var isLoading = true;
  //late String selectedOption;

  @override
  void initState() {
   
    _titleController.text = widget.topic.name;
    otherLabelController.text = widget.topic.label;
    super.initState();
  }

   Future<Topic> _loadTopic() async {
    return Connection.readTopic(widget.topic.id);
  }

  void modifyTopic () async {
    if (_titleController.text.isEmpty ||
        otherLabelController.text.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor llene todos los campos.')));
      return;
    }

    String newName = _titleController.text;
    String newLabel = otherLabelController.text;
    Topic newTopic = Topic(name: newName, label: newLabel, files: widget.topic.files);

    //Confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Desea modificar el tema?'),
          actions: [
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: Text('Cancelar'),
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
                      Text('Modificando tema...'),
                    ],
                  ),
                );
              },
  );
        final result = await Connection.updateTopic(newTopic, widget.topic.name);

        if (result == 'success'){
          //revisar como hay que pasar el id 
          // ObjectId id = ObjectId.fromHexString(topic.id);
          //final topicId = widget.topic.id;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  TopicScreen(
                      topicId: '6657d49d7dca3271d92245a1')));
        
        }
        else{
          ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ha ocurrido un error.')));
        }
      } else {
        return;
      }
    });

      }

  void deleteTopic() async{
    //confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Desea eliminar el tema?'),
          actions: [
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: Text('Cancelar'),
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
                      Text('Eliminando tema...'),
                    ],
                  ),
                );
              },
  );
        final result = await Connection.deleteTopic(widget.topic.id);

        if (result == 'success'){
          //revisar como hay que pasar el id 
          // ObjectId id = ObjectId.fromHexString(topic.id);
          //final topicId = widget.topic.id;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  TopicScreen(
                      topicId: '6657d49d7dca3271d92245a1')));
        
        }
        else{
          ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ha ocurrido un error.')));
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
        body: FutureBuilder(
          future: _loadTopic(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              //snackbar
              ScaffoldMessenger.of(context).clearSnackBars();
               ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Ha ocurrido un error.')));
              return const Center(
                child: Text('No llego nada'),
              );
            }
          return SingleChildScrollView(
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
                              builder: (context) => const TopicScreen(
                                  topicId: '6657d49d7dca3271d92245a1')));
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
                          'Modificar Tema',
                          style: genieThemeDataDemo.primaryTextTheme.headlineMedium
                        ),
                        
                        //Nombre 
                        TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Nombre del Tema'),
                            
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        
                       
                        
                        TextField(
                          controller: otherLabelController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Etiqueta'),
                          ),
                        ),
                        //Evaluacion
                        Column(
                          children: [
                            // DropdownButtonFormField(
                            //   value: selectedOption,
                            //   items: evaluationLabels
                            //       .map(
                            //         (label) => DropdownMenuItem<String>(
                            //           value: label,
                            //           child: Text(label),
                            //         ),
                            //       )
                            //       .toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       selectedOption = value!;
                            //     });
                            //   },
                            // ),
                            // if (selectedOption == 'OTRO')
                            //   TextField(
                            //     controller: otherLabelController,
                            //     decoration:
                            //         const InputDecoration(label: Text('Agregar ')),
                            //   )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {modifyTopic();},
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff3d7f95))),
                            child: const Text(
                              'Modificar Tema',
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
                              deleteTopic();  // comentado pq no quiero borrar el tema predeterminado jeje
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll( Color.fromARGB(255, 255, 211, 217))),
                            child: const Text(
                              'Eliminar Tema',
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
          );
    })
    );
  }
}
