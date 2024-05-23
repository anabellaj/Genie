// toda la información referente al tema
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData genieThemeDataDemo = ThemeData(

  primaryColor:const Color(0xff084C6E),
  colorScheme: const ColorScheme(
  primary:  Color(0xff084C6E), 
  brightness: Brightness.light,
  onPrimary:  Color(0xffFFFCFF), 
  onError: Color(0xffC5061D),
  error: Color(0xffFFC1C9),
  secondary: Color(0xff3D7F95),
  onSecondary: Color(0xffFFFCFF),
  surface: Color(0xffFFFCFF),
  onSurface: Color(0xff212227)),
  
  //Theme related to titles and main text on the app
  primaryTextTheme: GoogleFonts.breeSerifTextTheme(const TextTheme(
   
    headlineLarge: TextStyle(//titulos de pagina
      color: Color(0xff212227), 
      fontSize: 32.0),
    headlineMedium: TextStyle(//titulos de pagina incio sesion
      color: Color(0xff084C6E),
      fontSize: 32.0),
    headlineSmall: TextStyle(//titulos de pagina sobre blanco
      color: Color(0xffFFFCFF),
      fontSize: 32.0),
    titleLarge: TextStyle( //titulos de foro en preview
      color:  Color(0xff212227), 
      fontSize: 20.0),
  )),
  //Theme related to body text and input text on the app
  textTheme: GoogleFonts.asapCondensedTextTheme(const TextTheme(
    displaySmall: TextStyle( //links
      color: Color(0xff084C6E),
      fontSize: 14),
    displayMedium: TextStyle( //descripciones
      color: Color(0xff212227),
      fontSize: 14),
    displayLarge: TextStyle( //inputs
      color: Color(0xff212227),
      fontSize: 16),

    bodyMedium: TextStyle( //se utiliza para los botones
      fontSize: 20.0 )
  )),
  canvasColor:const Color(0xffFFFCFF),
  cardColor: const Color(0xffFFFCFF),
   

  
  
  



);
 ButtonStyle mainButtonStyle =  ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(genieThemeDataDemo.primaryColor),
  foregroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.onPrimary),
  textStyle:  WidgetStatePropertyAll(genieThemeDataDemo.textTheme.bodyMedium),
  padding:const WidgetStatePropertyAll(EdgeInsets.all(10)),
);
ButtonStyle secondaryButtonStyle =  ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.secondary),
  foregroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.onPrimary),
  textStyle:  WidgetStatePropertyAll(genieThemeDataDemo.textTheme.bodyMedium),
  padding:const WidgetStatePropertyAll(EdgeInsets.all(10)),
);
ButtonStyle outlinedButtonStyle =  ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.onPrimary),
  foregroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.primary),
  textStyle:  WidgetStatePropertyAll(genieThemeDataDemo.textTheme.bodyMedium),
  padding:const WidgetStatePropertyAll(EdgeInsets.all(10)),
);