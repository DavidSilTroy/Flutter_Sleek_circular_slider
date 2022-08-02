import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  //customized glow with animation
  late AnimationController _animationController;
  late Animation _animation;

  //just to try 'changing temperature' mode
  late Timer _timer;
  int currentTemp = 15;
  int setTemp = 20;

  void startTempChange() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (currentTemp == setTemp) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            if (currentTemp > setTemp) {
              currentTemp--;
            } else {
              currentTemp++;
            }
          });
        }
      },
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String celiousModifier(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '$roundedValue°C';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 20.0, end: 35.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
            textAlign: TextAlign.center,
          ),
          Text(
            '$_counter',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              segundoSleekCircular(currentTemp.toDouble()),
              primerSleekCircular(21),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget nuevoSleekCircular(double percentage) {
    return const SleekCircularSlider(
        appearance: CircularSliderAppearance(
      size: 100,
      startAngle: 0,
      angleRange: 360,
      spinnerMode: true,
    ));
  }

  Widget primerSleekCircular(double percentage) {
    return SleekCircularSlider(
      onChange: ((value) {
        log('CHANGING: ${value.toString()}');
      }),
      onChangeStart: ((value) {
        log('START: ${value.toString()}');
      }),
      onChangeEnd: ((value) {
        startTempChange();
        setTemp = value.toInt();
        log('END: ${value.toString()}');
      }),
      // innerWidget: nuevoSleekCircular,
      appearance: CircularSliderAppearance(
        infoProperties: InfoProperties(
          modifier: celiousModifier,
          topLabelText: 'Temperature',
          bottomLabelText: 'Good day',
        ),
        customWidths: CustomSliderWidths(
          progressBarWidth: 15,
          trackWidth: 0.1,
          shadowWidth: _animation.value,
          handlerSize: 5,
        ),
        customColors: CustomSliderColors(
          trackColor: Colors.amberAccent,
          progressBarColor: Colors.amberAccent,
          shadowColor: Colors.amberAccent.shade100,
        ),
        // spinnerMode: true,
        size: 250,
        startAngle: 270,
        angleRange: 360,
      ),
      min: 15,
      max: 35,
      initialValue: percentage,
    );
  }

  Widget segundoSleekCircular(double percentage) {
    return SleekCircularSlider(
      onChange: ((value) {
        log('CHANGING: ${value.toString()}');
      }),
      onChangeStart: ((value) {
        log('START: ${value.toString()}');
      }),
      onChangeEnd: ((value) {
        log('END: ${value.toString()}');
      }),
      appearance: CircularSliderAppearance(
        infoProperties: InfoProperties(
          modifier: (double value) {
            return '';
          },
          topLabelText: '',
          bottomLabelText: '',
        ),
        customWidths: CustomSliderWidths(
          progressBarWidth: 10,
          trackWidth: 0.1,
          shadowWidth: _animation.value,
          handlerSize: 5,
        ),
        customColors: CustomSliderColors(
          trackColor: Colors.amberAccent,
          progressBarColor: Colors.amberAccent,
          shadowColor: Colors.amberAccent.shade100,
        ),
        // spinnerMode: true,
        size: 210,
        startAngle: 270,
        angleRange: 360,
      ),
      min: 15,
      max: 35,
      initialValue: percentage,
    );
  }
//
}
