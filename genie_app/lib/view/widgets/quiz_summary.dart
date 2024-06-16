import 'package:flutter/material.dart';
import 'package:genie_app/models/tf_quiz.dart';

class QuizSummary extends StatelessWidget {
  const QuizSummary(
      {super.key, required this.quiz, required this.correctGuesses});
  final TFQuiz quiz;
  final List<int> correctGuesses;

  @override
  Widget build(BuildContext context) {
    int score = ((correctGuesses.length / quiz.questions.length) * 100).toInt();
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text('$score %'),
          for (var index = 0; index < quiz.questions.length; index++)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: correctGuesses.contains(index)
                        ? Colors.green
                        : Colors.red),
                width: double.infinity,
                height: double.minPositive,
                child: Column(
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
