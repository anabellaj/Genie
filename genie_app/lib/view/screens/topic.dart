import 'dart:io';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/view/screens/modify_topic.dart';
import 'package:genie_app/view/screens/pdf_viewer.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/topic_display.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/upload_study_material.dart';
import 'package:genie_app/view/widgets/appbar.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key, required this.topicId, required this.group});
  final String topicId;
  final Groups group;

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  var isLoading = false;
  late Future<Topic> activeTopic;
  Topic? staticActiveTopic;
  bool isWaitingForTopic = true;

  @override
  void initState() {
    activeTopic = _loadTopic();
    super.initState();
  }

  void forzarBuild() {
    setState(() {});
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
        builder: (context) => StudyMaterialViewer(
              filePath: file.path,
              title: title,
              fileId: id,
            )));
  }

  Future<Topic> _loadTopic() async {
    Topic loadedTopic = await Controller.loadTopic(widget.topicId);
    return loadedTopic;
  }

  /*Funcion que te permite abrir la pagina de agregar material de estudio recibiendo como parametro el topico que esta creando*/
  void subirArchivo(Topic topic) async {
    StudyMaterial? createdStudyMaterial =
        await Navigator.of(context).push<StudyMaterial?>((MaterialPageRoute(
      builder: (ctx) => UploadStudyMaterialScreen(
        topic: topic,
        group: widget.group,
      ),
    )));

    if (createdStudyMaterial != null) {
      setState(() {
        isWaitingForTopic = false;
      });
      staticActiveTopic!.files.add(createdStudyMaterial);
    }
  }

  void modificarArchivo(Topic topic) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ModifyTopicScreen(
        topic: topic,
        group: widget.group,
        forzarBuild: forzarBuild,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: isWaitingForTopic
            ? FutureBuilder(
                future: activeTopic,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    //snackbar
                    ScaffoldMessenger.of(context).clearSnackBars();
                    return Center(
                      child: Text(
                          'Ocurrió un error. ${snapshot.error.toString()}'),
                    );
                  }
                  staticActiveTopic = snapshot.data!;
                  return TopicDisplay(
                    topic: snapshot.data!,
                    group: widget.group,
                    modificarArchivo: modificarArchivo,
                    subirArchivo: subirArchivo,
                    createPdfFile: createPdfFile,
                    forzarBuild: forzarBuild,
                  );
                })
            : TopicDisplay(
                topic: staticActiveTopic!,
                group: widget.group,
                modificarArchivo: modificarArchivo,
                subirArchivo: subirArchivo,
                createPdfFile: createPdfFile,
                forzarBuild: forzarBuild,
              ),
        bottomNavigationBar: BottomNavBar());
  }
}
