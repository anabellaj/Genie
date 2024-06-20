import 'package:flutter/material.dart';

import 'package:genie_app/models/flashcard.dart';
import 'package:genie_app/models/tf_question.dart';
import 'package:genie_app/models/tf_quiz.dart';
import 'package:genie_app/view/screens/tf_quiz.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/more_less_btns.dart';
import 'package:genie_app/view/widgets/time_limit.dart';

class TestView extends StatefulWidget {
  final List<Flashcard> flashcards;
  const TestView({super.key, required this.flashcards});

  @override
  // ignore: library_private_types_in_public_api
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  late bool isLoading = true;
  late int maxQuestions;
  int numQuestions = 2;
  int timeLimit = 3600;

  void setTimeLimit(int minutes) {
    timeLimit = minutes * 60;
  }

  TFQuiz createTest(int questionsAmount, List<Flashcard> flashcards) {
    List<TFQuestion> quizQuestions = [];
    flashcards.shuffle();
    for (int i = 0; i < questionsAmount; i++) {
      TFQuestion currQuestion = TFQuestion(
          question: flashcards[i].term,
          correctAnswer: flashcards[i].definition);
      quizQuestions.add(currQuestion);
    }
    return TFQuiz(questions: quizQuestions);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      maxQuestions = widget.flashcards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (maxQuestions <= 1){
      content = const Center(child: Text('Tienen que haber por lo menos dos fichas para generar una prueba', textAlign: TextAlign.center,));
    }else{
      content = Column(
          children: [
            const SizedBox(height: 26.0),
            Row(children: [
              Text(
                'Configura tu prueba',
                style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
              )
            ]),
            const SizedBox(height: 26.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Numero de preguntas:',
                    style: genieThemeDataDemo.textTheme.displayLarge,
                  ),
                  Row(children: [
                    DecrementButton(onPressed: () {
                      setState(() {
                        if (numQuestions > 2) {
                          numQuestions--;
                        }
                      });
                    }),
                    Text(
                      '$numQuestions/$maxQuestions',
                      style: genieThemeDataDemo.textTheme.displayLarge,
                    ),
                    IncrementButton(onPressed: () {
                      setState(() {
                        if (numQuestions < widget.flashcards.length) {
                          numQuestions++;
                        }
                      });
                    }),
                  ])
                ]),
            const SizedBox(height: 18.0),
            MyTimeLimitWidget(
              setTimeLimit: setTimeLimit,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      TFQuiz createdQuiz =
                          createTest(numQuestions, widget.flashcards);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TFQuizScreen(
                                    quiz: createdQuiz,
                                    timeLeft: timeLimit,
                                  )));
                    },
                    style: mainButtonStyle,
                    child: const Text('Iniciar prueba'),
                  ),
                ),
              ],
            ),
          ],
        );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0), // Adjust padding as needed
        child: content
      ),
    );
  }
}
