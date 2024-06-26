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
      required this.group,
      required this.forzarBuild});

  final String topicId;
  final Groups group;
  final List<StudyMaterial> studyMaterial;
  final Function(String id, String title) viewFile;
  final Function forzarBuild;

  void modificarArchivo(BuildContext context, int i) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ModifyStudyMaterial(
                  material: studyMaterial[i],
                  topicId: topicId,
                  i: i,
                  group: group,
                  studyMaterialList: studyMaterial,
                )));
    forzarBuild();
  }

  @override
  Widget build(BuildContext context) {
    return studyMaterial.isEmpty
        ? const Center(
            child: Column(
              children: [
                Text('No hay archivos publicados',
                    style: TextStyle(color: Color(0xffB4B6BF))),
                Text("¡Sé el primero!",
                    style: TextStyle(color: Color(0xffB4B6BF)))
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
                    shadowColor: genieThemeDataDemo.colorScheme.onSurface,
                    elevation: 4,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    studyMaterial[i].title,
                                    maxLines: 100,
                                    style: genieThemeDataDemo
                                        .primaryTextTheme.titleLarge,
                                  ),
                                ),
                                Column(children: [
                                  IconButton(
                                      onPressed: () {
                                        modificarArchivo(context, i);
                                      },
                                      icon:
                                          const Icon(Icons.more_horiz_outlined))
                                ])
                              ],
                            ),
                            Text(
                              studyMaterial[i].description,
                              style: genieThemeDataDemo.textTheme.displayMedium,
                              maxLines: 100,
                            ),
                          ]),
                    ),
                  ),
                )
            ],
          );
  }
}
