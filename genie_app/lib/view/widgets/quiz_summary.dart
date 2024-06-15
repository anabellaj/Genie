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
          Center(
            child: Text('$score %'),
          ),
          ListView.builder(
            itemCount: quiz.questions.length,
            itemBuilder: (context, index) => Container(
              child: Column(
                children: [
                  Text(quiz.questions[index].question),
                  Text(quiz.questions[index].correctAnswer),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
