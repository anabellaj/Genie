import 'package:flutter/material.dart';
import 'package:genie_app/models/tf_quiz.dart';
import 'package:genie_app/view/theme.dart';

class QuizSummary extends StatelessWidget {
  const QuizSummary(
      {super.key, required this.quiz, required this.correctGuesses});
  final TFQuiz quiz;
  final List<int> correctGuesses;

  @override
  Widget build(BuildContext context) {
    int score = ((correctGuesses.length / quiz.questions.length) * 100).toInt();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
              shadowColor: genieThemeDataDemo.colorScheme.onSurface,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$score %'),
              )),
          for (var index = 0; index < quiz.questions.length; index++)
            Card(
              shadowColor: genieThemeDataDemo.colorScheme.onSurface,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quiz.questions[index].question),
                    Text(quiz.questions[index].correctAnswer)
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
