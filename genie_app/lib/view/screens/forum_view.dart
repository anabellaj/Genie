import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/ForumNotification.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/controllerForum.dart';
import 'package:genie_app/viewModel/validator.dart';

class ForumView extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String date;
  final String creator;
  final String creator_id;
  const ForumView(
      {super.key,
      required this.date,
      required this.description,
      required this.id,
      required this.title,
      required this.creator,
      required this.creator_id});

  @override
  State<ForumView> createState() => _ForumView();
}

class _ForumView extends State<ForumView> {
  final validate = Validator();
  late String message;
  late bool isLoading = true;
  late bool sendingMessage = false;
  late bool isCreator = false;
  late bool isDeleting = false;
  late bool backgroundP=false;
  late List<Widget> replys;
  late List replysUpdate=[];
  late List decreaseReplys =[];
  final TextEditingController _controller = TextEditingController();

  void getAnswers() async {
    bool creator = await Controller.checkIfOwner(widget.creator_id);
    List<Widget> r = await ControllerForum.getReplys(widget.id);
    setState(() {
      replys = r;
      isLoading = false;
      isCreator = creator;
    });
  }
  void updateActions()async{
    await ControllerForum.updateLike(widget.id, replysUpdate, decreaseReplys);
                      
  }

  void removeAnswerToLikes(String id){
    setState(() {
      if(replysUpdate.isNotEmpty){
        replysUpdate.removeWhere((e)=>e==id);
        decreaseReplys.add(id);
      }
    });
  }
  void addAnswerToLikes(String id){
    setState(() {
      replysUpdate.add(id);
    });
  }

  @override
  void initState() {
    super.initState();
    getAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<LikedReply>(
      onNotification: (n){
        setState(() {
          backgroundP=n.val;
        });
        return true;
      },
      child: NotificationListener<LikeState>( 
      onNotification: (n){
        if(n.state){
          addAnswerToLikes(n.id);
        }else{
          removeAnswerToLikes(n.id);
        }
        return true;
      },
      child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: TopBar(),
      body: 
      isDeleting?
      const Center(child: CircularProgressIndicator()):
      Column(
        
        children: [
          Container(
              
              color: genieThemeDataDemo.colorScheme.secondary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isLoading|| backgroundP? const SizedBox.shrink():
                  TextButton(
                    
                    onPressed: () {
                      updateActions();
                      _controller.dispose();

                     
                       
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.pop(context);
                      
                     
                    },
                    child:Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: genieThemeDataDemo.colorScheme.onSecondary,),
                        Text(
                          'Regresar',
                          style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.onSecondary
                          ),
                        )],
                        )
                    
                    ),])),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
          color: genieThemeDataDemo.colorScheme.surface,
          shadowColor: genieThemeDataDemo.colorScheme.onSurface,
          elevation: 4,
          child: Padding(padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
                  Text(widget.title,
                  maxLines: 100,
                style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
              ),
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.creator,
                    
                    style: genieThemeDataDemo.textTheme.titleSmall,
                  ),]),])))),

                  Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : replys.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No hay respuestas al foro',
                                    style: TextStyle(color: Color(0xffB4B6BF)),
                                  ),
                                )
                              : ListView(
                                  children: [...replys],
                                )),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 60,
                          width: double.infinity,
                          color: genieThemeDataDemo.colorScheme.secondary,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: genieThemeDataDemo
                                          .colorScheme.onSecondary,
                                      hintText: "Responder...",
                                      hintStyle: genieThemeDataDemo
                                          .textTheme.titleMedium,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: genieThemeDataDemo
                                                  .colorScheme.secondary),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)))),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              !sendingMessage
                                  ? FloatingActionButton(
                                      onPressed: () async {
                                        if (validate.validateEmptyMessage(
                                            _controller.text)) {
                                          setState(() {
                                            sendingMessage = true;
                                            isLoading = true;
                                          });
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          List<Widget> newReply =
                                              await ControllerForum.newAnswer(
                                                  _controller.text,
                                                  widget.id,
                                                  replys);
                                          _controller.clear();
                                          setState(() {
                                            sendingMessage = false;
                                            isLoading = false;
                                            replys = newReply;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                "Introduzca un mensaje"),
                                            showCloseIcon: true,
                                            closeIconColor: genieThemeDataDemo
                                                .colorScheme.onError,
                                          ));
                                        }
                                      },
                                      backgroundColor: genieThemeDataDemo
                                          .colorScheme.primary,
                                      elevation: 0,
                                      child: Icon(
                                        Icons.send,
                                        color: genieThemeDataDemo
                                            .colorScheme.onPrimary,
                                        size: 18,
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: CircularProgressIndicator(),
                                    ),
                              ]))),
                              
                            ],
                          ),
                        ]),
                      
                    
               
    bottomNavigationBar: BottomNavBar())));


  }
}
