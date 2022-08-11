import 'package:flutter/material.dart';
import 'package:flutter_sleek_circular_slider/doubleCircularSlider/double_sleek_theme.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:math' as math;

class LitoSleekCircularSlider extends StatefulWidget {
  final OnChange? onChange;
  final OnChange? onChangeStart;
  final OnChange? onChangeEnd;
  final double innerValue;
  final double outerValue;
  final Icon? icon;
  final String? extraLabelText;
  final String? bottomLabelText;
  final String? topLabelText;
  final String? mainLabelTextSymbol;
  final double? minValue;
  final double? maxValue;
  final bool? isSecondDobleCircular;

  const LitoSleekCircularSlider({
    Key? key,
    this.onChange,
    this.onChangeStart,
    this.onChangeEnd,
    required this.innerValue,
    required this.outerValue,
    this.topLabelText,
    this.bottomLabelText,
    this.mainLabelTextSymbol = '%',
    this.minValue = 0,
    this.maxValue = 100,
    this.isSecondDobleCircular = false,
    this.extraLabelText,
    this.icon,
  }) : super(key: key);

  @override
  State<LitoSleekCircularSlider> createState() => _LitoSleekCircularSlider();
}

class _LitoSleekCircularSlider extends State<LitoSleekCircularSlider>
    with SingleTickerProviderStateMixin {
  //to make changes in the appearance meanwhile is working
  late CircularSliderAppearance _litoCSApareance1;
  // late CircularSliderAppearance _litoCSApareance2;

  //customized glow with animation
  late AnimationController _glowingAnimationController;
  late Animation _glowingAnimation;
  Color progressBarColor = Colors.amberAccent;
  int slowGlowDuration = 2000;
  int fastGlowDuration = 500;
  double outerValue = 0;
  bool isSDCS = false;

  @override
  void initState() {
    outerValue = widget.outerValue;
    isSDCS = widget.isSecondDobleCircular ?? isSDCS;

    _glowingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: slowGlowDuration),
    );
    _glowingAnimation =
        Tween(begin: 18.0, end: 22.0).animate(_glowingAnimationController);
    _glowingAnimationController.addListener(() {
      setState(() {
        _litoCSApareance1 = litoDobleCircularSliderAppearance(
          _glowingAnimation,
          isInner: false,
          isSecondDobleCircular: widget.isSecondDobleCircular,
          outerBarColor: progressBarColor,
          topLabelText: widget.topLabelText,
          bottomLabelText: widget.bottomLabelText,
        );
      });
    });

    _glowAnimationDuration();

    _litoCSApareance1 = litoDobleCircularSliderAppearance(
      _glowingAnimation,
      isInner: false,
      isSecondDobleCircular: widget.isSecondDobleCircular,
      outerBarColor: progressBarColor,
      topLabelText: widget.topLabelText,
      bottomLabelText: widget.bottomLabelText,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant LitoSleekCircularSlider oldWidget) {
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
    return litoDobleSleekCircularSlider();
  }

  void _glowAnimationDuration() {
    int animationDuration = fastGlowDuration;
    if (widget.innerValue == widget.outerValue) {
      animationDuration = slowGlowDuration;
    }
    _glowingAnimationController.duration =
        Duration(milliseconds: animationDuration);
    _glowingAnimationController.repeat(reverse: true);
  }

  Widget litoDobleSleekCircularSlider() {
    return Transform(
      alignment: Alignment.center,
      transform: isSDCS ? Matrix4.rotationY(math.pi) : Matrix4.rotationY(0),
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    innerSleekCircularSlider(widget.innerValue),
                    outerSleekCircularSlider(widget.outerValue),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: isRightIcon(),
              )
            ],
          ),
          isExtraText(),
        ],
      ),
    );
  }

  Widget outerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      onChange: widget.onChange,
      onChangeStart: widget.onChangeStart,
      onChangeEnd: widget.onChangeEnd,
      appearance: _litoCSApareance1,
      min: widget.minValue ?? 0,
      max: widget.maxValue ?? 100,
      initialValue: temperature,
    );
  }

  Widget innerSleekCircularSlider(double temperature) {
    return SleekCircularSlider(
      appearance: litoDobleCircularSliderAppearance(
        _glowingAnimation,
        isInner: true,
        isSecondDobleCircular: widget.isSecondDobleCircular,
      ),
      min: widget.minValue ?? 0,
      max: widget.maxValue ?? 100,
      initialValue: temperature,
    );
  }

  Widget isRightIcon() {
    if (widget.icon != null && !isSDCS) {
      return Container(
        margin: const EdgeInsets.only(
          left: 250,
        ),
        child: widget.icon,
      );
    }
    return Container();
  }

  Widget isExtraText() {
    if (widget.extraLabelText != null && !isSDCS) {
      return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Text('${widget.extraLabelText}'),
      );
    }
    return Container();
  }

//
}
