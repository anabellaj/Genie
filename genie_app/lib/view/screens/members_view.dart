import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/code.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import '../theme.dart';
// import 'package:genie_app/view/screens/modify_profile.dart';

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

class MembersView extends StatelessWidget {
  final Groups group;
  const MembersView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(12.0),
              color: genieThemeDataDemo.colorScheme.secondary,
              child: Column(children: [
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupView(group: group))); //CAMBIAR ROUTE A group_menu
                    },
                    child: Row(children: [
                      Icon(
                        Icons.chevron_left,
                        color: genieThemeDataDemo.colorScheme.onPrimary,
                      ),
                      Text(
                        'Regresar',
                        style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.onPrimary),
                      )
                    ])),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Miembros",
                        style:
                            genieThemeDataDemo.primaryTextTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       CodePage(group: group))); //CAMBIAR ROUTE A foro
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              genieThemeDataDemo.colorScheme.surface,
                          foregroundColor:
                              genieThemeDataDemo.colorScheme.secondary,
                          textStyle: genieThemeDataDemo.textTheme.bodyMedium,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: const Text('Invitar'),
                      )
                    ])
              ])),
          Container(
              padding: const EdgeInsets.all(12.0),
              color: genieThemeDataDemo.colorScheme.surface,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Miembro 1",
                              style: genieThemeDataDemo.textTheme.displayLarge),
                          const Icon(Icons.delete)
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Miembro 2",
                              style: genieThemeDataDemo.textTheme.displayLarge),
                          const Icon(Icons.delete_outline)
                        ],
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}