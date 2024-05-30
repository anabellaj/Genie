import 'package:flutter/material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/upload_study_material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/topic_cards.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    /*Funcion que te permite abrir la pagina de agregar material de estudio recibiendo como parametro el topico que esta creando*/
    void subirArchivo(Topic topic) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => UploadStudyMaterialScreen(
          topic: topic,
        ),
      ));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topic.name,
                    style: genieThemeDataDemo.textTheme.headlineLarge!
                        .copyWith(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: genieThemeDataDemo.colorScheme.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(
                  topic.label,
                  style: genieThemeDataDemo.textTheme.headlineLarge!
                      .copyWith(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
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
              TopicCards(study_material: topic.files)
            ],
          ),
        ),
      ),
    );
  }
}
