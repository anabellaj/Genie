import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';

class TopicCards extends StatelessWidget {
  const TopicCards({super.key, required this.study_material});

  final List<StudyMaterial> study_material;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < study_material.length; i++)
          Container(
            width: double.infinity,
            child: Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(study_material[i].title),
                          Icon(Icons.file_open_outlined)
                        ],
                      ),
                      Text(study_material[i].description),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
