import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _formattedTime = DateFormat('hh:mm:ss a').format(DateTime.now());
  String _formattedDate = DateFormat('EEE, d MMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('hh:mm:ss a').format(now);
    final String formattedDate = DateFormat('EEE, d MMM').format(now);

    setState(() {
      _formattedTime = formattedTime;
      _formattedDate = formattedDate;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formattedTime,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _formattedDate,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}}
