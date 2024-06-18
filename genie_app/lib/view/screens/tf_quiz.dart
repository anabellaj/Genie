import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:genie_app/models/tf_quiz.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/quiz_summary.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';

var randomGenerator = Random();

class TFQuizScreen extends StatefulWidget {
  const TFQuizScreen({super.key, required this.quiz, required this.timeLeft});
  final TFQuiz quiz;
  final int timeLeft;

  @override
  State<StatefulWidget> createState() {
    return _TFQuizScreenState();
  }
}

class _TFQuizScreenState extends State<TFQuizScreen> {
  late int timeLeft;
  late var currentQuestion;
  final List<int> emergenceOrder = [];
  List<bool> guesses = [];
  int correctGuesses = 0;
  var answeredQuestions = 0;
  var questionHasBeenAnswered = false;
  var questionHasBeenAnsweredCorrectly = false;
  late Timer timer;

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
    _startTimer();
    timeLeft = widget.timeLeft;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          for (var i = answeredQuestions; i <= emergenceOrder.length;i++){
            guesses.add(false);
            answeredQuestions++;
          }
        }
      });
    });
  }

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
      mainContent = Column(
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
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  side: BorderSide(
                      color: genieThemeDataDemo.colorScheme.secondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0))),
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
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  side: BorderSide(
                      color: genieThemeDataDemo.colorScheme.secondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0))),
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
        ],
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                decoration: BoxDecoration(
                  color: genieThemeDataDemo.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  child: Text(
                    Duration(seconds: timeLeft).toString().split('.').first,
                    style: genieThemeDataDemo.primaryTextTheme.bodyMedium,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: genieThemeDataDemo.primaryColor,
                      width: 2.0), // Adjust border color and width
                ),
                padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: genieThemeDataDemo.primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ]),
            const SizedBox(height: 24.0),
            mainContent,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
