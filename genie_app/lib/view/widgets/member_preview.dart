import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class MemberPreview extends StatefulWidget{
  final User member;
  final String name;

  const MemberPreview({super.key, required this.name, required this.member});

  @override
  State<MemberPreview> createState() => _MemberPreviewState();
}

class _MemberPreviewState extends State<MemberPreview> {
  
  late bool isAdmin = false;

  void checkAdmin() async{
    //bool response = await Controller.checkAdmin();
    setState(() {
      isAdmin = true;
    });
  }

  void initState(){
    super.initState();
    checkAdmin();
  }
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide( color: genieThemeDataDemo.colorScheme.primary, width: 2))
        ), 
          child: Stack(
            children: [ const SizedBox(height: 10),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.member.id,
                          overflow: TextOverflow.ellipsis,
                          style: genieThemeDataDemo.primaryTextTheme.titleLarge),
                         ],
                    ),
                          
                  ],),
                ),
              ),
            ],
          ),
        ),
      )
      );

  }
}