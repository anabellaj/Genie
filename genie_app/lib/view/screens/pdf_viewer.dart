

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';


class StudyMaterialViewer extends StatefulWidget{

  final String filePath; 
  final String title;

  const StudyMaterialViewer({super.key, required this.filePath, required this.title});

  @override
  State<StudyMaterialViewer> createState()=> _StudyMaterialViewer();
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

        ),
        body: PDFView(
          filePath: widget.filePath,
        ),
      bottomNavigationBar: BottomNavBar());
  }
}