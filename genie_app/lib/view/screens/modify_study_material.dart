import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/viewModel/controller.dart';


class ModifyStudyMaterial extends StatefulWidget {
  const ModifyStudyMaterial({super.key, required this.material, required this.topicId, required this.i, required this.group});
  final StudyMaterial material;
  final String topicId;
  final int i;  
  final Groups group;

  @override
  State<ModifyStudyMaterial> createState() => _ModifyStudyMaterial();
}

class _ModifyStudyMaterial extends State<ModifyStudyMaterial> {
  final _titleController = TextEditingController();
  final _descLabelController = TextEditingController();
  late List<String> evaluationLabels;
  var isLoading = true;

  @override
  void initState() {
   
    _titleController.text = widget.material.title;
    _descLabelController.text = widget.material.description;
    super.initState();
  }

   Future<StudyMaterial?> _loadMaterial() async {
    return Controller.loadStudyMaterial(widget.material.id);
  }

  void modifyFile () async {
    if (_titleController.text.isEmpty ||
        _descLabelController.text.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor llene todos los campos.')));
      return;
    }

    String newTitle = _titleController.text;
    String newDesc = _descLabelController.text;
    StudyMaterial newMaterial = StudyMaterial(title: newTitle, description: newDesc);

    //Confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Desea modificar el archivo?'),
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
                      Text('Modificando archivo...'),
                    ],
                  ),
                );
              },
  );
        final result = await Controller.updateFile(newMaterial, widget.material.id, widget.topicId, widget.i);

        if (result == 'success'){
          //revisar como hay que pasar el id 
          
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  TopicScreen(topicId: widget.topicId, group: widget.group)));
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

  void deleteFile() async{
    //confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content:const  Text('¿Desea eliminar el archivo?'),
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
                      Text('Eliminando archivo...'),
                    ],
                  ),
                );
              },
  );
        final result = await Controller.deleteFile(widget.material.id, widget.topicId, widget.i);

        if (result == 'success'){
          //revisar como hay que pasar el id 
          // ObjectId id = ObjectId.fromHexString(topic.id);
          //final topicId = widget.topic.id;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  TopicScreen(topicId: widget.topicId, group: widget.group)));
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
        body: FutureBuilder(
          future: _loadMaterial(),
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
                child: Text('Ha ocurrido un error'),
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
                              builder: (context) =>  TopicScreen(topicId: widget.topicId, group: widget.group)));
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
                          'Modificar Archivo',
                          style: genieThemeDataDemo.primaryTextTheme.headlineMedium
                        ),
                        
                        //Nombre 
                        TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Nombre'),
                            
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        
                       
                        
                        TextField(
                          controller: _descLabelController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Descripcion'),
                          ),
                        ),
                        
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              modifyFile();
                              },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff3d7f95))),
                            child: const Text(
                              'Modificar Archivo',
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
                              'Eliminar Archivo',
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
