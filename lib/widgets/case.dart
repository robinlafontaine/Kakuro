import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';

class Case extends StatefulWidget {
  final int valeur;
  final int ligne;
  final int colonne;
  final double taille;
  final bool last;
  final Function maj;

  const Case(
      this.valeur, this.ligne, this.colonne, this.taille, this.last, this.maj,
      {super.key});

  @override
  State<Case> createState() => CaseState(valeur, ligne, colonne, taille, maj);
}

class CaseState extends State<Case> {
  int ligne, colonne;
  double taille;
  int valeur;
  Function maj;
  CaseState(this.valeur, this.ligne, this.colonne, this.taille, this.maj);

  void add() {
    setState(() {
      if (valeur == 9) {
        valeur = 1;
      } else {
        valeur += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          margin: widget.last ? null : const EdgeInsets.only(right: 2),
          width: taille,
          height: taille,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer),
          child: Center(
            child: (valeur == 0)
                ? null
                : Text(
                    valeur.toString(),
                    style: TextStyle(fontSize: taille * 0.5, color: Colors.red),
                  ),
          ),
        ),
        onTap: () {
          add();
          maj(ligne, colonne, valeur);
        });
  }
}
