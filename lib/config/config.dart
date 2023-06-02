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
  static var wingame = false;
  static ThemeData themeDefault = ThemeData(
      colorScheme: ColorScheme(
        primary: Color(0xFF000000),
        secondary: Color(0xFF404040),
        surface: Color(0xFF404040),
        background: Color(0xFFE0E0E0),
        error: Colors.red,
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
        onBackground: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        brightness: Brightness.dark,
      ),
      useMaterial3: true);
  static ThemeData? theme = themeDefault;
  static var multi = _Multi();
  static bool isReloading = false;
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
  var actuel = "loop.mp3";
  bool paused = false;

  final player = AudioPlayer();
  final sons = ["loop.mp3"];
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
