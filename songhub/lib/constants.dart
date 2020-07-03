import 'package:flutter/material.dart';

/// Custom theme
final appTheme = ThemeData(
  primaryColor: colorScheme.primary,
  accentColor: colorScheme.onSecondary,
  hintColor: colorScheme.secondary,
  fontFamily: "Roboto",
  colorScheme: colorScheme,
  buttonTheme: ButtonThemeData(
    buttonColor: colorScheme.primary,
    textTheme: ButtonTextTheme.primary,
  ),
  dividerColor: colorScheme.onBackground,
);

/// Custom color scheme
final ColorScheme colorScheme = ColorScheme.light(
  primary: Color(0xFFFFFFFF),
  secondary: Color(0xFF161616),
  // primaryVariant: null,
  // secondaryVariant: null,
  surface: Color(0xFFD9E9FF), //Color(0xFFD5DBF4),
  background: Color(0xFFf1f7ff), //Color(0xFFF2F6FF),
  error: Color(0xFFD95045),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF4066F0),
  onSurface: Color(0xFFA3AFBF), //Color(0xFFD2D4DC),
  onBackground: Color(0xFFD2D4DC),
  // onBackground: null,
  // onError: null,
  brightness: Brightness.light,
);
