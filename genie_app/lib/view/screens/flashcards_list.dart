import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/add_forum.dart';
import 'package:genie_app/view/screens/create_card.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/flashcard_preview.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/controllerStudy.dart';
import '../theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';




class FlashcardListPage extends StatefulWidget{
  
  const FlashcardListPage({super.key, required this.topicId});
  final String topicId;
  
  @override
  State<FlashcardListPage> createState()=> _FlashcardListPageState();

}

class _FlashcardListPageState extends State<FlashcardListPage>{
  late bool isLoading=true;
  late List<Flashcard> flashcards;

  void getFlashcards()async {
    List<Flashcard> flashcardsList = await ControllerStudy.getFlashcards('665e2318f29fdd64c7000000');
    print(flashcardsList);
    setState(() {
      flashcards= flashcardsList;
      isLoading=false;
    });

  }

  @override
  void initState() {
    super.initState();
    
    getFlashcards();

  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar:TopBar(),
        body:  isLoading?
                    const Center(child: CircularProgressIndicator()):
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              
              color: genieThemeDataDemo.colorScheme.secondary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    
                    onPressed: () {
                      // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GroupView(group: widget.groupId)));
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
                    
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
                    child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Todas las Fichas',
                      style: genieThemeDataDemo.primaryTextTheme.headlineSmall,),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.onPrimary),
                          iconColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.primary)
                        ),
                        onPressed: ()=>{
                          Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=> CreateCardScreen(topicId: widget.topicId))
                          )   
                        }, 
                        icon: const Icon(Icons.add))
                    ],
                  ),
                  ),
                  
                ],
              ),
            ),
           
                    Expanded(
                      child: FlashcardPreview(
                            flashcards: flashcards,
                            topicId: '665e2318f29fdd64c7000000',
                      ),
                      ),

          ],
        ),
        bottomNavigationBar: BottomNavBar(),
    );}
}