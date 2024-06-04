import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:path_provider/path_provider.dart';
import '../theme.dart';




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

  Future<String> downloadPDF(String id) async {
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
      return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }


class _StudyMaterialViewer extends State<StudyMaterialViewer>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.of(context).pop();
            } 
          ), 
          title: Text(widget.title, style: TextStyle(fontSize: 18),),
          actions: [
         IconButton(
          icon: const Icon(Icons.download, color: Colors.white),
          onPressed: ()async {
            String res = await downloadPDF(widget.fileId);
            if(res=='success'){
              ScaffoldMessenger.of(context).showMaterialBanner(
                MaterialBanner(
                                        backgroundColor: genieThemeDataDemo.colorScheme.secondary,
                                        contentTextStyle: TextStyle(
                                          color: genieThemeDataDemo.colorScheme.onSecondary,
                                          fontSize: 12
                                        ),
                                        content: const Text("Archivo descargado"), 
                                        actions: [IconButton(
                                          onPressed: ()=>
                                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
                                            icon: Icon(Icons.check, color: genieThemeDataDemo.colorScheme.onSecondary,))])
              );
            }else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('Hubo un error')));
            }
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