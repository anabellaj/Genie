import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genie_app/models/tf_question.dart';
import 'package:genie_app/models/tf_quiz.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/quiz_summary.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';

var randomGenerator = Random();

class TFQuizScreen extends StatefulWidget {
  const TFQuizScreen({super.key, required this.quiz});
  final TFQuiz quiz;

  @override
  State<StatefulWidget> createState() {
    return _TFQuizScreenState();
  }
}

class _TFQuizScreenState extends State<TFQuizScreen> {
  late var currentQuestion;
  int correctGuesses = 0;
  final List<int> emergenceOrder = [];
  var answeredQuestions = 0;
  List<bool> guesses = [];
  var questionHasBeenAnswered = false;
  var questionHasBeenAnsweredCorrectly = false;

  void userAnswered(bool action) {
    if ((currentQuestion[1] == currentQuestion[2] && action) ||
        (currentQuestion[1] != currentQuestion[2] && !action)) {
      setState(() {
        questionHasBeenAnswered = true;
        questionHasBeenAnsweredCorrectly = true;
      });
      correctGuesses++;
    } else {
      setState(() {
        questionHasBeenAnswered = true;
        questionHasBeenAnsweredCorrectly = false;
      });
    }
    guesses.add(questionHasBeenAnsweredCorrectly);
  }

  //Devuelve una lista donde la primera posicion contiene la pregunta, la segunda la respuesta que mostrara y a tercera la respuesta correcta
  List<String> generateQuestion() {
    List<String> qA = [];
    String question =
        widget.quiz.questions[emergenceOrder[answeredQuestions]].question;
    qA.add(question);
    var probablityOfShowingRightAnswer = randomGenerator.nextInt(10) + 1;

    if (probablityOfShowingRightAnswer <= 5) {
      var answerDisplayed = emergenceOrder[answeredQuestions];
      while (answerDisplayed == emergenceOrder[answeredQuestions]) {
        answerDisplayed = randomGenerator.nextInt(widget.quiz.questions.length);
      }
      qA.add(widget.quiz.answers[emergenceOrder[answerDisplayed]]);
    } else {
      qA.add(widget.quiz.answers[emergenceOrder[answeredQuestions]]);
    }
    qA.add(widget.quiz.answers[emergenceOrder[answeredQuestions]]);
    answeredQuestions++;
    return qA;
  }

  @override
  void initState() {
    widget.quiz.initialize();
    for (var i = 0; i < widget.quiz.questions.length; i++) {
      emergenceOrder.add(i);
    }
    emergenceOrder.shuffle();
    setState(() {
      currentQuestion = generateQuestion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? nextButton;
    Widget? mainContent;
    nextButton = Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        OutlinedButton(
            onPressed: () {
              if (answeredQuestions <= (widget.quiz.questions.length - 1)) {
                setState(() {
                  currentQuestion = generateQuestion();
                  questionHasBeenAnswered = false;
                  questionHasBeenAnsweredCorrectly = false;
                });
              } else {
                setState(() {
                  answeredQuestions++;
                });
              }
            },
            child: const Row(
              children: [Text('Siguiente')],
            )),
      ],
    );

    if (answeredQuestions <= (widget.quiz.questions.length)) {
      mainContent = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shadowColor: genieThemeDataDemo.colorScheme.onSurface,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        currentQuestion[0],
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentQuestion[1],
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
                onPressed: () {
                  if (!questionHasBeenAnswered) userAnswered(true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Verdadero'),
                    if (questionHasBeenAnswered &&
                        currentQuestion[1] == currentQuestion[2])
                      const Icon(Icons.check_circle_outline_outlined,
                          color: Colors.green)
                    else if (questionHasBeenAnswered &&
                        !questionHasBeenAnsweredCorrectly &&
                        currentQuestion[1] != currentQuestion[2])
                      const Icon(Icons.close, color: Colors.red)
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
                onPressed: () {
                  if (!questionHasBeenAnswered) userAnswered(false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Falso'),
                    if (questionHasBeenAnswered &&
                        currentQuestion[1] != currentQuestion[2])
                      const Icon(Icons.check_circle_outline_outlined,
                          color: Colors.green)
                    else if (questionHasBeenAnswered &&
                        !questionHasBeenAnsweredCorrectly &&
                        currentQuestion[1] == currentQuestion[2])
                      const Icon(Icons.close, color: Colors.red)
                  ],
                )),
            if (questionHasBeenAnswered) nextButton,
            questionHasBeenAnsweredCorrectly
                ? const Text('Chi')
                : questionHasBeenAnswered
                    ? const Text('Nopi')
                    : const Text(''),
          ],
        ),
      );
    } else {
      mainContent = QuizSummary(
        quiz: widget.quiz,
        correctGuesses: correctGuesses,
        guesses: guesses,
        emergenceOrder: emergenceOrder,
      );
    }

    return Scaffold(
      appBar: TopBar(),
      body: mainContent,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
