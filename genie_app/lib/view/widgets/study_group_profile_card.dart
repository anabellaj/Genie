import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class StudyGroupProfileCard extends StatefulWidget {
  const StudyGroupProfileCard(
      {super.key,
      required this.id,
      required this.name,
      required this.description});
  
  final String id;
  final String name;
  final String description;

  @override
  State<StudyGroupProfileCard> createState() => _StudyGroupProfileCardState();
}

class _StudyGroupProfileCardState extends State<StudyGroupProfileCard> {
  bool isSolicited = false;
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
                  widget.name,
                  textAlign: TextAlign.start,
                ),
                Text(
                  widget.description,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            !isSolicited ?
            Tooltip(
                message: "Solicitar unirse",
                child: IconButton(
                  onPressed: () {
                    print(widget.id);
                    setState(() {
                      isSolicited = true;
                    });
                    
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                ),
              ):
            const Tooltip(message: "¡Solicitud enviada!", child: const Icon(Icons.person_add_alt_1, color: Colors.blue,))
            
          ],
        ),
      ),
    );
  }
}
