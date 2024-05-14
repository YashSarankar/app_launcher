import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/clock.dart';
import '../home_page/cubit/home_page_cubit.dart';
import '../home_page/home_page.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LauncherScreenLayout(),
    );
  }
}

class _LauncherScreenLayout extends StatefulWidget {
  const _LauncherScreenLayout();

  @override
  State<_LauncherScreenLayout> createState() => _LauncherScreenLayoutState();
}

class _LauncherScreenLayoutState extends State<_LauncherScreenLayout> {
  final TextEditingController _searchController = TextEditingController();
  void launchCamera() async {
    if (await Permission.camera.request().isGranted) {
      final Uri cameraUrl = Uri(
        scheme: 'content',
        path: 'images/media',
      );
      if (await canLaunchUrl(cameraUrl)) {
        await launchUrl(cameraUrl);
      } else {
        throw 'Could not launch $cameraUrl';
      }
    } else {
      print('Camera permission is not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: [
        GestureDetector(
          onVerticalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dy > sensitivity) {
              // Down Swipe
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const LauncherScreen()),
              // );
            } else if (details.delta.dy < -sensitivity) {
              // Up Swipe

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            }
          },
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  "assets/app.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
              const Clock(),
              Positioned(
                top: 150,
                left: 30,
                right: 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/GOOGLE.png",
                      width: 22,
                      height: 22,
                    ),
                    title: TextFormField(
                      onEditingComplete: () async {
                        final searchQuery = _searchController.text.toString();
                        if (searchQuery.isNotEmpty) {
                          final url =
                              'https://www.google.com/search?q=$searchQuery';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                            Timer(const Duration(milliseconds: 1500),
                                () => _searchController.clear());
                          } else {
                            throw 'Could not launch $url';
                          }
                        } else {
                          print('Search query is empty');
                        }
                      },
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      controller: _searchController,
                      cursorColor: Colors.black54,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        hintStyle: TextStyle(color: Colors.black54),
                        hintText: 'Search Google',
                      ),
                    ),
                    trailing: Image.asset(
                      "assets/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () async {
                          if (await Permission.contacts.request().isGranted) {
                            launchUrl(Uri.parse('tel:'));
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.message_outlined),
                        onPressed: launchCamera,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        MyHomePage(),
      ],
    );
  }
}
