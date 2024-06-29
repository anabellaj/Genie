import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class StudyGroupProfileCard extends StatelessWidget {
  const StudyGroupProfileCard(
      {super.key,
      required this.id,
      required this.name,
      required this.description});
  final String id;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shadowColor: genieThemeDataDemo.colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.start,
                ),
                Text(
                  description,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1),
            )
          ],
        ),
      ),
    );
  }
}
