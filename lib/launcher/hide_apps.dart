import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../home_page/cubit/home_page_state.dart';

class HiddenAppScreen extends StatelessWidget {
  final Set<String> hiddenApps; // Pass the hiddenApps set
  final Function(String) onToggleHidden;

  const HiddenAppScreen(this.hiddenApps, this.onToggleHidden);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Apps'),
      ),
      body: ListView.builder(
        itemCount: hiddenApps.length,
        itemBuilder: (context, index) {
          String packageName = hiddenApps.elementAt(index);
          Application app = (State as HomePageLoadedState)
              .apps
              .firstWhere((app) => app.packageName == packageName);

          return ListTile(
            // leading: Image.memory(app.icon),
            title: Text(app.appName),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => onToggleHidden(app.packageName),
            ),
          );
        },
      ),
    );
  }
}
