import 'package:flutter/material.dart';

class UploadStudyMaterialScreen extends StatefulWidget {
  const UploadStudyMaterialScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UploadStudyMaterialScreenState();
  }
}

class _UploadStudyMaterialScreenState extends State<UploadStudyMaterialScreen> {
  final _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Study Material.'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text('Title')),
          ),
        ],
      ),
    );
  }
}
