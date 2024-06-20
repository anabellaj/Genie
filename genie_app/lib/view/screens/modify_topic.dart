import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';

class ModifyTopicScreen extends StatefulWidget {
  const ModifyTopicScreen(
      {super.key,
      required this.topic,
      required this.group,
      required this.forzarBuild});
  final Topic topic;
  final Groups group;
  final Function forzarBuild;

  @override
  State<ModifyTopicScreen> createState() => _ModifyTopicScreen();
}

class _ModifyTopicScreen extends State<ModifyTopicScreen> {
  final _titleController = TextEditingController();
  final otherLabelController = TextEditingController();
  late List<String> evaluationLabels;
  var isLoading = true;
  var labelExists = true;
  late String selectedOption;

  @override
  void initState() {
    evaluationLabels = List<String>.from(widget.group.labels);
    evaluationLabels.add('Agregar nueva etiqueta');
    _titleController.text = widget.topic.name;
    selectedOption = widget.topic.label;

    super.initState();
  }

  void modifyTopic() async {
    labelExists = true;
    var label = selectedOption;
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor llene todos los campos')));
      return;
    }
    if (selectedOption == 'Agregar nueva etiqueta') {
      if (otherLabelController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Debe ponerle un nombre a la etiqueta.')));
        return;
      }
      for (var label in evaluationLabels) {
        if (label.toUpperCase() ==
            otherLabelController.text.toUpperCase().trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('La etiqueta ingresada ya existe. ')));
          return;
        }
      }
      label = otherLabelController.text;
      labelExists = false;
    }
    Topic newTopic = Topic(
        name: _titleController.text,
        label: label,
        files: widget.topic.files,
        flashCards: widget.topic.flashCards);

    //Confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Desea modificar el tema?'),
          actions: [
            ElevatedButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Devuelve true cuando se acepta
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
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
        final result = await Controller.updateTopic(
            newTopic, widget.topic, labelExists, widget.group);

        if (result == 'success') {
          if (!labelExists) widget.group.labels.add(label);
          widget.topic.name = newTopic.name;
          widget.topic.label = newTopic.label;
          widget.forzarBuild();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ha ocurrido un error.')));
        }
      } else {
        return;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    otherLabelController.dispose();
    super.dispose();
  }

  void deleteTopic() async {
    //confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Desea eliminar el tema?'),
          actions: [
            ElevatedButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Devuelve true cuando se acepta
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
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
        final result = await Controller.deleteTopic(widget.topic.id);

        if (result == 'success') {
          //revisar como hay que pasar el id
          // ObjectId id = ObjectId.fromHexString(topic.id);
          //final topicId = widget.topic.id;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupView(group: widget.group)));
        } else {
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
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),

          // Boton de Regresar
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Modificar Tema',
                            style: genieThemeDataDemo
                                .primaryTextTheme.headlineMedium),

                        //Nombre
                        TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: InputDecoration(
                              hintText: 'Nombre del Tema',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Evaluacion
                        Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  helperText: 'Agrega una etiqueta al tema',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )),
                              value: selectedOption,
                              items: evaluationLabels
                                  .map(
                                    (label) => DropdownMenuItem<String>(
                                      value: label,
                                      child: Text(label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              },
                            ),
                            if (selectedOption == 'Agregar nueva etiqueta')
                              TextField(
                                controller: otherLabelController,
                                decoration: const InputDecoration(
                                    label: Text('Agregar ')),
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              modifyTopic();
                            },
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
                              deleteTopic();
                            },
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Color.fromARGB(255, 255, 211, 217))),
                            child: const Text(
                              'Eliminar Tema',
                              style: TextStyle(color: Color(0xffC5061D)),
                            ),
                          ),
                        )
                      ], //children de columna
                    ),
                  ))))
        ])),
        bottomNavigationBar: BottomNavBar());
  }
}
