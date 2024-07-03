import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/screens/code.dart';
import 'package:genie_app/view/widgets/friend_add.dart';

class AddFriendPage extends StatefulWidget{
  final Groups group;
  const AddFriendPage({super.key, required this.group});

  @override State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body:Column(
        children: [
           Container(
        color: genieThemeDataDemo.colorScheme.secondary,
        
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
      FriendAdd(),
      FriendAdd(),
        ],),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}