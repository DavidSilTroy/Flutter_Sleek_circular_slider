import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'thermometer/thermometer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Thermometer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentTemp = 17;
  double setTemp = 20;
  late Timer _timer;

  void startTempChange() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        log(currentTemp.toString());
        if (currentTemp == setTemp) {
          setState(() {
            //here the magice happens
            timer.cancel();
          });
        } else {
          setState(() {
            if (currentTemp > setTemp) {
              if (currentTemp - setTemp < 1) {
                currentTemp = setTemp;
              } else {
                currentTemp--;
              }
            } else {
              if (setTemp - currentTemp < 1) {
                currentTemp = setTemp;
              } else {
                currentTemp++;
              }
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const Text(
            'Here you should be watching an awesome thermometer:',
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 100,
            ),
            child: LitoThermometer(
              setTemperature: setTemp,
              currentTemperature: currentTemp,
              onChangeEnd: (value) {
                setState(() {
                  setTemp = value;
                });
                log('Main: ${value.toString()}');
                startTempChange();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.question_mark),
      ),
    );
  }

//
}
