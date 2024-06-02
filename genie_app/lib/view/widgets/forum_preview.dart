import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/forum_list.dart';
import 'package:genie_app/view/screens/forum_view.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';


class MessagePreview extends StatefulWidget{
  final Groups group;
  final String id;
  final String title;
  final String creator;
  final String date;
  final String description;
  final String creator_id;
  const MessagePreview({super.key, required this.id, required this.title, required this.creator, required this.date, required this.description, required this.creator_id, required this.group});

  @override
  State<MessagePreview> createState()=> _MessagePreview();
}

class _MessagePreview extends State<MessagePreview>{
  late bool isCreator=false;

  void checkCreator()async{
    bool check = await Controller.checkIfOwner(widget.creator_id);
    setState(() {
      isCreator=check;
    });
  }
  @override
  void initState() {
    
    super.initState();

    checkCreator();
  }

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, 
          MaterialPageRoute(
            builder: (context)=>
              ForumView(
                date: widget.date,
                description: widget.description,
                id:widget.id,
                title: widget.title,
                creator: widget.creator,
                creator_id: widget.creator_id,
              )));
      },
      child: Container(
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
              Text(widget.title,
                overflow: TextOverflow.ellipsis,
                style: genieThemeDataDemo.primaryTextTheme.titleLarge,),
              Text(widget.date,
                style: genieThemeDataDemo.textTheme.titleSmall,)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.creator,
                    style: genieThemeDataDemo.textTheme.titleSmall,),
                  Text(widget.description,
                   overflow: TextOverflow.ellipsis,
                   style: genieThemeDataDemo.textTheme.displayMedium,),
                ],
              ),
            isCreator? 
                PopupMenuButton(
                  icon: const Icon(Icons.delete_outline),
                  itemBuilder: 
                  (BuildContext context) => <PopupMenuEntry<FilledButton>>[
                    PopupMenuItem<FilledButton>(
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
                     String res = await Controller.deleteForum(widget.id);
                      Navigator.pop(context);
                      
                      if(res=='success'){
                      
                       Navigator.pushReplacement(context, 
                       MaterialPageRoute(builder: (context)=> ForumsListPage(groupId: widget.group)));
                     }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubo un error'))
                        );
                     }
                      
                      
                    },
                    child: Text('Eliminar Foro',
                    style: TextStyle(
                      color: genieThemeDataDemo.colorScheme.onError,
                      fontWeight: FontWeight.bold,),)
                  ),]
                  ):
                  const SizedBox.shrink()
               
                
            ],)
          
          
          
        ],),
      )
      );
    
  }
}