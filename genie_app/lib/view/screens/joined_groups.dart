import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/add_group.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class JoinedGroups extends StatefulWidget{
  const JoinedGroups({super.key});

  @override
  State<JoinedGroups> createState() => _JoinedGroupsState();
}

class _JoinedGroupsState extends State<JoinedGroups> {

  late bool isLoading = true;
  late Widget groups;

  void getGroups() async{
    Widget g = await Controller.getUserGroups();
    if(mounted){
    setState(() {
      groups = g;
      isLoading = false;
    });
    }
  }
  @override 
    void initState(){
      super.initState();
      getGroups();
    }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body:  isLoading?
                    const Center(child: CircularProgressIndicator()):

              Column(children: [Expanded(child: groups)]),
    );

  }
}