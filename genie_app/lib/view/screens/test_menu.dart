import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/more_less_btns.dart';
import 'package:genie_app/view/widgets/time_limit.dart';
import 'package:genie_app/view/screens/tf_quiz.dart';
import 'package:genie_app/models/tf_question.dart';
import 'package:genie_app/models/tf_quiz.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  late bool isLoading = true;
  late List<Widget> topics = [];
  int numQuestions = 2;
  int timeLimit = 360;

  void setTimeLimit(int minutes){
    timeLimit = minutes*60;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          children: [
            const SizedBox(height: 26.0),
            Column(
              children: [
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
                        'Numero de preguntas',
                        style: genieThemeDataDemo.textTheme.displayLarge,
                      ),
                      Row(children: [
                        IncrementButton(onPressed: () {
                          setState(() {
                            if (numQuestions < 11) {
                              numQuestions++;
                            }
                          });
                        }),
                        Text(
                          '$numQuestions/11',
                          style: genieThemeDataDemo.textTheme.displayLarge,
                        ),
                        DecrementButton(onPressed: () {
                          setState(() {
                            if (numQuestions > 2) {
                              numQuestions--;
                            }
                          });
                        })
                      ])
                    ]),
                const SizedBox(height: 18.0),
                MyTimeLimitWidget(setTimeLimit: setTimeLimit,),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TFQuizScreen(
                                        quiz: TFQuiz(questions: [
                                          TFQuestion(
                                              question: 'Venezuela',
                                              correctAnswer: 'Caracas'),
                                          TFQuestion(
                                              question: 'Colombia',
                                              correctAnswer: 'Bogota'),
                                          TFQuestion(
                                              question: 'Brasil',
                                              correctAnswer: 'Brasilia'),
                                          TFQuestion(
                                              question: 'Honduras',
                                              correctAnswer: 'Tegucigalpa'),
                                        ]),
                                        timeLeft: 70,
                                      )));
                        },
                        style: mainButtonStyle,
                        child: const Text('Iniciar prueba'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
