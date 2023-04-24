import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:kakuro/widgets/navbar.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';

class parametre extends StatefulWidget{
  final bool online;

  parametre(this.online);

  @override
  State<parametre> createState() => parametreState();
}

class parametreState extends State<parametre> {

  void retour() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:false,enjeu:false,retour:retour),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('music'),
          onPressed: (){
            final player = AudioPlayer();
            player.play(AssetSource("jojo.mp3"));
          },
        ),
      ),
      bottomNavigationBar: navbar(3, widget.online),
    );
  }

}