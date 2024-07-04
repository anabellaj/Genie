import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class StudyGroupProfileCard extends StatefulWidget {
  const StudyGroupProfileCard(
      {super.key,
      required this.id,
      required this.name,
      required this.description,
      required this.userIsPartOfTheGroup});

  final String id;
  final String name;
  final String description;
  final bool userIsPartOfTheGroup;

  @override
  State<StudyGroupProfileCard> createState() => _StudyGroupProfileCardState();
}

class _StudyGroupProfileCardState extends State<StudyGroupProfileCard> {
  bool isSolicited = false;
  bool hidden = true;
  void checkRequests() async {
    bool x = await Controller.checkIfUserInRequests(widget.id);
    setState(() {
      isSolicited = x;
      hidden = false;
    });
  }

  @override
  void initState() {
    checkRequests();
    super.initState();
  }

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
            if (!widget.userIsPartOfTheGroup)
              hidden
                  ? const SizedBox()
                  : !isSolicited
                      ? Tooltip(
                          message: "Solicitar unirse",
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                isSolicited = true;
                              });
                              Controller.sendJoinRequest(widget.id);
                            },
                            icon: const Icon(Icons.person_add_alt_1,
                                color: Colors.blue),
                          ),
                        )
                      : const Tooltip(
                          message: "¡Solicitud enviada!",
                          child: Icon(Icons.person_add_alt_1))
          ],
        ),
      ),
    );
  }
}
