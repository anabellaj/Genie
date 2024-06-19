import 'package:flutter/material.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/create_card.dart';
import 'package:genie_app/view/screens/fichas_menu.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/flashcard_preview.dart';

import 'package:genie_app/viewModel/controllerStudy.dart';
import '../theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';




class FlashcardListPage extends StatefulWidget{
  
  const FlashcardListPage({super.key, required this.topicId, required this.flashcards, required this.group});
  final String topicId;
  final List<Flashcard> flashcards;
  final Groups group;
  
  @override
  State<FlashcardListPage> createState()=> _FlashcardListPageState();

}

class _FlashcardListPageState extends State<FlashcardListPage>{
   late bool isLoading=true;
  late List<Flashcard> flashcardsFound=widget.flashcards;
  
  void getFlashcards()async {
    List<Flashcard> flashcardsList = await ControllerStudy.getFlashcards(widget.topicId);
    setState(() {
      flashcardsFound= flashcardsList;
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FichasView(
                                        topicId: widget.topicId,
                                        group: widget.group)));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.chevron_left,
                                  color: genieThemeDataDemo
                                      .colorScheme.onSecondary),
                              Text(
                                'Regresar',
                                style: TextStyle(
                                    color: genieThemeDataDemo
                                        .colorScheme.onSecondary),
                              )
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Todas las Fichas',
                              style: genieThemeDataDemo
                                  .primaryTextTheme.headlineSmall,
                            ),
                            IconButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        genieThemeDataDemo
                                            .colorScheme.onPrimary),
                                    iconColor: WidgetStatePropertyAll(
                                        genieThemeDataDemo
                                            .colorScheme.primary)),
                                onPressed: () => {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateCardScreen(
                                                    topicId: widget.topicId,
                                                    flashcard:
                                                        widget.flashcards,
                                                    group: widget.group,
                                                  )))
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
                    group: widget.group,
                    flashcards: flashcardsFound,
                    topicId: widget.topicId,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

