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
  final double minTemperature = 15;
  final double maxTemperature = 35;

  const LitoThermometer(
      {Key? key,
      this.onChange,
      this.onChangeStart,
      this.onChangeEnd,
      required this.currentTemperature,
      required this.setTemperature})
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

  @override
  void initState() {
    _glowingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: slowGlowDuration),
    );
    _glowingAnimation =
        Tween(begin: 20.0, end: 55.0).animate(_glowingAnimationController);
    _glowingAnimationController.addListener(() {
      setState(() {
        _litoCSApareance1 = litoCSAppearance(
          _glowingAnimation,
          isInner: false,
        );
      });
    });

    _glowAnimationDuration();

    _litoCSApareance1 = litoCSAppearance(
      _glowingAnimation,
      isInner: false,
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
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        innerSleekCircularSlider(widget.currentTemperature),
        outerSleekCircularSlider(widget.setTemperature),
      ],
    );
  }

  Widget outerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      onChange: ((value) {
        log('CHANGING: ${value.toString()}');
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
//
}
