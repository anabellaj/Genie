import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/theme.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() {
    return _CreateTopicScreenState();
  }
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final otherLabelController = TextEditingController();
  late List<String> evaluationLabels;
  var isLoading = true;
  late String selectedOption;

  void _saveTopic() async {
    print('Entre');
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      //TODO: Meter popup de que el campo es requerido
      return;
    }
    print('PASE 1');
    if (selectedOption == 'OTRO') {
      for (var label in evaluationLabels) {
        if (label.toUpperCase() == otherLabelController.text) {
          //TODO: Poner popup de que el label ya existe
          return;
        }
      }
    }
    print('PASE 2');
    final topic = Topic(
        name: _titleController.text,
        description: _descriptionController.text,
        label: selectedOption,
        files: []);
    setState(() {
      isLoading = true;
    });
    final result = await Connection.createTopic(topic);
    setState(() {
      isLoading = false;
    });
    if (result == 'succes') {
      Navigator.of(context).pop<Topic>();
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ocurrió un error intenta de nuevo más tarde.')));
    }
    print(result);
  }

  @override
  void initState() {
    evaluationLabels = ['hola'];
    evaluationLabels.add('OTRO');
    setState(() {
      selectedOption = evaluationLabels.first;
      isLoading = false;
    });

    super.initState();
  }

  late Widget content;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Crear Tema',
                    style: genieThemeDataDemo.textTheme.titleLarge!
                        .copyWith(fontSize: 36, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text('Nombre del Tópico'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    minLines: 1,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      label: Text('Descripción'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      DropdownButtonFormField(
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
                      if (selectedOption == 'Otro')
                        TextField(
                          controller: otherLabelController,
                          decoration:
                              const InputDecoration(label: Text('Add new ')),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTopic,
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xff3d7f95))),
                      child: const Text(
                        'Crear Tema',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear Tópico'),
        ),
        body: content);
  }
}
