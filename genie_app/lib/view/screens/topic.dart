import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/modify_topic.dart';
import 'package:genie_app/view/screens/pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/upload_study_material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/topic_cards.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key, required this.topicId});
  final String topicId;

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
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('Se esta abriendo el archivo')));
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
            Text('Se está abriendo el archivo...'),
          ],
        ),
      );
    },
  );
    final pdfContent = await Connection.getFileById(id);
    

    final tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/data.pdf');
    await file.writeAsBytes(pdfContent);
    isLoading = false;
    Navigator.of(context).pop(); // Cerrar el diálogo de carga
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context)=>  StudyMaterialViewer(filePath: file.path, title: title)
      
    ));
  }

  Future<Topic> _loadTopic() async {
    return Connection.readTopic(widget.topicId);
  }

  /*Funcion que te permite abrir la pagina de agregar material de estudio recibiendo como parametro el topico que esta creando*/
  void subirArchivo(Topic topic) async {
    Navigator.of(context).push<Map<String, String>>(MaterialPageRoute(
      builder: (ctx) => UploadStudyMaterialScreen(
        topic: topic,
      ),
    ));
  }
   
  void modificarArchivo(Topic topic) async{
    Navigator.of(context).push<Map<String, String>>(MaterialPageRoute(
      builder: (ctx) => ModifyTopicScreen(
        topic: topic,
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
               ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Ha ocurrido un error.')));
              return const Center(
                child: Text('No llego nada'),
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
                      Navigator.pop(context);
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
                          snapshot.data!.name,
                          style: genieThemeDataDemo.textTheme.displayMedium!
                              .copyWith(
                                  fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                            onPressed: () {modificarArchivo(snapshot.data!);},
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
                          color: genieThemeDataDemo.colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))
                              
                              ),
                      child: Text(
                        snapshot.data!.label,
                        style: genieThemeDataDemo.textTheme.headlineLarge!
                            .copyWith(color: Colors.white, fontSize: 14),
                      ),
                    ),
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
                    TopicCards(
                      studyMaterial: snapshot.data!.files,
                      viewFile: (String id, String title) {
                        createPdfFile(id, title);
                      },
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
