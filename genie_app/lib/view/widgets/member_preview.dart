import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class MemberPreview extends StatefulWidget{
  final User member;
  final Groups group;
  final String name;

  const MemberPreview({super.key, required this.name, required this.member, required this.group});

  @override
  State<MemberPreview> createState() => _MemberPreviewState();
}

class _MemberPreviewState extends State<MemberPreview> {
  
  late bool isAdmin = false;
  late bool currUserisAdmin = false;

  void checkAdmin() async{
    bool check = await Controller.checkAdminCurrUser(widget.member.id);
    bool response = await Controller.checkIsAdmin(widget.group);
    if(mounted){
    setState(() {
      isAdmin = response;
      currUserisAdmin = check;
    });}

    print("isAdmin "+ "${isAdmin}");
    print(currUserisAdmin);
  }
  
  @override
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.name,
                              overflow: TextOverflow.ellipsis,
                              style: genieThemeDataDemo.primaryTextTheme.titleLarge),
                             ],
                        ),
                        (isAdmin & !currUserisAdmin)? PopupMenuButton(
                          icon: const Icon(Icons.delete_outline),
                          itemBuilder: 
                          (BuildContext context) => <PopupMenuEntry<FilledButton>>[
                            
                            PopupMenuItem(
                            onTap: () async{
                               showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                  return const AlertDialog(
                                  content: Center(
                                  heightFactor: 2,
                                  child: CircularProgressIndicator(),
                            ),
                          );
                        });
                        String response = await Controller.deleteMember(widget.member.id, widget.group);
                        if(response == "success"){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GroupView(group: widget.group)));
                            }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubo un error'))
                        );
                        }},
                            child: Text('Eliminar Miembro',
                            style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.onError,)))

                          ])
                          : const SizedBox.shrink()
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