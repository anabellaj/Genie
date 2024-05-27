import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/file_input.dart';
import 'package:genie_app/view/widgets/appbar.dart';

class UploadStudyMaterialScreen extends StatelessWidget {
  UploadStudyMaterialScreen({super.key});
  /*Inputs*/
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Center(
      
      child: Container( // Wrap the body content with Container
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), // Set desired corner radius
        color: Colors.white, 
        boxShadow: [BoxShadow(
          color: Color.fromARGB(255, 172, 174, 188),
          spreadRadius: 1,
          blurRadius: 10,
        )]
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Subir Nuevo Archivo',
                
                style: genieThemeDataDemo.primaryTextTheme.headlineMedium
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(label: Text('Nombre del Archivo')),
                maxLength: 50,
                style: genieThemeDataDemo.textTheme.labelMedium,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(label: Text('Descripción del Archivo')),
                maxLength: 250,
                minLines: 1,
                maxLines: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              FileInput()
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }
}
