import 'package:flutter/material.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:kakuro/widgets/navbar.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';

class abandon extends StatefulWidget{
  final bool online;

  abandon(this.online);

  @override
  State<abandon> createState() => _abandonState();
}

class _abandonState extends State<abandon> {

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("T'AS LES CRAMPTE ? APAGNAN ! QUOICOUBEH QUOICOUBEH QUOICOUBEH",
              style: TextStyle(
                fontSize: width(context)/18,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 30,),
            boutton(value: "OUI", onPress: (){
              route(context, horsligne());
            }),
            SizedBox(height: 10,),
            boutton(value: "NON", onPress: (){
              retour();
            })
          ],
        ),
      ),
      bottomNavigationBar: navbar(10, widget.online),
    );
  }
}