import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/view/widgets/file_input.dart';

class UploadStudyMaterialScreen extends StatelessWidget {
  UploadStudyMaterialScreen({super.key});
  /*Inputs*/
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Study Material.'),
      ),
      body: Padding(
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
                decoration: const InputDecoration(label: Text('Description')),
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
    );
  }
}
