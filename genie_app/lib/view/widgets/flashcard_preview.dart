import 'package:flutter/material.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/study_material.dart';
import 'package:genie_app/view/screens/modify_flashcard.dart';
import 'package:genie_app/view/screens/modify_study_material.dart';
import 'package:genie_app/view/theme.dart';

class FlashcardPreview extends StatelessWidget {
  const FlashcardPreview(
      {super.key,
      required this.flashcards,
      required this.topicId,
      // required this.group
      });

  final String topicId;
  // final Groups group;
  final List<Flashcard> flashcards;

  @override
  Widget build(BuildContext context) {
    return
    flashcards.isEmpty?
    const Center(child: Column(
      children: [SizedBox(height: 50,),
        Text('No existen fichas', style: TextStyle(color: Color(0xffB4B6BF))), Text("¡Crea una!", style: TextStyle(color: Color(0xffB4B6BF)))],
    ),):
     Column(
      children: [
        for (int i = 0; i < flashcards.length; i++)
          GestureDetector(
            onTap: () {

            },  
            child: Card(
              shadowColor: genieThemeDataDemo.colorScheme.onSurface,
              elevation: 4,
              color: Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                         
                              
                                Text(
                                  flashcards[i].term,
                                  maxLines: 100,
                                  style: genieThemeDataDemo
                                      .primaryTextTheme.titleLarge,
                                ),
                              

                          

                              Container(
                            width: 1.0, // Adjust width as needed
                            height: 20, // Fills available vertical space
                            color: Colors.grey, // Customize color
                          ),
                           
                              
                             Text(
                                                            
                                flashcards[i].definition,
                                style: genieThemeDataDemo.textTheme.displayLarge,
                                textAlign: TextAlign.start,
                                maxLines: 100,
                              ),
                            Align(alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModifyFlashcard(
                                                        flashcard: flashcards[i], 
                                                        topicId: topicId,
                                                        i: i,
                                                        flashcards: flashcards,)
                                                      ));
                                        },
                                        icon: const Icon(Icons.more_horiz_outlined),),
                                  ),
                                
                              
                           
                          
                        
                      
                      
                    
      ]),
                  ),
                ),
     )],
          );
  }
}
