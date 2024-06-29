import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/study_group_profile_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {super.key, required this.displayedUser, required this.currentuUser});
  User displayedUser;
  final bool currentuUser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(context) {
    File imageFile = widget.displayedUser.fileFromBase64String();
    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.displayedUser.name[0].toUpperCase()}${widget.displayedUser.name.substring(1).toLowerCase()}',
                        style:
                            genieThemeDataDemo.textTheme.displayLarge!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.displayedUser.username,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                          '${widget.displayedUser.career} | ${widget.displayedUser.university}'),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.currentuUser)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: genieThemeDataDemo.primaryColor)),
                          onPressed: () async {
                            User? changedUser = await Navigator.of(context)
                                .push<User?>(MaterialPageRoute(
                              builder: (context) => const ModifyProfile(),
                            ));
                            if (changedUser != null) {
                              setState(() {
                                widget.displayedUser = changedUser;
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Text('Modificar perfil'),
                          ),
                        )
                      else
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: genieThemeDataDemo.primaryColor)),
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Text('Amigos'),
                          ),
                        ),
                    ],
                  ),
                  widget.displayedUser.profilePicture == ""
                      ? const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('lib/view/assets/no_pp.jpg'),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(imageFile),
                        ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Grupos de estudio'),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0; i < widget.displayedUser.studyGroups.length; i++)
                StudyGroupProfileCard(
                    id: /*displayedUser.studyGroups[i]['id']*/
                        widget.displayedUser.studyGroups[i],
                    name: /*displayedUser.studyGroups[i]['name']*/ 'Nombre $i',
                    description: /*displayedUser.studyGroups[i]['description']*/
                        'Descripcion $i'),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
