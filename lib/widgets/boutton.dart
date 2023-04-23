import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:google_fonts/google_fonts.dart';

class boutton extends StatelessWidget{
  final String value;
  final Function onPress;

  const boutton({super.key, required this.value, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            width: width(context)/1.1,
            height: 50,
            decoration: BoxDecoration(
                color: config.colors.primaryColor
            ),
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: config.colors.primaryTextColor
              ),/*
              style: TextStyle(
                  fontSize: 19,
                  : GoogleFonts.caveatBrushTextTheme(),
                  fontWeight: FontWeight.w600,
                  color: config.colors.primaryTextColor
              ),*/
            ),
          ),
          onTap: ()=>onPress(),
        )
    );
  }

}

