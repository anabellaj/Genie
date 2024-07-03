import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/screens/code.dart';
import 'package:genie_app/view/widgets/friend_add.dart';
import 'package:genie_app/viewModel/GroupAddNotification.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

class AddFriendPage extends StatefulWidget{
  final Groups group;
  const AddFriendPage({super.key, required this.group});

  @override State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage>{
  List<FriendAdd> friends = [];
  late bool isLoading=true;
  late bool isLeaving= false;
  late List<dynamic> toAdd =[];

  void getFriends() async{
    List<FriendAdd> f = await ControllerSocial.getFriendsToAdd(widget.group);
    setState(() {
      friends=f;
      isLoading=false;
    });
  }
  void updateAdd()async{
    setState(() {
      isLeaving=true;
    });
    await ControllerSocial.addNewMembers(widget.group, toAdd);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    getFriends();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return NotificationListener<GroupAddNotification>(
      onNotification: (n){
        toAdd.add(n.userId);
        return true;
      },
      child: Scaffold(
      appBar: TopBar(),
      body: isLeaving? Center(child: CircularProgressIndicator(),):
      Column(
        children: [
           Container(
        color: genieThemeDataDemo.colorScheme.secondary,
        
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          TextButton(
            onPressed: () {
              updateAdd();
            },
            child: Row(
              children: [
                Icon(Icons.chevron_left,
                  color: genieThemeDataDemo.colorScheme.onSecondary),
                Text(
                  'Regresar',
                  style: TextStyle(
                    color: genieThemeDataDemo.colorScheme.onSecondary),
                )
              ],
            )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
            "Invita a tus amigos",
            style: genieThemeDataDemo.primaryTextTheme.headlineSmall?.copyWith(fontSize: 24),
          ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       CodePage(group: widget.group))); //CAMBIAR ROUTE A foro
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              genieThemeDataDemo.colorScheme.surface,
                          foregroundColor:
                              genieThemeDataDemo.colorScheme.secondary,
                          textStyle: genieThemeDataDemo.textTheme.bodyMedium?.copyWith(fontSize: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: const Text('Código'),
                      ),

            )
            ],
          )
        ],
      ),
      ),
      
      Expanded(
        child: isLoading? Center(child: CircularProgressIndicator(),): 
        ListView(
          children: [...friends],
        ))
        ],),
      bottomNavigationBar: BottomNavBar(),
    ),)
    ;
  }
}