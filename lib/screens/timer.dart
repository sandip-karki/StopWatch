import 'package:flutter/material.dart';
import 'package:project1/main.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Time extends StatefulWidget {
  Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

int seconds = 0;
Timer? timer;
String time = "00:00:00";
String buttonText = "Start";
List<int> saveTime = [];
int counter = 0;
DateTime? saveTimer;

class _TimeState extends State<Time> {
  void startTime() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
        print(seconds);
        saveTimer = DateTime.now();
        saveStartTime();
        showTimerNotification(formatTime(seconds));
      });
    });
  }

  void stopTime() {
    timer!.cancel();
  }

  void again() {
    setState(() {
      if (seconds >= 1) {
        saveTime.insert(0, seconds);
        counter++;
      }
      seconds = 0;

      stopTime();
      cancelNotification();
      buttonText = "Start";
    });
  }

  void Ontap() {
    setState(() {
      buttonText = buttonText == "Start" ? "Stop" : "Start";
      if (buttonText == "Stop") {
        startTime();
      }
      if (buttonText == "Start") {
        stopTime();
      }
    });
  }

  void saveStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('startTime', startTime.toString());
  }

  Future<void> loadStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString('startTime');
    if (saved != null) {
      saveTimer = DateTime.parse(saved);
    }
  }

  String formatTime(int sec) {
    return Duration(seconds: sec).toString().split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(seconds);
    // Duration elapsed = DateTime.now().difference(saveTimer);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {}); // Only UI updates; time is always accurate
    });

    return Scaffold(
      appBar: AppBar(title: Center(child: Text("StopWatch"))),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                formattedTime,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: Ontap,
                    child: Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text(buttonText)),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: again,
                    child: Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text("Reset")),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 400,
                    width: 350,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 194, 178, 178),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  saveTime.removeAt(index);
                                });
                              },
                              child: Icon(Icons.delete),
                            ),
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                formatTime(saveTime[index]),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: saveTime.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
