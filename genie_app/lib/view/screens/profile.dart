import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/study_group_profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(
      {super.key, required this.displayedUser, required this.currentuUser});
  final User displayedUser;
  final bool currentuUser;

  @override
  Widget build(context) {
    File _imageFile = displayedUser.fileFromBase64String();
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
                        '${displayedUser.name[0].toUpperCase()}${displayedUser.name.substring(1).toLowerCase()}',
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
                        displayedUser.username,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                          '${displayedUser.career} | ${displayedUser.university}'),
                      const SizedBox(
                        height: 10,
                      ),
                      if (currentuUser)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: genieThemeDataDemo.primaryColor)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ModifyProfile(),
                            ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Text('Modificar perfil'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: genieThemeDataDemo.primaryColor)),
                        onPressed: () {},
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          child: Text('Amigos'),
                        ),
                      ),
                    ],
                  ),
                  displayedUser.profilePicture == ""
                      ? const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('lib/view/assets/no_pp.jpg'),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(_imageFile!),
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
              for (int i = 0; i < displayedUser.studyGroups.length; i++)
                StudyGroupProfileCard(
                    id: /*displayedUser.studyGroups[i]['id']*/
                        displayedUser.studyGroups[i],
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
