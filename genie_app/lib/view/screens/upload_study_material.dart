import 'dart:io';
import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/models/group.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/viewModel/controller.dart';

class UploadStudyMaterialScreen extends StatefulWidget {
  const UploadStudyMaterialScreen({super.key, required this.topic, required this.group});
  final Topic topic;
  final Groups group;

  @override
  State<UploadStudyMaterialScreen> createState() =>
      _UploadStudyMaterialScreenState();
}

class _UploadStudyMaterialScreenState extends State<UploadStudyMaterialScreen> {
  /*Inputs*/
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _uploadedFile;
  Widget content = const Text('No hay archivo seleccionado.', style: TextStyle(fontSize: 14, color: Color(0xffB4B6BF)),);
  var _isLoading = false;

  void uploadStudyMaterial() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _uploadedFile == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor llene todos los campos.')));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final pdfContent = await _uploadedFile!.readAsBytes();
    final studyMaterial = StudyMaterial(
      title: _titleController.text,
      description: _descriptionController.text,
    );
    var result = await Controller.addNewMaterial(
        widget.topic, studyMaterial, pdfContent);
    setState(() {
      _isLoading = false;
    });
    if (result == 'success') {
      
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>  TopicScreen(topicId: widget.topic.id, group: widget.group,)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ha ocurrido un error')));  //Popup de que algo no salio bien 

    setState(() {
      _isLoading = false;
    });
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
          : SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  TopicScreen(topicId: widget.topic.id, group: widget.group,)));
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
                          20.0), 
                      color: Colors.white,
                      boxShadow:  [
                        BoxShadow(
                          color:  genieThemeDataDemo.colorScheme.onSurface.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 12,
                          offset: const Offset(0, 3)
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
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _titleController,
                            decoration:
                                 InputDecoration(
                                  hintText: 'Título',
                                  enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.secondary
                                          ),
                                        
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary
                                          ),
                                  ),),
                            maxLength: 50,
                          ),
                          TextField(
                            controller: _descriptionController,
                            decoration:
                                 InputDecoration(
                                  hintText: 'Descripción',
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
                            maxLength: 250,
                            minLines: 1,
                            maxLines: 5,
                          ),
                          
                          content,
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selectFile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    genieThemeDataDemo.colorScheme.primary,
                                
                              ),
                              child:  Text(
                                  'Seleccionar Archivo',
                                  style: TextStyle(color:genieThemeDataDemo.colorScheme.onPrimary),
                                ),
                              ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: uploadStudyMaterial,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      genieThemeDataDemo.colorScheme.secondary),
                              child: 
                               Text(
                                  'Guardar Archivo',
                                  style: TextStyle(
                                    color: genieThemeDataDemo.colorScheme.onPrimary,
                                  ),
                                ),
                              ),)
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
          ),
    );
  }
}
