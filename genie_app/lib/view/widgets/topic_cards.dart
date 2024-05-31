import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';

class TopicCards extends StatelessWidget {
  const TopicCards(
      {super.key, required this.studyMaterial, required this.viewFile});

  final List<StudyMaterial> studyMaterial;
  final Function(String id, String title) viewFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < studyMaterial.length; i++)
          GestureDetector(
            onTap: () {
              viewFile(studyMaterial[i].id, studyMaterial[i].title);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(studyMaterial[i].title),
                        const Icon(Icons.file_open_outlined)
                      ],
                    ),
                    Text(studyMaterial[i].description),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
