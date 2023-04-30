import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class config{
  static final colors = _Color();
  static final images = _Image();
  static final sons = _Audio();
  static var online = false;
}

class _Color{
  var primaryColor = Color(0xFF464646);
  var primaryTextColor = Color(0xFFFFFFFF);
  var primaryBackground = Color(0xFFE0E0E0);
  var primaryTextBlack = Color(0xFF464646);
  var primarySelect = Color(0xFFFFFFFF);
  var primaryNavIcon = Color(0xFFE0E0E0);
  var primarySelectItem = Color(0xFFFFFFFF);

  final caseColor = Color(0xFFFFFFFF);
  final DarkBackground = Color(0xFF303030);

  final defaultPrimary = Color(0xFF464646);
  final defaultTextBlack = Color(0xFF464646);
  final defaultPrimaryText = Color(0xFFFFFFFF);
  final defaultBackground = Color(0xFFE0E0E0);
  final defaultPrimarySelect = Color(0xFFFFFFFF);
  final defaultNavIcon = Color(0xFFE0E0E0);
  final defaultSelectItem = Color(0xFFFFFFFF);
}

class _Image {
  final logo = "assets/images/logo.png";
  final icon = "assets/images/icon.png";
}

class _Audio{
  final player = AudioPlayer();
  final sons = [
    "Jojo.mp3",
    "Quoicoubeh.mp3",
    "MarioSlider.mp3"
  ];
}

