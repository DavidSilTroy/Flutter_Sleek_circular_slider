import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

CircularSliderAppearance litoCSAppearance(
  Animation glowingAnimation, {
  bool isInner = false,
  int oTemperature = 20,
  int iTemperature = 19,
  final String? topLabelText,
  final String? bottomLabelText,
}) {
  return CircularSliderAppearance(
    infoProperties: InfoProperties(
      modifier: (value) {
        final roundedValue = value.ceil().toInt().toString();
        return isInner ? '' : '$roundedValue°C';
      },
      topLabelText: isInner ? '' : topLabelText,
      // topLabelStyle: TextStyle(fontFamily: ''),
      bottomLabelText: isInner ? '' : bottomLabelText,
    ),
    customWidths: CustomSliderWidths(
      progressBarWidth: isInner ? 10 : 15,
      trackWidth: isInner ? 0.1 : 3,
      shadowWidth: isInner ? 0 : glowingAnimation.value,
      handlerSize: isInner ? 0 : 5,
    ),
    customColors: CustomSliderColors(
      trackColor: const Color.fromARGB(119, 189, 189, 189),
      progressBarColor: isInner ? Colors.yellow[800] : Colors.amberAccent,
      shadowColor: Colors.amberAccent.shade100,
    ),
    // spinnerMode: true,
    size: !isInner ? 250 : 215,
    startAngle: 270,
    angleRange: 360,
  );
}
