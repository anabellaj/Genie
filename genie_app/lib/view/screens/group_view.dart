import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/create_topic.dart';
import 'package:genie_app/view/screens/forum_list.dart';
import 'package:genie_app/view/screens/home.dart';
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
  late bool isOnlyMember = false;
  late bool isLoading=true;
  late bool isAdmin = false;
  late List<Widget> topics =[];
  void checkAdmin() async{
  bool check = await Controller.checkAdminCurrUser(widget.group.admins[0]);
  if(mounted){
  setState(() {
    isAdmin = check;
  });
  }}
  void getTopics() async {
    List<Widget> r = await Controller.getTopics(widget.group);
    if (mounted) {
      setState(() {
        topics = r;
        isLoading = false;
      });
    }
  }

  void checkMembers(){
    if(widget.group.members.length == 1){
      isOnlyMember = true;
    }
  }

  void leaveGroup() async {
    //confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: isOnlyMember? const Text("Eres el único usuario, ¿Deseas eliminar el grupo?"): const Text('¿Desea salirse del grupo?'),
          actions: [
            ElevatedButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Devuelve true cuando se acepta
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Saliendo del grupo...'),
                ],
              ),
            );
          },
        );
        final result = await Controller.leaveGroup(widget.group);
        if(isOnlyMember){
          Controller.deleteGroup(widget.group);
        }
        if (result == 'success') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen()));
        } else {
          Navigator.of(context)
                    .pop(false);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Ha ocurrido un error.')));

        }
      } else {
        return;
      }
    });
  }
  void deleteGroup() async {
    //confirm dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text("¿Desea eliminar el grupo?"),
          actions: [
            ElevatedButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Devuelve false cuando se cancela
              },
            ),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Devuelve true cuando se acepta
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Saliendo del grupo...'),
                ],
              ),
            );
          },
        );
        
        String result = await Controller.deleteGroup(widget.group);
        if (result == 'success') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen()));
        } else {
          Navigator.of(context)
                    .pop(false);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Ha ocurrido un error.')));

        }
      } else {
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAdmin();
    checkMembers();
    
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
                  Expanded(child: Text(
                    widget.group.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 100,
                    style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
                    textAlign: TextAlign.start,
                  )),
                  isAdmin?
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
                      PopupMenuItem(
                        value: "Salir del Grupo",
                        child: const Text("Salir del Grupo"),
                        onTap: () {
                          leaveGroup();
                        }
                      ),
                      PopupMenuItem(
                        value: "Eliminar Grupo",
                        child: const Text("Eliminar Grupo"),
                        onTap: (){
                          deleteGroup();
                        }
                      )
                    ],
                  ) : PopupMenuButton(
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
                      PopupMenuItem(
                        value: "Salir del Grupo",
                        child: const Text("Salir del Grupo"),
                        onTap: () {
                          leaveGroup();
                        }
                      ),
                    ],
                  )
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
              Padding(padding: EdgeInsets.only(left: 12,right: 12, top: 0, bottom: 18),
                child: Text(widget.group.description, style: genieThemeDataDemo.textTheme.bodySmall, maxLines: 100,),
              ),

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
                        topics.isEmpty?
                        Center(child: Text('No hay temas disponibles', style: TextStyle(color: Color(0xffB4B6BF)),),):
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
