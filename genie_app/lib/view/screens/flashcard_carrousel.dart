import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/widgets/carousel_flashcard.dart';
import 'package:genie_app/models/flashcard.dart';

class FlashCardCarrouselPage extends StatefulWidget {
  final String topicId;
  final Groups group;
  final List<Flashcard> flashcards;
  const FlashCardCarrouselPage(
      {super.key,
      required this.topicId,
      required this.group,
      required this.flashcards});

  @override
  State<FlashCardCarrouselPage> createState() => _FlashcardCarrouselPageState();
}

class _FlashcardCarrouselPageState extends State<FlashCardCarrouselPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CarouselFlashcard(
        flashcards: widget.flashcards,
        topicId: widget.topicId,
        group: widget.group,
      ),
    ));
  }
}
