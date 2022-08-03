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
  late AnimationController _glowingAnimationController;
  late Animation _glowingAnimation;

  //just to try 'changing temperature' mode
  late Timer _timer;
  int animationDuration = 2000;
  double currentTemp = 15;
  double setTemp = 20;

  void startTempChange() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        log(currentTemp.toString());
        if (currentTemp == setTemp) {
          setState(() {
            //here the magice happens
            _glowingAnimationController.duration =
                Duration(milliseconds: animationDuration);
            _glowingAnimationController.repeat(reverse: true);
            timer.cancel();
          });
        } else {
          setState(() {
            _glowingAnimationController.duration =
                const Duration(milliseconds: 500);
            _glowingAnimationController.repeat(reverse: true);
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
    _glowingAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _glowingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
    );
    _glowingAnimationController.repeat(reverse: true);
    _glowingAnimation =
        Tween(begin: 20.0, end: 35.0).animate(_glowingAnimationController);
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
          litoThermometer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.question_mark),
      ),
    );
  }

  Widget litoThermometer() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        innerSleekCircularSlider(currentTemp),
        outerSleekCircularSlider(setTemp),
      ],
    );
  }

  CircularSliderAppearance litoCSA({
    bool isInner = false,
    int oTemperature = 20,
    int iTemperature = 19,
  }) {
    return CircularSliderAppearance(
      infoProperties: InfoProperties(
        modifier: (value) {
          final roundedValue = value.ceil().toInt().toString();
          return isInner ? '' : '$roundedValue°C';
        },
        topLabelText: isInner ? '' : 'Temperature',
        bottomLabelText: isInner ? '' : 'Good day',
      ),
      customWidths: CustomSliderWidths(
        progressBarWidth: isInner ? 10 : 15,
        trackWidth: isInner ? 0.1 : 3,
        shadowWidth: isInner ? 0 : _glowingAnimation.value,
        handlerSize: isInner ? 0 : 5,
      ),
      customColors: CustomSliderColors(
        trackColor: const Color.fromARGB(119, 189, 189, 189),
        progressBarColor: isInner ? Colors.yellow[900] : Colors.amberAccent,
        shadowColor: Colors.amberAccent.shade100,
      ),
      // spinnerMode: true,
      size: !isInner ? 250 : 215,
      startAngle: 270,
      angleRange: 360,
    );
  }

  Widget outerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      onChange: ((value) {
        log('CHANGING: ${value.toString()}');
      }),
      onChangeStart: ((value) {
        log('START: ${value.toString()}');
      }),
      onChangeEnd: ((value) {
        startTempChange();
        setTemp = value;
        log('END: ${value.toString()}');
      }),
      // innerWidget: nuevoSleekCircular,
      appearance: litoCSA(
        isInner: false,
      ),
      min: 15,
      max: 35,
      initialValue: temperature,
    );
  }

  Widget innerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      appearance: litoCSA(
        isInner: true,
      ),
      min: 15,
      max: 35,
      initialValue: temperature,
    );
  }
//
}
