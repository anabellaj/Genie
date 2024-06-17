import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/carousel_flashcard.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/viewModel/controllerStudy.dart';


import '../theme.dart';


class FlashCardCarrouselPage extends StatefulWidget{
  final String topicId;
  final Groups group;
  const FlashCardCarrouselPage({super.key, required this.topicId, required this.group});


  @override
  State<FlashCardCarrouselPage> createState()=> _FlashcardCarrouselPageState();

}

class _FlashcardCarrouselPageState extends State<FlashCardCarrouselPage>{
  late bool isLoading=true;
  late List<Flashcard> flashcards;
  void getFlashcards()async {
    List<Flashcard> flashcardsList = await ControllerStudy.getFlashcards(widget.topicId);
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
      appBar: TopBar(),
      body: 
      isLoading? Center(child: CircularProgressIndicator(),):
      Center(child: CarouselFlashcard(flashcards: flashcards, topicId: widget.topicId, group: widget.group,),)
        
      );
  }
}