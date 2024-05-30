import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/create_topic.dart';
import 'package:genie_app/view/widgets/file_input.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/theme.dart';

class UploadStudyMaterialScreen extends StatefulWidget {
  const UploadStudyMaterialScreen({super.key, required this.topic});
  final Topic topic;

  @override
  State<UploadStudyMaterialScreen> createState() =>
      _UploadStudyMaterialScreenState();
}

class _UploadStudyMaterialScreenState extends State<UploadStudyMaterialScreen> {
  /*Inputs*/
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _uploadedFile;
  Widget content = const Text('No hay archivo seleccionado.');
  var _isLoading = false;

  void uploadStudyMaterial() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _uploadedFile == null) {
      //TODO: Meter popup
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final pdfContent = await _uploadedFile!.readAsBytes();
    final studyMaterial = StudyMaterial(
        title: _titleController.text,
        description: _descriptionController.text,
        fileContent: pdfContent);
    var result =
        await Connection.addStudyMaterialToTopic(widget.topic, studyMaterial);
    setState(() {
      _isLoading = false;
    });
    if (result == 'success') {
      //Navigator.of(context).pop();
      print('FIN');
      return;
    }
    setState(() {
      _isLoading = false;
    });
    /*TODO: Popup de que algo no salio bien (hazlo con el snackbar que es como esta en el login)*/
  }

  void openPDF() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => Scaffold(
        appBar: AppBar(
          title: Text(_uploadedFile!.path.split('/').last,
              style: const TextStyle(
                fontSize: 18,
              )),
        ),
        body: PDFView(
          filePath: _uploadedFile!.path,
        ),
      ),
    ));
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null) {
      return;
    }

    File file = File(result.files.single.path!);
    setState(() {
      _uploadedFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadedFile != null) {
      content = OutlinedButton(
          onPressed: openPDF,
          child: Text('Ver: ${_uploadedFile!.path.split('/').last}'));
    }
    return Scaffold(
      appBar: TopBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
            const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateTopicScreen()));
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
                    borderRadius: BorderRadius.circular(
                        20.0), // Set desired corner radius
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('Subir Nuevo Archivo',
                            style: genieThemeDataDemo
                                .primaryTextTheme.headlineMedium),
                        TextField(
                          controller: _titleController,
                          decoration:
                              const InputDecoration(label: Text('Título')),
                          maxLength: 50,
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(label: Text('Descripción')),
                          maxLength: 250,
                          minLines: 1,
                          maxLines: 5,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        content,
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: selectFile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  genieThemeDataDemo.colorScheme.primary,
                              elevation: 10.0, // Adjust shadow elevation
                              shadowColor:
                                  const Color.fromARGB(255, 118, 115, 115)
                                      .withOpacity(0.5), // Set shadow color
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 90),
                              child: Text(
                                'Seleccionar Archivo',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                            onPressed: uploadStudyMaterial,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    genieThemeDataDemo.colorScheme.secondary),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100),
                              child: Text(
                                'Guardar Archivo',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
    );
  }
}
