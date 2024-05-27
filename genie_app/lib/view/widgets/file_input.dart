import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:genie_app/view/theme.dart';

class FileInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FileInputState();
  }
}

class _FileInputState extends State<FileInput> {
  File? _uploadedFile;
  Widget content = const Text('No hay archivo seleccionado.');

  void openPDF() async {
    // ignore: use_build_context_synchronously
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
    return Column(
      children: [
        content,
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: selectFile, 
            style: ElevatedButton.styleFrom(
              backgroundColor: genieThemeDataDemo.colorScheme.secondary
            ),
            child: const Text(
              'Selecciona un archivo',
              style: TextStyle(
                color: Colors.white,
                
              ),
              ))
      ],
    );
  }
}
