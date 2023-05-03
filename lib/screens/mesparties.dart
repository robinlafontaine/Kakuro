import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/game.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/screens/multijoueur.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class mesparties extends StatefulWidget{
  @override
  State<mesparties> createState() => _mespartiesState();
}

class _mespartiesState extends State<mesparties> {
  List<String> grilles=[];
  List<String> chronos=[];
  List<String> minutes=[];
  List<String> secondes=[];
  List<String> etats=[];
  List etatSet=[];
  List<Kakuro> kakuros=[];

  void initState(){
    launch();
  }

  List setEtat(){
    List liste = [];
    for(int k=0;k<etats.length;k++) {
      liste.add(jsonDecode(etats[k]));
    }
    return liste;
  }


  String getAffichage(int n) {
    return n.toString().padLeft(2, "0");
  }

  Future<void> launch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? _grilles = await prefs.getStringList("grilles");
    List<String>? _chronos = await prefs.getStringList("chronos");
    List<String>? _etats = await prefs.getStringList("etats");
    _grilles ??= [];
    _chronos ??= [];
    _etats ??= [];
    setState(() {
      grilles=_grilles!;
      chronos=_chronos!;
      etats=_etats!;
      for(int i=0;i<grilles.length;i++){
        kakuros.add(Kakuro.withXML(grilles[i]));
        Duration duration = Duration(seconds: int.parse(chronos[i]));
        minutes.add(getAffichage(duration.inMinutes.remainder(60)));
        secondes.add(getAffichage(duration.inSeconds.remainder(60)));
      }
      etatSet = setEtat();
    });

  }

  void retour(){
    route(context, (config.online)?enligne():horsligne());
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        retour();
        return true;
      },
      child: Scaffold(
        backgroundColor: config.colors.primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, width(context) / 6),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: appbar(
                home: false,
                enjeu: false,
                retour: () => {retour()}
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: (grilles.length==0)
                  ?
                  Text("Aucune partie en cours")
                  :ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(2),
                itemCount: grilles.length,
                itemBuilder: (_,i){
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: config.colors.primaryColor
                    ),
                    width: width(context)/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Taille : (${kakuros[i].n},${kakuros[i].m})",style: TextStyle(
                              color: config.colors.primaryTextColor
                            )),
                            SizedBox(
                              height: 3,
                            ),
                            Text("Difficulté : ${kakuros[i].difficulte}",style: TextStyle(
                                color: config.colors.primaryTextColor
                            )),
                            SizedBox(
                              height: 3,
                            ),
                            Text("Chrono : ${minutes[i]}:${secondes[i]}",style: TextStyle(
                                color: config.colors.primaryTextColor
                            )),
                          ],
                        ),
                        boutton(
                            value: "JOUER",
                            couleur: true,
                            size: width(context)/3,
                            onPress: (){
                              config.newgame=false;
                              route(context, game(kakuro : kakuros[i], base: etatSet[i],index: i,chrono : int.parse(chronos[i])));
                            }
                        )
                      ],
                    ),
                  );
                }
              ),
            )
          ),
        ),
          bottomNavigationBar: navbar(actif:2, reaload:(){Navigator.push(context, MaterialPageRoute(builder: (context) => parametre())).then((value) { setState(() {});});})
      ),
    );
  }

}