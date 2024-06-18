import 'package:flutter/material.dart';
import 'package:genie_app/models/tf_quiz.dart';
import 'package:genie_app/view/theme.dart';

class QuizSummary extends StatelessWidget {
  const QuizSummary(
      {super.key,
      required this.quiz,
      required this.correctGuesses,
      required this.guesses,
      required this.emergenceOrder});
  final TFQuiz quiz;
  final List<int> emergenceOrder;
  final int correctGuesses;
  final List<bool> guesses;

  @override
  Widget build(BuildContext context) {
    int score = ((correctGuesses / quiz.questions.length) * 100).toInt();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
              shadowColor: genieThemeDataDemo.colorScheme.onSurface,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(children: [
                  Text('Obtuviste una calificación de'),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    '$score %',
                    style: TextStyle(
                      fontSize:
                          60.0, // Adjust font size as desired (larger value = bigger text)
                      color: genieThemeDataDemo
                          .primaryColor, // Change color as desired
                      fontWeight:
                          FontWeight.bold, // Optional: Add boldness (optional)
                    ),
                  )
                ]),
              )),
          const SizedBox(height: 26.0),
          for (var index = 0; index < quiz.questions.length; index++)
            Card(
              shadowColor: genieThemeDataDemo.colorScheme.onSurface,
              color: (guesses[index]) ? Colors.teal[50] : Colors.red[50],
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quiz.questions[emergenceOrder[index]].question),
                    Text(quiz.questions[emergenceOrder[index]].correctAnswer)
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
