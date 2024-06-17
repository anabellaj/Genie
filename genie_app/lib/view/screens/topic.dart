import 'dart:io';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/modify_topic.dart';
import 'package:genie_app/view/screens/pdf_viewer.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/percent_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/models/group.dart';

import 'package:genie_app/view/screens/upload_study_material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/topic_cards.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key, required this.topicId, required this.group});
  final String topicId;
  final Groups group;

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  var isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void createPdfFile(String id, String title) async {
    if (isLoading == true) return;
    isLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text('Se está abriendo el archivo...'),
            ],
          ),
        );
      },
    );
    File file = await Controller.generateFile(id);
    isLoading = false;

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Cerrar el diálogo de carga

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            StudyMaterialViewer(filePath: file.path, title: title, fileId: id,)));
  }

  Future<Topic> _loadTopic() async {
    return Controller.loadTopic(widget.topicId);
  }

  /*Funcion que te permite abrir la pagina de agregar material de estudio recibiendo como parametro el topico que esta creando*/
  void subirArchivo(Topic topic) async {
    Navigator.of(context).push<Map<String, String>>(MaterialPageRoute(
      builder: (ctx) => UploadStudyMaterialScreen(
        topic: topic,
        group: widget.group,
      ),
    ));
  }

  void modificarArchivo(Topic topic) async {
    Navigator.of(context).push<Map<String, String>>(MaterialPageRoute(
      builder: (ctx) => ModifyTopicScreen(
        topic: topic,
        group: widget.group,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: FutureBuilder(
            future: _loadTopic(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                //snackbar
                ScaffoldMessenger.of(context).clearSnackBars();
                return Center(
                  child: Text('Ocurrió un error. ${snapshot.error.toString()}'),
                );
              }
              return Padding(
                  padding: const EdgeInsets.all(27.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GroupView(group: widget.group)));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chevron_left,
                                  color:
                                      genieThemeDataDemo.colorScheme.secondary,
                                ),
                                Text(
                                  'Regresar',
                                  style: TextStyle(
                                      color: genieThemeDataDemo
                                          .colorScheme.secondary),
                                )
                              ],
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(
                              snapshot.data!.name,
                              maxLines: 100,
                              style: genieThemeDataDemo.textTheme.displayMedium!
                                  .copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700),
                            ),),
                            IconButton(
                                onPressed: () {
                                  modificarArchivo(snapshot.data!);
                                },
                                icon: const Icon(Icons.more_horiz))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: snapshot.data!.label.isEmpty ? Colors.white : genieThemeDataDemo.colorScheme.secondary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            snapshot.data!.label,
                            style: genieThemeDataDemo.textTheme.headlineLarge!
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PercentBar(percent: 70, group: widget.group, topicId: widget.topicId,),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              subirArchivo(snapshot.data!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  genieThemeDataDemo.colorScheme.primary,
                            ),
                            child: const Text(
                              'Subir archivo',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TopicCards(
                          studyMaterial: snapshot.data!.files,
                          viewFile: (String id, String title) {
                            createPdfFile(id, title);
                          },
                          topicId: snapshot.data!.id,
                          group: widget.group,
                        )
                      ],
                    ),
                  ));
            }),
        bottomNavigationBar: BottomNavBar());
  }
}
