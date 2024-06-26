import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/theme.dart';

class GroupPreview extends StatefulWidget{
  final String name;
  final String membersQty;
  final String description;
  final Groups group;

  const GroupPreview({super.key, required this.name, required this.membersQty, required this.description, required this.group});

  @override
  State<GroupPreview> createState() => _GroupPreviewState();
}

class _GroupPreviewState extends State<GroupPreview> {
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (context)=> GroupView(group: widget.group))
                );
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
                  Text('Miembros: ${widget.membersQty}',
                    
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