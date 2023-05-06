import 'dart:ui';

import 'package:flutter/material.dart';

late Size size;
late double screenWidth,
    screenHeight,
    fontSize,
    clientHeight,
    topBarSize,
    bottomBarSize;
Color defaulColor = const Color.fromRGBO(23, 28, 38, 1),
    greyColor = Color.fromARGB(255, 99, 93, 93);

double customWidth({double size = 1}) {
  return screenWidth * size;
}

double customHeight({double size = 1}) {
  return screenHeight * size;
}

double customClientHeight({double size = 1}) {
  return clientHeight * size;
}

double customFontSize({double size = 0.05}) {
  return fontSize * size;
}

void initialize(BuildContext context) {
  size = MediaQuery.of(context).size;
  screenWidth = size.width;
  topBarSize = MediaQuery.of(context).padding.top;
  bottomBarSize = MediaQuery.of(context).padding.bottom;
  screenHeight = size.height - topBarSize;
  clientHeight = screenHeight - kToolbarHeight - kBottomNavigationBarHeight;
  fontSize = (screenWidth * 0.8 + screenHeight) / 2;
}
