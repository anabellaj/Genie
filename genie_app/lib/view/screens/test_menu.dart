import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  late bool isLoading = true;
  late List<Widget> topics = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Configura tu prueba',
                  style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
                ),
                const SizedBox(height: 18.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Numero de preguntas',
                        style: genieThemeDataDemo.textTheme.displayLarge,
                      ),
                      Text(
                        '3/11',
                        style: genieThemeDataDemo.textTheme.displayLarge,
                      )
                    ]),
                const SizedBox(height: 18.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tiempo limite',
                        style: genieThemeDataDemo.textTheme.displayLarge,
                      ),
                      Text(
                        '60 min',
                        style: genieThemeDataDemo.textTheme.displayLarge,
                      )
                    ]),
                const SizedBox(height: 18.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tipos de preguntas',
                        style: genieThemeDataDemo.textTheme.displayLarge,
                      ),
                    ]),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: mainButtonStyle,
                        child: const Text('Crear nuevo tema'),
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
