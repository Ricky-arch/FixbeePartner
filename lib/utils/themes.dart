import 'package:flutter/material.dart';
import 'package:fixbee_partner/utils/colors.dart';

class FixbeeThemes{


  static Color kPrimaryColor = Color.fromRGBO(255, 255, 0, 1);
  static Color kCanvasColor = Color(0xFF121212);
  static Color kCardColor = Color(0xFF181818);
  static Color kCardColorLighter = Color(0xFF2F2F2F);
  static Color kAccentColor = Colors.white;
  static Color kHintColor=Colors.teal[500];
  static Color kErrorColor=Colors.red;

  static final darkTheme= ThemeData(
    brightness: Brightness.dark,
    primaryColorBrightness: Brightness.light,
    primaryColorDark: kPrimaryColor,
    accentColor: kAccentColor,
    errorColor: kErrorColor,
    hintColor: kHintColor,
    primaryColor: kPrimaryColor,
    canvasColor: kCanvasColor,
    scaffoldBackgroundColor: kCanvasColor,
    cardColor: kCardColor,
    colorScheme: ColorScheme.dark()
  );

  static final lightTheme=ThemeData.light();



}
class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode= ThemeMode.light;
  bool get isDarkMode=> themeMode==ThemeMode.dark;
}