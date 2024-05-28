import 'package:flutter/material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/topic_cards.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              topic.name,
              style: genieThemeDataDemo.textTheme.headlineLarge!
                  .copyWith(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: genieThemeDataDemo.colorScheme.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text(
                topic.label,
                style: genieThemeDataDemo.textTheme.headlineLarge!
                    .copyWith(color: Colors.white, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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
    );
  }
}
