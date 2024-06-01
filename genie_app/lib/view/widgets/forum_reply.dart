  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/view/screens/forum_view.dart';


class ForumReplyShow extends StatefulWidget{
  final String forum;
  final String id;
  final String creator;
  final String date;
  final String message;
  final String creator_id;
  const ForumReplyShow({super.key,required this.creator, required this.date, required this.message, required this.creator_id, required this.id, required this.forum});

  @override
  State<ForumReplyShow> createState()=> _ForumReply();
}

class _ForumReply extends State<ForumReplyShow>{
  late bool isCreator;

  void checkCreator()async{
    bool creator = await Controller.checkIfOwner(widget.creator_id);
    setState(() {
      isCreator=creator;
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
              Text(widget.creator,
                overflow: TextOverflow.ellipsis,
                style: genieThemeDataDemo.textTheme.titleSmall,),
              
                 
                  
                  Text(widget.date,
                    style: genieThemeDataDemo.textTheme.titleSmall,),
                    
                  
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.message,
                 style: genieThemeDataDemo.textTheme.displayMedium,),
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
                      String res = await Controller.removeAnswer(widget.id, widget.forum);
                      ForumView f = await Controller.getForum(widget.forum);
                      Navigator.pop(context);
                      
                      if(res=='success'){
                      
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> f));
                       
                     }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubo un error'))
                        );
                     }
                      
                      
                    },
                    child: Text('Eliminar Respuesta',
                    style: TextStyle(
                      color: genieThemeDataDemo.colorScheme.onError,
                      fontWeight: FontWeight.bold,),)
                  ), 
                 ],
            )])
            
            ]
          ),
          
          
        ),
      );
    
  }
}