import 'package:flutter/cupertino.dart';

class config{
  static final colors = _Color();
  static final images = _Image();
  static final audios = _Audio();
}

class _Color{
  var primaryColor = Color(0xFF464646);
  var primaryTextColor = Color(0xFFFFFFFF);
  var primaryBackground = Color(0xFFE0E0E0);
  var primaryTextBlack = Color(0xFF464646);
  var primarySelect = Color(0xFFFFFFFF);

  final caseColor = Color(0xFFFFFFFF);
  final DarkBackground = Color(0xFF303030);

  final defaultPrimary = Color(0xFF464646);
  final defaultTextBlack = Color(0xFF464646);
  final defaultPrimaryText = Color(0xFFFFFFFF);
  final defaultPrimaryTextv2 = Color(0xFFE2E2E2);
  final defaultBackground = Color(0xFFE0E0E0);
  var defaultPrimarySelect = Color(0xFFFFFFFF);
}

class _Image {
  final logo = "assets/images/logo.png";
  final icon = "assets/images/icon.png";
}

class _Audio{
  final sons = [
    "jojo.mp3",
    "quoicoubeh.mp3"
  ];
}
