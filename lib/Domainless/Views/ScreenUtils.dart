import 'package:flutter/material.dart';

mixin FormFactor {
  static double desktop = 900;
  static double tablet = 600;
  static double handset = 300;
}

enum ScreenSize { Small, Normal, Large, ExtraLarge }

ScreenSize getSize(BuildContext context) {
  final double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > FormFactor.desktop) return ScreenSize.ExtraLarge;
  if (deviceWidth > FormFactor.tablet) return ScreenSize.Large;
  if (deviceWidth > FormFactor.handset) return ScreenSize.Normal;
  return ScreenSize.Small;
}

bool isHandset(BuildContext context) =>
    MediaQuery.of(context).size.width < FormFactor.tablet;
