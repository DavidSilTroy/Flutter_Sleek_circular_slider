import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

CircularSliderAppearance litoDobleCircularSliderAppearance(
  Animation glowingAnimation, {
  Color outerBarColor = Colors.amberAccent,
  Color innerBarColor = Colors.blueGrey,
  Color outerShadowBarColor = const Color.fromARGB(126, 202, 169, 51),
  Color innerShadowBarColor = const Color.fromARGB(129, 173, 228, 252),
  bool showTwoCircles = true,
  bool isInner = false,
  bool? isSecondDobleCircular = false,
  final String? topLabelText,
  final String? bottomLabelText,
  final String? topLabelTextSymbol = '%',
}) {
  TextStyle litoThTextStyle({double fontSize = 16, bool isInner = false}) {
    return TextStyle(
      fontFamily: 'Work Sans',
      fontSize: fontSize,
      fontWeight: isInner ? FontWeight.bold : FontWeight.w100,
      height: isInner ? 0.5 : 1,
    );
  }

  final isSDC = isSecondDobleCircular ?? false;

  return CircularSliderAppearance(
    infoProperties: InfoProperties(
      modifier: (value) {
        if (!isSDC) {
          final roundedValue = value.ceil().toInt();
          final innerText =
              roundedValue > 99 ? '$roundedValue   ' : '$roundedValue  ';
          final outerText = roundedValue > 99
              ? '     $topLabelTextSymbol'
              : '    $topLabelTextSymbol';
          return isInner ? innerText : outerText;
        }
        return '';
      },
      topLabelText: isSDC
          ? ''
          : isInner
              ? ''
              : topLabelText,
      bottomLabelText: isSDC
          ? ''
          : isInner
              ? ''
              : bottomLabelText,
      topLabelStyle: litoThTextStyle(),
      bottomLabelStyle: litoThTextStyle(),
      mainLabelStyle: isInner
          ? litoThTextStyle(
              fontSize: 48,
              isInner: isInner,
            )
          : litoThTextStyle(
              fontSize: 48,
            ),
    ),
    customWidths: CustomSliderWidths(
      progressBarWidth: 8,
      trackWidth: 3.5,
      shadowWidth: glowingAnimation.value,
      handlerSize: 0,
    ),
    customColors: CustomSliderColors(
      trackColor: const Color.fromARGB(119, 189, 189, 189),
      progressBarColor: isInner ? innerBarColor : outerBarColor,
      shadowColor: isInner ? innerShadowBarColor : outerShadowBarColor,
    ),
    // spinnerMode: true,
    size: isInner ? 210 : 250,
    startAngle: 270,
    angleRange: 360,
  );
}
