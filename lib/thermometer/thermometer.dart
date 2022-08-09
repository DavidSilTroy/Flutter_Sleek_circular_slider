import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sleek_circular_slider/thermometer/thermo_theme.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LitoThermometer extends StatefulWidget {
  final OnChange? onChange;
  final OnChange? onChangeStart;
  final OnChange? onChangeEnd;
  final double currentTemperature;
  final double setTemperature;
  final String? topLabelText;
  final String? bottomLabelText;
  final double minTemperature = 15;
  final double maxTemperature = 35;

  const LitoThermometer(
      {Key? key,
      this.onChange,
      this.onChangeStart,
      this.onChangeEnd,
      required this.currentTemperature,
      required this.setTemperature,
      this.topLabelText,
      this.bottomLabelText})
      : assert(currentTemperature >= 15),
        assert(setTemperature >= 15),
        assert(currentTemperature <= 35),
        assert(setTemperature <= 35),
        super(key: key);

  @override
  State<LitoThermometer> createState() => _LitoThermometer();
}

class _LitoThermometer extends State<LitoThermometer>
    with SingleTickerProviderStateMixin {
  //customized glow with animation
  late AnimationController _glowingAnimationController;
  late Animation _glowingAnimation;

  late CircularSliderAppearance _litoCSApareance1;

  int slowGlowDuration = 2000;
  int fastGlowDuration = 500;
  double setTemperature = 0;
  Color progressBarColor = Colors.amberAccent;

  @override
  void initState() {
    setTemperature = widget.setTemperature;

    _glowingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: slowGlowDuration),
    );
    _glowingAnimation =
        Tween(begin: 20.0, end: 26.0).animate(_glowingAnimationController);
    _glowingAnimationController.addListener(() {
      setState(() {
        _litoCSApareance1 = litoCSAppearance(
          _glowingAnimation,
          isInner: false,
          outerBarColor: progressBarColor,
          topLabelText: widget.topLabelText,
          bottomLabelText: widget.bottomLabelText ?? decideBottomLabelText(),
        );
      });
    });

    _glowAnimationDuration();

    _litoCSApareance1 = litoCSAppearance(
      _glowingAnimation,
      isInner: false,
      outerBarColor: progressBarColor,
      topLabelText: widget.topLabelText,
      bottomLabelText: widget.bottomLabelText ?? decideBottomLabelText(),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant LitoThermometer oldWidget) {
    _glowAnimationDuration();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _glowingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return litoThermometer();
  }

  void _glowAnimationDuration() {
    int animationDuration = fastGlowDuration;
    if (widget.currentTemperature == widget.setTemperature) {
      animationDuration = slowGlowDuration;
    }
    _glowingAnimationController.duration =
        Duration(milliseconds: animationDuration);
    _glowingAnimationController.repeat(reverse: true);
  }

  Widget litoThermometer() {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  innerSleekCircularSlider(widget.currentTemperature),
                  outerSleekCircularSlider(widget.setTemperature),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: rightThermometerIcon(22),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Text('Set Temperature: ${setTemperature.ceil()}°C'),
        )
      ],
    );
  }

  Widget outerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      onChange: ((value) {
        log('CHANGING: ${value.toString()}');
        setState(() {
          setTemperature = value;
          progressBarColor = decideBarColor(value);
        });
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      }),
      onChangeStart: ((value) {
        log('START: ${value.toString()}');
        if (widget.onChangeStart != null) {
          widget.onChangeStart!(value);
        }
      }),
      onChangeEnd: ((value) {
        if (widget.onChangeEnd != null) {
          widget.onChangeEnd!(value);
        }
        log('Therm -> ct:${widget.currentTemperature} & st: ${widget.setTemperature}');
      }),
      appearance: _litoCSApareance1,
      min: widget.minTemperature,
      max: widget.maxTemperature,
      initialValue: temperature,
    );
  }

  Widget innerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      appearance: litoCSAppearance(
        _glowingAnimation,
        isInner: true,
      ),
      min: widget.minTemperature,
      max: widget.maxTemperature,
      initialValue: temperature,
    );
  }

  Widget rightThermometerIcon(double temperature) {
    return Container(
      margin: const EdgeInsets.only(
        left: 250,
      ),
      child: currentIcon(),
    );
  }

  Icon currentIcon() {
    final t1 = widget.currentTemperature;
    final t2 = widget.setTemperature;
    Color iconcolor = decideBarColor(t2);
    const iconcolor2 = Color.fromARGB(72, 33, 149, 243);
    double iconsize = 40;
    Icon currentIcon;
    if (t1 > t2) {
      currentIcon = Icon(
        Icons.ac_unit,
        color: iconcolor,
        size: iconsize,
      );
    } else {
      if (t1 == t2) {
        if (t1 >= 22) {
          currentIcon = Icon(
            Icons.sunny,
            color: iconcolor2,
            size: iconsize,
          );
        } else {
          currentIcon = Icon(
            Icons.ac_unit,
            color: iconcolor2,
            size: iconsize,
          );
        }
      } else {
        currentIcon = Icon(
          Icons.sunny,
          color: iconcolor,
          size: iconsize,
        );
      }
    }
    // = t1 > t2 ? Icons.ac_unit : Icons.accessible;
    return currentIcon;
  }

  String decideBottomLabelText() {
    final t1 = widget.currentTemperature;
    final t2 = widget.setTemperature;
    if (t1 > t2) {
      return 'Cooling';
    } else {
      if (t1 == t2) {
        return 'Current Temperature';
      } else {
        return 'Heating';
      }
    }
  }

//
}
