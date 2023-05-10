import 'package:flutter/material.dart';

class CaseVide extends StatelessWidget {
  final double taille;
  final bool last;

  const CaseVide(this.taille, this.last, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: last
          ? const EdgeInsets.only(right: 0)
          : const EdgeInsets.only(right: 2),
      width: taille,
      height: taille,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }
}
