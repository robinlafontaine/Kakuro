import 'dart:async';
import 'package:kakuro/config/fonctions.dart';
import 'package:flutter/material.dart';

class splashwidget extends StatelessWidget{
  final int time;
  final Widget child, nextpage;

  const splashwidget(
      {Key? key, this.time = 3, required this.child, required this.nextpage})
      : super(key : key);
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: time), () {
      route(context, nextpage, close: true);
    });
    return child;
  }

}