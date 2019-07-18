import 'package:equinox/equinox.dart';
import 'package:flutter/material.dart';
import 'package:fun_translate_it/src/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EquinoxApp(
      title: 'Flutter Demo',
      theme: EqThemes.defaultLightTheme,
      home: HomePage(),
    );
  }
}
