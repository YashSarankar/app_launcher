import 'package:app_launcher/launcher/hide_apps.dart';
import 'package:flutter/material.dart';

import 'launcher/launcher_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: LauncherScreen(),
    );
  }
}
