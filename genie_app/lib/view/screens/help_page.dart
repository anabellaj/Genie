import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendFeedback() async {
    final feedback = _feedbackController.text;

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa tu feedback antes de enviar.')),
      );
      return;
    }

    DateTime date = DateTime.now();
    
    String response = await ControllerSocial.sendFeedback(feedback, date);

    if (response == 'success'){
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: genieThemeDataDemo.colorScheme.secondary,
          contentTextStyle: TextStyle(
            color: genieThemeDataDemo.colorScheme.onSecondary,
            fontSize: 12
          ),
          content: const Text("Gracias por tu feedback!"), 
          actions: [IconButton(
            onPressed: ()=>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
              icon: Icon(Icons.check, color: genieThemeDataDemo.colorScheme.onSecondary,))]));
      return;

    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar feedback')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Icon(Icons.chevron_left,
                        color: genieThemeDataDemo
                            .colorScheme.primary),
                    Text(
                      'Regresar',
                      style: TextStyle(
                          color: genieThemeDataDemo
                              .colorScheme.primary),
                    )
                  ],
                )),
            Text(
              'Preguntas Frecuentes',
              style: genieThemeDataDemo.primaryTextTheme.headlineLarge),
            SizedBox(height: 20),
            ExpansionTile(
              title: Text('¿Cómo puedo crear un nuevo grupo de estudio en Genie?', style: genieThemeDataDemo.textTheme.titleMedium),
              children: [
                ListTile(
                  title: Text(
                    '1. Haz clic en el ícono de Más (+) en el menu inferior.\n'
                    '2. Ingresa un nombre y una descripción para el grupo.\n'
                    '3. Invita a tus amigos a unirse al grupo o hazles llegar el código de invitación.\n'
                    '4. Listo! Ya has creado un grupo en Genie.',
                  style: genieThemeDataDemo.textTheme.displayMedium),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('¿Cómo puedo subir material de estudio a un grupo en Genie?',style: genieThemeDataDemo.textTheme.titleMedium),
              children: [
                ListTile(
                  title: Text(
                    '1. Accede al grupo de estudio en el que deseas subir el material.\n'
                    '2. Ingresa al tema correspondiente al material de estudio a subir.\n'
                    '3. Selecciona la opción "Subir archivo" y elige el archivo que deseas compartir.\n'
                    '4. Espera a que el archivo se cargue y esté disponible para que los miembros del grupo lo vean.\n'
                    '5. Listo! Ya has subido material de estudio a un grupo en Genie.',
                  style: genieThemeDataDemo.textTheme.displayMedium),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('¿Cómo puedo crear fichas en Genie?',style: genieThemeDataDemo.textTheme.titleMedium),
              children: [
                ListTile(
                  title: Text(
                    '1. Accede al grupo de estudio en el que deseas crear las fichas.\n'
                    '2. Ingresa al tema sobre el cual deseas crear fichas.\n'
                    '3. Haz clic en el botón de “Seguir estudiando”.\n'
                    '4. Ingresa a la sección de “Ver todas las fichas”.\n'
                    '5. Haz clic en el ícono de “Más” (+) y completa el contenido de la ficha, incluyendo una pregunta y una respuesta.\n'
                    '6. Listo! Guarda la ficha y repite el proceso para crear más tarjetas de estudio.',
                  style: genieThemeDataDemo.textTheme.displayMedium),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('¿Cómo puedo crear una prueba en Genie?',style: genieThemeDataDemo.textTheme.titleMedium),
              children: [
                ListTile(
                  title: Text(
                    '1. Accede al grupo de estudio en el que deseas crear la prueba.\n'
                    '2. Ingresa al tema sobre el cual deseas crear la prueba.\n'
                    '3. Haz clic en el botón de “Seguir estudiando”.\n'
                    '4. Haz clic en la sección "Pruebas" en el menú superior.\n'
                    '5. Configura los detalles de la prueba, las cantidad de preguntas y el tiempo de la misma.\n'
                    '6. Listo! Ya puedes realizar tu prueba. Recuerda que al final de la misma podrás ver tus resultados obtenidos.',
                  style: genieThemeDataDemo.textTheme.displayMedium),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              '¿Que te ha parecido Genie? ¡Déjanos tu feedback!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe aquí tu feedback',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendFeedback,
              child: Text('Enviar Feedback', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(genieThemeDataDemo.colorScheme.primary)),
            ),
            SizedBox(height: 20),
            const Text(
              '¿Tienes alguna pregunta? ¡Contáctanos!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('gruporusteze@gmail.com',style: genieThemeDataDemo.textTheme.titleMedium),
            Text('+58 4141391498',style: genieThemeDataDemo.textTheme.titleMedium),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}