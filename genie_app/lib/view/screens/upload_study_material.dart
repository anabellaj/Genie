import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/widgets/file_input.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';

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
  Widget content = const Text('No file selected.');
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
          title: Text(_uploadedFile!.path.split('/').last),
        ),
        body: PDFView(
          filePath: _uploadedFile!.path,
        ),
      ),
    ));
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
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
          child: Text('Preview ${_uploadedFile!.path.split('/').last}'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Study Material.'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(label: Text('Title')),
                      maxLength: 50,
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(label: Text('Description')),
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
                        child: const Text('Select a file')),
                    ElevatedButton(
                        onPressed: uploadStudyMaterial,
                        child: const Text('Save File')),
                  ],
                ),
              ),
            ),
    );
  }
}
