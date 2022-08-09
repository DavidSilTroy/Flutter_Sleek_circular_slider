import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

CircularSliderAppearance litoCSAppearance(
  Animation glowingAnimation, {
  Color outerBarColor = Colors.amberAccent,
  bool isInner = false,
  int oTemperature = 20,
  int iTemperature = 19,
  final String? topLabelText,
  final String? bottomLabelText,
}) {
  TextStyle litoThTextStyle({double fontSize = 16, bool isInner = false}) {
    return TextStyle(
      fontFamily: 'Work Sans',
      fontSize: fontSize,
      fontWeight: isInner ? FontWeight.bold : FontWeight.w100,
      height: isInner ? 0.5 : 1,
    );
  }

  return CircularSliderAppearance(
    infoProperties: InfoProperties(
      modifier: (value) {
        final roundedValue = value.ceil().toInt().toString();
        return isInner ? '$roundedValue    ' : '   °C';
      },
      topLabelText: isInner ? '' : topLabelText,
      bottomLabelText: isInner ? '' : bottomLabelText,
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
      progressBarWidth: isInner ? 10 : 15,
      trackWidth: isInner ? 0.1 : 3,
      shadowWidth: isInner ? 0 : glowingAnimation.value,
      handlerSize: isInner ? 0 : 5,
    ),
    customColors: CustomSliderColors(
      trackColor: const Color.fromARGB(119, 189, 189, 189),
      progressBarColor:
          isInner ? const Color.fromARGB(255, 71, 71, 59) : outerBarColor,
      shadowColor: outerBarColor.withOpacity(0.5).withAlpha(150),
    ),
    // spinnerMode: true,
    size: !isInner ? 250 : 215,
    startAngle: 270,
    angleRange: 360,
  );
}

Color decideBarColor(double value) {
  if (value < 20) {
    return const Color.fromARGB(255, 7, 61, 237);
  } else {
    if (value > 27) {
      return Color.fromARGB(255, 245, 255, 46);
    } else {
      return Color.fromARGB(255, 58, 182, 58);
    }
  }
}
