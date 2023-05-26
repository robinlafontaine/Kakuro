import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:json_theme/json_theme.dart';
import 'dart:convert';

class Config {
  static final images = _Image();
  static final sons = _Audio();
  static var online = false;
  static var newgame = false;
  static ThemeData themeDefault = ThemeData.dark(useMaterial3: true);
  static ThemeData? theme = themeDefault;
  static final colors = _Color();
  static var multi = _Multi();
}

class _Color {
  var primaryColor = const Color(0xFF464646);
  var primaryTextColor = const Color(0xFFFFFFFF);
  var primaryBackground = const Color(0xFFE0E0E0);
  var primaryTextBlack = const Color(0xFF464646);
  var primarySelect = const Color(0xFFFFFFFF);
  var primaryNavIcon = const Color(0xFFE0E0E0);
  var primarySelectItem = const Color(0xFFFFFFFF);
  var primaryTitreSelect = const Color(0xFF464646);
  var primaryTextBackground = const Color(0xFF464646);

  final caseColor = const Color(0xFFFFFFFF);
  final darkBackground = const Color(0xFF303030);

  final defaultPrimary = const Color(0xFF464646);
  final defaultTextBlack = const Color(0xFF464646);
  final defaultPrimaryText = const Color(0xFFFFFFFF);
  final defaultBackground = const Color(0xFFE0E0E0);
  final defaultPrimarySelect = const Color(0xFFFFFFFF);
  final defaultNavIcon = const Color(0xFFE0E0E0);
  final defaultSelectItem = const Color(0xFFFFFFFF);
}

class Storage {
  static void storeTheme(ThemeData theme) async {
    Config.theme = theme;
    var themeJSON = ThemeEncoder.encodeThemeData(theme);
    String? themeString = json.encode(themeJSON);
    GetStorage().write("theme", themeString);
  }

  static void fetchTheme() {
    String? themeString = GetStorage().read("theme");
    if (themeString == null) {
      return;
    }
    var themeJSON = json.decode(themeString);
    ThemeData? theme = ThemeDecoder.decodeThemeData(themeJSON, validate: true);
    Config.theme = theme;
  }
}

class _Image {
  final logo = "assets/images/logo.png";
  final icon = "assets/images/Kakuro_menu.png";
  // Color 0x404040
}

class _Audio {
  var actuel = "Jojo.mp3";

  final player = AudioPlayer();
  final sons = ["Jojo.mp3", "Quoicoubeh.mp3", "MarioSlider.mp3"];
}

class _Multi {
  bool inMulti = false;
  String gameID = "";
  var n = 0;
  var m = 0;

  void setMulti(bool inMulti, String gameID, int n, int m) {
    Config.multi.inMulti = inMulti;
    Config.multi.gameID = gameID;
    Config.multi.n = n;
    Config.multi.m = m;
  }

  void clearMulti() {
    Config.multi.inMulti = false;
    Config.multi.gameID = "";
    Config.multi.n = 0;
    Config.multi.m = 0;
  }
}
