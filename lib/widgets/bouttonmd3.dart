import 'package:flutter/material.dart';

import '../Config/fonctions.dart';

class BouttonMd3 extends StatelessWidget {
  final onTap;
  final String text;

  const BouttonMd3({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.20,
        ),
        minimumSize: Size(
          width(context) * 0.90,
          height(context) * 0.08,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
