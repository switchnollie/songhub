// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

/// A custom app theme, implementing the custom [ColorScheme]
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

/// A custom light type [ColorScheme]
final ColorScheme colorScheme = ColorScheme.light(
  primary: Color(0xFFFFFFFF),
  secondary: Color(0xFF161616),
  surface: Color(0xFFD9E9FF), //Color(0xFFD5DBF4),
  background: Color(0xFFf1f7ff), //Color(0xFFF2F6FF),
  error: Color(0xFFD95045),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF4066F0),
  onSurface: Color(0xFFA3AFBF), //Color(0xFFD2D4DC),
  onBackground: Color(0xFFD2D4DC),
  brightness: Brightness.light,
);
