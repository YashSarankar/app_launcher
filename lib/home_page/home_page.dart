import 'package:app_launcher/launcher/settings.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../helper/app_utils.dart';
import '../launcher/launcher_screen.dart';
import 'cubit/home_page_cubit.dart';
import 'cubit/home_page_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomePageCubit homePageCubit = context.read<HomePageCubit>();
    return Scaffold(
      body: BlocConsumer(
        bloc: homePageCubit,
        listener: (BuildContext context, HomePageState state) {
          if (state is HomePageErrorState) {
            AppUtils.showToast(state.error);
          }
        },
        builder: (context, HomePageState state) {
          print("Runtime Type : ${state.runtimeType}");
          return _MyHomeLayout(
            state: state,
            onSearch: (q) {
              homePageCubit.onSearch(q);
            },
          );
        },
      ),
    );
  }
}

class _MyHomeLayout extends StatelessWidget {
  const _MyHomeLayout({required this.state, required this.onSearch});

  final HomePageState state;
  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    if (state is HomePageLoadingState) {
      return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/app.png'),
            fit: BoxFit.contain,
          )),
          child: const Center(child: CircularProgressIndicator()));
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.multiply),
          ),
        ),
        child: _HomePageAppList(state: state,onSearch: onSearch),
      );
    }
  }
}

class _HomePageAppList extends StatelessWidget {
  const _HomePageAppList({required this.state,required this.onSearch});

  final HomePageState state;
  final Function(String) onSearch;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            // Down Swipe
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LauncherScreen()),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: TextField(
                style: const TextStyle(fontSize: 16),
                onChanged: (String searchQuery) {
                  onSearch(searchQuery);
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Search Apps...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (state is HomePageLoadedState && (state as HomePageLoadedState).apps.isNotEmpty)
              ListTile(
                title: const Text(
                  "Applications",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        context.read<HomePageCubit>().getAppsFromDevice();
                      },
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()),
                          );
                        },
                        icon: const Icon(Icons.settings)),
                  ],
                ),
              ),
            const Divider(
              thickness: 1,
              color: Colors.white,
              endIndent: 30,
              indent: 16,
            ),
            const SizedBox(
              height: 20,
            ),
            if (state is HomePageLoadedState && (state as HomePageLoadedState).apps.isNotEmpty)
              Expanded(
              child: SingleChildScrollView(
                child: (state as HomePageLoadedState).apps.isEmpty
                    ? const Center(
                        child: Text(
                        "No Application found",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))
                    : Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.spaceEvenly,
                        children: (state as HomePageLoadedState).apps
                            .map((e) => _HomePageListItem(e))
                            .toList()
                          ..sort(
                            (a, b) => a.application.appName
                                .compareTo(b.application.appName),
                          ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePageListItem extends StatelessWidget {
  final Application application;

  const _HomePageListItem(this.application);

  @override
  Widget build(BuildContext context) {
    final HomePageCubit homePageCubit = context.read<HomePageCubit>();
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ListTile(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Open App Settings"),
                content: const Text(
                    "Are you sure you want to open settings for this app?"),
                actions: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => Navigator.pop(context), // Close dialog
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      child: const Text("Confirm",
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        homePageCubit.openAppSettings(application);
                        Navigator.pop(context); // Close dialog
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
        onTap: () {
          final cubit = Provider.of<HomePageCubit>(context, listen: false);
          cubit.openApp(application);
        },
        title: Text(application.appName),
      ),
    );
  }
}
