import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/create_topic.dart';
import 'package:genie_app/view/screens/forum_list.dart';
import 'package:genie_app/view/screens/joined_groups.dart';
import 'package:genie_app/view/screens/members_view.dart';
import 'package:genie_app/view/screens/modify_group.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import '../theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class AlignedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AlignedText({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0), // Adjust padding as needed
      child: Text(text // Use provided style or default
          ),
    );
  }
}

class GroupView extends StatefulWidget {
  final Groups group;
  const GroupView({super.key, required this.group});

  @override
  // ignore: library_private_types_in_public_api
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  late bool isLoading=true;
  late List<Widget> topics =[];

  void getTopics() async {
    List<Widget> r = await Controller.getTopics(widget.group);
    if (mounted) {
      setState(() {
        topics = r;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // boton de regresar
              TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const JoinedGroups())); //CAMBIAR ROUTE A group_menu
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

              // titulo principal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.group.name,
                    overflow: TextOverflow.ellipsis,
                    style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
                    textAlign: TextAlign.start,
                  ),
                  PopupMenuButton(
                    child: const Icon(Icons.more_horiz_outlined),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "Modificar Grupo",
                        child: const Text("Modificar Grupo"),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModifyGroupPage(
                                      currentGroup: widget.group)));
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12.0),

              // miembros
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(
                        "Miembros: ${widget.group.members.length}", // SACAR DE LA BASE DE DATOS
                        style: genieThemeDataDemo.textTheme.displayMedium),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MembersView(
                                    group: widget
                                        .group))); //CAMBIAR ROUTE A members_view
                      },
                      style: linkButtonStyle,
                      child: const AlignedText(text: 'Ver miembros'),
                    ),
                  ]),

                  //boton discutir
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForumsListPage(
                                    groupId: widget.group,
                                  ))); //CAMBIAR ROUTE A foro
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: genieThemeDataDemo.colorScheme.secondary,
                      foregroundColor: genieThemeDataDemo.colorScheme.onPrimary,
                      textStyle: genieThemeDataDemo.textTheme.bodyMedium,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Discutir'),
                  )
                ],
              ),
              const SizedBox(height: 12.0),

              //boton crear nuevo tema
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateTopicScreen(
                                                group: widget.group,
                                              ))); //CAMBIAR ROUTE A create_topic
                                },
                                style: mainButtonStyle,
                                child: const Text('Crear nuevo tema'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          children: [...topics],
                        )
                      ],
                    ),

              // GENERADO PARA CADA TEMA
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
