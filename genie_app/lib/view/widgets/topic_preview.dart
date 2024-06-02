import 'package:flutter/material.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/screens/home.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/view/theme.dart';

class TopicPreview extends StatefulWidget{
  final String title;
  final String labels;
  final String topicId;
  final String groupId;

  const TopicPreview({super.key, required this.title, required this.labels, required this.topicId, required this.groupId});

  @override
  State<TopicPreview> createState() => _TopicPreviewState();
}

class _TopicPreviewState extends State<TopicPreview> {
  
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (context)=> TopicScreen(topicId: widget.topicId, ))
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
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with some transparency
                                  spreadRadius: 3.0, // Adjusts how far the shadow spreads
                                  blurRadius: 6.0, // Adjusts how blurry the shadow is
                                  offset: const Offset(0.0, 4.0), // Shifts the shadow position (optional)
                                ),
                                ],
                                ), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.title,
                    
                    style: genieThemeDataDemo.textTheme.displayMedium,),
                    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.labels,
                        overflow: TextOverflow.ellipsis,
                        style: genieThemeDataDemo.primaryTextTheme.titleLarge),
                       ],
                  ),
                      
                ],),
              ),
            ),
          ],
        ),
      )
      );

  }
}