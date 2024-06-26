import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/topic.dart';
import '../theme.dart';

class Tabs extends StatefulWidget {
  final Widget fichasContent;
  final Widget pruebasContent;
  final Groups group;
  final String topicId;
  const Tabs(
      {super.key,
      required this.fichasContent,
      required this.pruebasContent,
      required this.group,
      required this.topicId});

  @override
  // ignore: library_private_types_in_public_api
  _TapBarState createState() => _TapBarState();
}

class _TapBarState extends State<Tabs> {
  late bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(children: [
          const SizedBox(height: 12.0),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TopicScreen(
                            topicId: widget.topicId,
                            group: widget.group))); //CAMBIAR ROUTE A group_menu
              },
              child: Row(children: [
                Icon(
                  Icons.chevron_left,
                  color: genieThemeDataDemo.colorScheme.secondary,
                ),
                Text(
                  'Regresar',
                  style: TextStyle(
                      color: genieThemeDataDemo.colorScheme.secondary),
                )
              ])),
          const SizedBox(height: 12.0),
          TabBar(
            indicator: BoxDecoration(color: Colors.transparent),
            dividerColor: Colors.transparent,
            dividerHeight: 2.0,
            tabs: [
              Tab(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                  decoration: BoxDecoration(
                    color: genieThemeDataDemo.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    // alignment: Alignment.center,
                    child: Text(
                      'Fichas',
                      style: genieThemeDataDemo.primaryTextTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: double.infinity,
                  // padding:
                  //     const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: genieThemeDataDemo.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    // alignment: Alignment.center,
                    child: Text(
                      'Pruebas',
                      style: genieThemeDataDemo.primaryTextTheme.bodyMedium,
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              Container(width: double.infinity, child: widget.fichasContent),
              Container(width: double.infinity, child: widget.pruebasContent)
            ]),
          )
        ]));
  }
}
