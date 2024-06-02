import 'package:flutter/material.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/view/screens/modify_study_material.dart';

class TopicCards extends StatelessWidget {
  const TopicCards(
      {super.key, required this.studyMaterial, required this.viewFile, required this.topicId});

  final String topicId; 
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
              color: Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(studyMaterial[i].title),
                          Column(children: [
                            // const Icon(Icons.file_open_outlined),
                            IconButton(onPressed: ( ) {
                              Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  ModifyStudyMaterial(
                                      material: studyMaterial[i],
                                      groupId: topicId,
                                      i: i,
                                    )));

                            }, 
                            icon: const Icon(Icons.more_horiz_outlined))
                          ])
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
