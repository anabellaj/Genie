import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class GroupPreview extends StatefulWidget{
  final String name;
  final String membersQty;
  final String description;

  const GroupPreview({super.key, required this.name, required this.membersQty, required this.description});

  @override
  State<GroupPreview> createState() => _GroupPreviewState();
}

class _GroupPreviewState extends State<GroupPreview> {
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [ const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(10.0), // Add some border radius for better effect
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with some transparency
                                  spreadRadius: 3.0, // Adjusts how far the shadow spreads
                                  blurRadius: 6.0, // Adjusts how blurry the shadow is
                                  offset: const Offset(0.0, 4.0), // Shifts the shadow position (optional)
                                ),
                                ],
                                ), 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: genieThemeDataDemo.primaryTextTheme.titleLarge),
                      //Text(widget.membersQty,
                       // style: genieThemeDataDemo.textTheme.titleSmall,)
                       ],
                  ),
                  Text("Miembros: " + widget.membersQty,
                    overflow: TextOverflow.ellipsis,
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