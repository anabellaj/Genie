import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/modify_profile.dart';
import 'package:genie_app/view/screens/search.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/follow_button.dart';
import 'package:genie_app/view/widgets/study_group_profile_card.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {super.key, required this.displayedUser, required this.currentuUser});
  User displayedUser;
  final bool currentuUser;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<int> _friendState;
  late Future<List<Groups>> userStudyGroups;
  List<Groups>? groups;
  late Future<File> _image;

  Future<List<Groups>> getUserGroups() async {
    return Controller.getUserGroupsById(widget.displayedUser);
  }

  Future<int> getFriendState() async {
    return ControllerSocial.checkRequestsFollowing(widget.displayedUser.id);
  }

  Future modifyProfile() async {
    User? changedUser =
        await Navigator.of(context).push<User?>(MaterialPageRoute(
      builder: (context) => const ModifyProfile(),
    ));

    if (changedUser != null) {
      setState(() {
        widget.displayedUser = changedUser;
        _image = changedUser.fileFromBase64String();
      });
    }
  }

  Widget checkExtraData(){
    if(widget.displayedUser.career.isEmpty&&widget.displayedUser.university.isNotEmpty){
      return Text("${widget.displayedUser.university}");
    }
    else if(widget.displayedUser.career.isNotEmpty&&widget.displayedUser.university.isEmpty){
       return Text("${widget.displayedUser.career}");
    }
    else if(widget.displayedUser.career.isNotEmpty&&widget.displayedUser.university.isNotEmpty){
      return Text('${widget.displayedUser.career} | ${widget.displayedUser.university}');
    }else{
      return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    _image = widget.displayedUser.fileFromBase64String();
    userStudyGroups = getUserGroups();
    _friendState =
        ControllerSocial.checkRequestsFollowing(widget.displayedUser.id);
    super.initState();
  }

  @override
  Widget build(context) {
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
                  Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
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

                      checkExtraData(),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.currentuUser)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: genieThemeDataDemo.primaryColor)),
                          onPressed: modifyProfile,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Text('Modificar perfil'),
                          ),
                        )
                      else
                        FutureBuilder(
                            future: _friendState,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ElevatedButton(
                                  onPressed: () {},
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.access_time_outlined),
                                      SizedBox(width: 8),
                                      Text('Cargando'),
                                    ],
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                //snackbar
                                ScaffoldMessenger.of(context).clearSnackBars();
                                return Center(
                                  child: Text(
                                      'Ocurrió un error. ${snapshot.error.toString()}'),
                                );
                              }
                              return FollowButton(
                                  response: snapshot.data!,
                                  followedUserId: widget.displayedUser.id);
                            })
                    ],
                  ),
                  FutureBuilder(
                    future: _image,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('lib/view/assets/no_pp.jpg'),
                        );
                      }
                      if (snapshot.hasError) {
                        //snackbar
                        ScaffoldMessenger.of(context).clearSnackBars();
                        return Center(
                          child: Text(
                              'Ocurrió un error. ${snapshot.error.toString()}'),
                        );
                      }

                      return widget.displayedUser.profilePicture == ""
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('lib/view/assets/no_pp.jpg'),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(snapshot.data!),
                            );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Grupos de estudio'),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: userStudyGroups,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    //snackbar
                    ScaffoldMessenger.of(context).clearSnackBars();
                    return Center(
                      child: Text(
                          'Ocurrió un error. ${snapshot.error.toString()}'),
                    );
                  }
                  groups = snapshot.data!;
                  return Column(
                    children: [
                      for (int i = 0; i < groups!.length; i++)
                        StudyGroupProfileCard(
                            id: widget.displayedUser.studyGroups[i],
                            name: groups![i].name,
                            description: groups![i].description),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
