import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/ForumNotification.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/view/screens/forum_view.dart';
import 'package:genie_app/viewModel/controllerForum.dart';

class FoundMember extends StatefulWidget{

  final String name;
  final String username;
  final String career;
  final String university;

  const FoundMember({super.key, required this.name, required this.username, required this.career, required this.university});
  @override
  State<FoundMember> createState() => _FoundMemberState();
}

class _FoundMemberState extends State<FoundMember> {
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [ const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(10.0), // Add some border radius for better effect
                              boxShadow: [
                                BoxShadow(
                                  color: genieThemeDataDemo.colorScheme.onSurface.withOpacity(0.25), // Shadow color with some transparency
                                  spreadRadius: 0, // Adjusts how far the shadow spreads
                                  blurRadius: 12.0, // Adjusts how blurry the shadow is
                                  offset: const Offset(0.0, 3.0), // Shifts the shadow position (optional)
                                ),
                                ],
                                ), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: genieThemeDataDemo.primaryTextTheme.titleLarge),
                       ],
                  ),
                  Text('Username: ${widget.username}',
                    
                    style: genieThemeDataDemo.textTheme.displayMedium,)
                        
                ],),
              ),
            ),
          ],
        ),
      )
      );

  }
}