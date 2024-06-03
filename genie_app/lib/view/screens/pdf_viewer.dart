

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


class StudyMaterialViewer extends StatefulWidget{

  final String filePath; 
  final String title;
  final String fileId;

  const StudyMaterialViewer({super.key, required this.filePath, required this.title, required this.fileId});

  @override
  State<StudyMaterialViewer> createState()=> _StudyMaterialViewer();
}

// Future<void> downloadPDF(String id) async {
//   try {
//     // Generate the file
//     File pdfFile = await Controller.generateFile(id);

//     // Provide option to save the file
//     final params = SaveFileDialogParams(sourceFilePath: pdfFile.path);
//     final savedPath = await FlutterFileDialog.saveFile(params: params);

//     if (savedPath != null) {
//       print('File saved at $savedPath');
//     } else {
//       print('User cancelled the save dialog');
//     }

//      } catch (e) {
//     print('Error saving file: $e');
//   }
// }

  Future<void> downloadPDF(String id) async {
    try {
      File pdfFile = await Controller.generateFile(id);

    // Get the downloads directory path
     Directory? downloadsDirectory = await getDownloadsDirectory();
    if (downloadsDirectory != null) {
      // Generate a unique file name for the downloads directory
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Copy the file to the downloads directory
      File newFile = File('${downloadsDirectory.path}/$fileName');
      await pdfFile.copy(newFile.path);

      // Delete the original file
      await pdfFile.delete();

      print (newFile.path);
      } else {
        print('Downloads directory not found.');
      }
    } catch (e) {
      print('Error saving file: $e');
    }
  }


class _StudyMaterialViewer extends State<StudyMaterialViewer>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          title: Text(widget.title, style: TextStyle(fontSize: 18),),
          actions: [
         IconButton(
          icon: Icon(Icons.download, color: Colors.white),
          onPressed: () {
            downloadPDF(widget.fileId);
          },
        ),
      ],

        ),
        body: PDFView(
          filePath: widget.filePath,
        ),
      bottomNavigationBar: BottomNavBar());
  }
}