import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/ForumNotification.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/view/screens/forum_view.dart';
import 'package:genie_app/viewModel/controllerForum.dart';


class ForumReplyShow extends StatefulWidget{
  final String forum;
  final String id;
  final String creator;
  final String date;
  final String message;
  final String creator_id;
  final int num_likes;
  const ForumReplyShow({super.key,required this.creator, required this.date, required this.message, required this.creator_id, required this.id, required this.forum, required this.num_likes, });

  @override
  State<ForumReplyShow> createState()=> _ForumReply();
}

class _ForumReply extends State<ForumReplyShow>{
  late bool isCreator=false;
  late bool liked= false;
  late bool isLoading=true;
  late int number_likes=0;

  void checkCreator()async{
    bool creator = await Controller.checkIfOwner(widget.creator_id);
    bool like = await ControllerForum.checkLike(widget.id, widget.forum);
    print(like);
    if(like){
      LikeState(true, widget.id).dispatch(context);
    }
    setState(() {
      isCreator=creator;
      liked= like;
      number_likes=widget.num_likes;
      isLoading=false;
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
                Expanded(child: Text(widget.message,
                maxLines: 100,
                 style: genieThemeDataDemo.textTheme.displayMedium,)),
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
                      String res = await ControllerForum.removeAnswer(widget.id, widget.forum);
                      ForumView f = await ControllerForum.getForum(widget.forum);
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
            ):SizedBox.shrink()]),
             isLoading?
             SizedBox(height: 20,):
             Row(
              children: [
                IconButton(
                  onPressed: (){
                    LikedReply(true).dispatch(context);
                    setState(() {
                      liked = !liked;
                    if(liked){
                      number_likes++;
                      LikeState(liked, widget.id).dispatch(context);
                    }else{
                      if(number_likes>0){
                        number_likes--;
                        LikeState(liked, widget.id).dispatch(context);
                      }
                    }
                    });
                    
                    
                    LikedReply(false).dispatch(context);
                     
                  }, 
                  iconSize: 14,
                  icon: Icon(liked? Icons.thumb_up: Icons.thumb_up_outlined, color: genieThemeDataDemo.colorScheme.primary,)),
                Text(
                  '$number_likes me gusta',
                  style: TextStyle(fontSize: 12, color: genieThemeDataDemo.colorScheme.primary),
                )
              ],
            )
            
            
            ]
          ),
          
          
        ),
      );
    
  }
}