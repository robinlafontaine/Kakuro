import 'package:flutter/material.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/Config/fonctions.dart';
import 'package:google_fonts/google_fonts.dart';

class Boutton extends StatelessWidget {
  final String value;
  final Function onPress;
  final bool? couleur;
  final double? size;

  const Boutton(
      {super.key,
      required this.value,
      required this.onPress,
      this.couleur,
      this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      child: Container(
        alignment: Alignment.center,
        width: (size == null) ? width(context) / 1.1 : size,
        height: 50,
        decoration: BoxDecoration(
            color: (couleur == null)
                ? Config.colors.primaryColor
                : Config.colors.primaryTextColor),
        child: Text(
          value,
          style: GoogleFonts.montserrat(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: (couleur == null)
                  ? Config.colors.primaryTextColor
                  : Config.colors
                      .primaryTextBackground), /*
              style: TextStyle(
                  fontSize: 19,
                  : GoogleFonts.caveatBrushTextTheme(),
                  fontWeight: FontWeight.w600,
                  color: Config.colors.primaryTextColor
              ),*/
        ),
      ),
      onTap: () => onPress(),
    ));
  }
}
