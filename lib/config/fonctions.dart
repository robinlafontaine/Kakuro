import 'package:flutter/material.dart';

route(context, widget, {bool close = false}) => close
    ? Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: const Duration(seconds: 0),
        ),
        (route) => false)
    : Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: const Duration(seconds: 0),
      ));

width(context) => MediaQuery.of(context).size.width;
height(context) => MediaQuery.of(context).size.height;
