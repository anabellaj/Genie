import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/view/screens/flashcards_list.dart';
import 'package:genie_app/viewModel/controllerStudy.dart';
import '../theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';

class CarouselFlashcard extends StatefulWidget {
  final List<Flashcard> flashcards;
  final String topicId;
  final Groups group;
  const CarouselFlashcard(
      {super.key,
      required this.flashcards,
      required this.topicId,
      required this.group});

  @override
  State<CarouselFlashcard> createState() => _CarouselFlashcard();
}

class _CarouselFlashcard extends State<CarouselFlashcard> {
  int _current = 0;
  int num_studied = 0;
  final CarouselController _controller = CarouselController();
  late bool isLoading = false;
  late List<bool> studied = [];

  void studiedFlashcard() async {
    await ControllerStudy.updateStudied(
        studied, widget.topicId, widget.flashcards);
  }

  void getInfo() async {
    setState(() {
      isLoading = true;
    });
    List<bool> l =
        await ControllerStudy.checkIfStudied(widget.topicId, widget.flashcards);
    int number = await ControllerStudy.countStudied(l);
    if (mounted) {
      setState(() {
        studied = l;
        isLoading = false;
        num_studied = number;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 45,
            ),
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlashcardListPage(
                              group: widget.group,
                              topicId: widget.topicId,
                              flashcards: widget
                                  .flashcards))); //CAMBIAR ROUTE A members_view
                },
                style: linkButtonStyle,
                child: const Text('Ver todas las fichas')),
            widget.flashcards.isEmpty
                ? const Center(
                    child: Text('Todavía no hay fichas disponibles'),
                  )
                : Column(
                    children: [
                      CarouselSlider(
                          items: widget.flashcards.map((f) {
                            return FlipCard(
                                front: Card(
                                  shadowColor:
                                      genieThemeDataDemo.colorScheme.onSurface,
                                  elevation: 4,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(f.term)),
                                  ),
                                ),
                                back: Card(
                                    shadowColor: genieThemeDataDemo
                                        .colorScheme.onSurface,
                                    elevation: 4,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(f.definition)),
                                    )));
                          }).toList(),
                          carouselController: _controller,
                          options: CarouselOptions(
                              autoPlay: false,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              })),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _current = _current - 1;
                                    if (_current < 0) {
                                      _current = widget.flashcards.length - 1;
                                    }
                                  });
                                  _controller.animateToPage(_current);
                                },
                                icon: Icon(Icons.chevron_left,
                                    color: genieThemeDataDemo
                                        .colorScheme.primary)),
                            Row(
                              children: widget.flashcards.map((f) {
                                return GestureDetector(
                                  onTap: () => _controller.animateToPage(
                                      widget.flashcards.indexOf(f)),
                                  child: Container(
                                    width: 6.0,
                                    height: 6.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: genieThemeDataDemo
                                            .colorScheme.primary
                                            .withOpacity(_current ==
                                                    widget.flashcards.indexOf(f)
                                                ? 0.9
                                                : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _current = _current + 1;
                                    if (_current >= widget.flashcards.length) {
                                      _current = 0;
                                    }
                                  });
                                  _controller.animateToPage(_current);
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: genieThemeDataDemo.colorScheme.primary,
                                )),
                          ]),
                      const SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '$num_studied/${widget.flashcards.length} estudiadas'),
                            IconButton(
                                iconSize: 48,
                                onPressed: () {
                                  setState(() {
                                    studied[_current] = !studied[_current];
                                    if (studied[_current]) {
                                      num_studied++;
                                    } else {
                                      num_studied--;
                                    }
                                    studiedFlashcard();
                                  });
                                },
                                icon: Icon(
                                  studied[_current]
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: genieThemeDataDemo.colorScheme.primary,
                                ))
                          ],
                        ),
                      )
                    ],
                  )
          ]);
  }
}
