import 'package:genie_app/models/tf_question.dart';

class TFQuiz {
  TFQuiz({required this.questions});
  final List<TFQuestion> questions;
  final List<String> answers = [];

  void initialize() {
    for (var question in questions){
      answers.add(question.correctAnswer);
    }
  }

}
