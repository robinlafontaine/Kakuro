import 'package:flutter/cupertino.dart';

class config{
  static final colors = _Color();
  static final images = _Image();
  static final audios = _Audio();
}

class _Color{
  final primaryColor = Color(0xFF464646);
  final primaryTextColor = Color(0xFFFFFFFF);
  final caseColor = Color(0xFFFFFFFF);
  final gris = Color(0xFFE0E0E0);
  final actifnav = Color(0xFFD22626);
}

class _Image {
  final logo = "assets/images/logo.png";
  final icon = "assets/images/icon.png";
}

class _Audio{
  final jojo = "assets/audio/jojo.mp3";
}
