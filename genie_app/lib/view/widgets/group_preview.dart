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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide( color: genieThemeDataDemo.colorScheme.primary, width: 2))
        ), 
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
          Text(widget.description,
            overflow: TextOverflow.ellipsis,
            style: genieThemeDataDemo.textTheme.displayMedium,)

        ],),
      )
      );

  }
}