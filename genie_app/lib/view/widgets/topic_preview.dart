import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/topic.dart';
import 'package:genie_app/view/theme.dart';

class TopicPreview extends StatefulWidget {
  final String title;
  final String labels;
  final String topicId;
  final Groups groupId;

  const TopicPreview(
      {super.key,
      required this.title,
      required this.labels,
      required this.topicId,
      required this.groupId});

  @override
  State<TopicPreview> createState() => _TopicPreviewState();
}

class _TopicPreviewState extends State<TopicPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicScreen(
                        topicId: widget.topicId,
                        group: widget.groupId,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(
                      10.0), // Add some border radius for better effect
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(
                          0.5), // Shadow color with some transparency
                      spreadRadius: 3.0, // Adjusts how far the shadow spreads
                      blurRadius: 6.0, // Adjusts how blurry the shadow is
                      offset: const Offset(
                          0.0, 4.0), // Shifts the shadow position (optional)
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.title,
                        style: genieThemeDataDemo.textTheme.titleMedium,
                      ),
                      Wrap(
                        children: [
                          Container(
                    
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: genieThemeDataDemo.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(50),
                          
                        ),
                        child: Text(widget.labels,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  genieThemeDataDemo.textTheme.displayMedium!.copyWith(color: genieThemeDataDemo.colorScheme.onSecondary),
                      )
                      )
                      
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
