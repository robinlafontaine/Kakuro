import 'package:flutter/material.dart';

class MyThemeData extends InheritedWidget {
  final ThemeData themeData;
  final ValueChanged<ThemeData> onThemeUpdated;

  const MyThemeData({
    Key? key,
    required this.themeData,
    required this.onThemeUpdated,
    required Widget child,
  }) : super(key: key, child: child);

  static MyThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyThemeData>()!;
  }

  @override
  bool updateShouldNotify(MyThemeData oldWidget) {
    return oldWidget.themeData != themeData;
  }

  void updateTheme(ThemeData newTheme) {
    onThemeUpdated(newTheme);
  }
}
