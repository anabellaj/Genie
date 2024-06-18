import 'package:flutter/material.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/flashcard_carrousel.dart';
import 'package:genie_app/view/screens/test_menu.dart';
import 'package:genie_app/view/widgets/tabs.dart';
import 'package:genie_app/viewModel/controllerStudy.dart';

class FichasView extends StatefulWidget {
  final String topicId;
  final Groups group;
  const FichasView({super.key, required this.topicId, required this.group});
  @override
  // ignore: library_private_types_in_public_api
  _FichasViewState createState() => _FichasViewState();
}

class _FichasViewState extends State<FichasView> {
  late bool isLoading = true;
  late List<Flashcard> flashcards;

  void getFlashcards()async {
    List<Flashcard> flashcardsList = await ControllerStudy.getFlashcards(widget.topicId);
    setState(() {
      flashcards= flashcardsList;
      isLoading=false;
    });
    

  }
  
  void initState() {
    super.initState();
    
    getFlashcards();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? const Center(child: CircularProgressIndicator()):
       Tabs(group: widget.group, topicId:widget.topicId, fichasContent: FlashCardCarrouselPage(flashcards: flashcards, group:widget.group, topicId: widget.topicId), 
       pruebasContent: TestView(flashcards: flashcards))
    );
  }
}
