import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key, required this.group});
  final Groups group;

  @override
  State<CreateTopicScreen> createState() {
    return _CreateTopicScreenState();
  }
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _titleController = TextEditingController();
  final otherLabelController = TextEditingController();
  late List<String> evaluationLabels;
  var isLoading = true;
  var labelExists = true;
  late String selectedOption;

  void _saveTopic() async {
    labelExists = true;
    print('Entre');
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor llene todos los campos')));
      return;
    }
    print('PASE 1');
    if (selectedOption == 'Agregar nueva etiqueta') {
      if (otherLabelController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Debe ponerle un nombre a la etiqueta.')));
        return;
      }
      for (var label in evaluationLabels) {
        if (label.toUpperCase() == otherLabelController.text) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('La etiqueta ingresada ya existe. ')));
          return;
        }
      }
      labelExists = false;
    }
    print('PASE 2');
    final topic = Topic(
        name: _titleController.text,
        label: otherLabelController.text,
        files: []);
    setState(() {
      isLoading = true;
    });
    print(topic);
    final result =
        await Controller.postTopic(topic, widget.group, labelExists);
    setState(() {
      isLoading = false;
    });
    if (result == 'success') {
      if (!labelExists) widget.group.labels.add(otherLabelController.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GroupView(group: widget.group)));
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Ha ocurrido un error, por favor intenta de nuevo más tarde.')));
    }
    print(result);
  }

  @override
  void initState() {
    evaluationLabels = List<String>.from(widget.group.labels);
    evaluationLabels.add('Agregar nueva etiqueta');
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
      content = SingleChildScrollView(
          child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: () {
              // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupView(
                            group: widget.group,
                          )));
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
                    Text('Crear Tema',
                        style:
                            genieThemeDataDemo.primaryTextTheme.headlineMedium),
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Nombre del Tópico'),
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
                        if (selectedOption == 'Agregar nueva etiqueta')
                          TextField(
                            controller: otherLabelController,
                            decoration:
                                const InputDecoration(label: Text('Agregar ')),
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
        ),
      ]));
    }
    return Scaffold(
        appBar: TopBar(), body: content, bottomNavigationBar: BottomNavBar());
  }
}
