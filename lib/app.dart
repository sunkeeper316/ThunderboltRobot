import 'package:flutter/material.dart';

import 'ui/screens/game_flow.dart';

class ThunderboltApp extends StatelessWidget {
  const ThunderboltApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Thunderbolt',
    theme: ThemeData(fontFamily: 'sans', brightness: Brightness.dark),
    home: const GameFlow(),
  );
}
