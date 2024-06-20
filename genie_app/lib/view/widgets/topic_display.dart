import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/percent_bar.dart';
import 'package:genie_app/view/widgets/topic_cards.dart';

class TopicDisplay extends StatelessWidget {
  const TopicDisplay(
      {super.key,
      required this.topic,
      required this.group,
      required this.modificarArchivo,
      required this.subirArchivo,
      required this.createPdfFile,
      required this.forzarBuild});
  final Topic topic;
  final Groups group;
  final Function(Topic topic) modificarArchivo;
  final Function(Topic topic) subirArchivo;
  final Function(String id, String title) createPdfFile;
  final Function forzarBuild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(27.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  //TODO: MEJORAR ESTO
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupView(group: group)));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: genieThemeDataDemo.colorScheme.secondary,
                    ),
                    Text(
                      'Regresar',
                      style: TextStyle(
                          color: genieThemeDataDemo.colorScheme.secondary),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topic.name,
                  overflow: TextOverflow.ellipsis,
                  style: genieThemeDataDemo.textTheme.displayMedium!
                      .copyWith(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                IconButton(
                    onPressed: () {
                      modificarArchivo(topic);
                    },
                    icon: const Icon(Icons.more_horiz)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: topic.label.isEmpty
                      ? Colors.white
                      : genieThemeDataDemo.colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(
                topic.label,
                style: genieThemeDataDemo.textTheme.headlineLarge!
                    .copyWith(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PercentBar(
              percent: topic.percent,
              group: group,
              topicId: topic.id,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  subirArchivo(topic);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: genieThemeDataDemo.colorScheme.primary,
                ),
                child: const Text(
                  'Subir archivo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TopicCards(
              studyMaterial: topic.files,
              viewFile: (String id, String title) {
                createPdfFile(id, title);
              },
              topicId: topic.id,
              group: group,
              forzarBuild: forzarBuild,
            )
          ],
        ),
      ),
    );
  }
}
