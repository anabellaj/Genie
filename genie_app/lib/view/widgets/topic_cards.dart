import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/view/screens/modify_study_material.dart';
import 'package:genie_app/view/theme.dart';

class TopicCards extends StatelessWidget {
  const TopicCards(
      {super.key,
      required this.studyMaterial,
      required this.viewFile,
      required this.topicId,
      required this.group});

  final String topicId;
  final Groups group;
  final List<StudyMaterial> studyMaterial;
  final Function(String id, String title) viewFile;

  @override
  Widget build(BuildContext context) {
    return studyMaterial.isEmpty
        ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nadie ha añadido archivos...'),
                Text('¡Sé el primero!'),
              ],
            ),
          )
        : Column(
            children: [
              for (int i = 0; i < studyMaterial.length; i++)
                GestureDetector(
                  onTap: () {
                    viewFile(studyMaterial[i].id, studyMaterial[i].title);
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: Text(
                                  studyMaterial[i].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: genieThemeDataDemo
                                      .primaryTextTheme.titleLarge,
                                ),
                              ),
                              Column(children: [
                                // const Icon(Icons.file_open_outlined),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ModifyStudyMaterial(
                                                    material: studyMaterial[i],
                                                    topicId: topicId,
                                                    i: i,
                                                    group: group,
                                                  )));
                                    },
                                    icon: const Icon(Icons.more_horiz_outlined))
                              ])
                            ],
                          ),
                          Text(
                            studyMaterial[i].description,
                            maxLines: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}
