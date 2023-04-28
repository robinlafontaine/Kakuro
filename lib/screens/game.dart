import 'dart:async';
import 'package:kakuro/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:kakuro/widgets/navbar.dart';

class game extends StatefulWidget{
  final Kakuro kakuro;
  final bool online;

  game(this.kakuro,this.online);

  @override State<game> createState() => _gameState(kakuro);
}

class _gameState extends State<game> {
  Kakuro kakuro;
  List grille=[];
  int seconde=0;
  Timer? timer;
  Duration duration = Duration();
  _gameState(this.kakuro);

  void initState(){
    grille = kakuro.getBase();
    startTimer();
    print(kakuro.grille);
  }

  void addPoints(){
    int puntos = (20*(kakuro.n +kakuro.m +kakuro.difficulte) -seconde) as int ;
    Leaderboard.addNewScore(puntos);
    route(context, (widget.online)?enligne():horsligne());
  }

  void testValide(){
    bool valide=true;
    for(int i=0;i<kakuro.n;i++){
      for(int j=0;j<kakuro.m;j++){
        if(grille[i][j]!=kakuro.grille[i][j]){
          valide=false;
          break;
        }
      }
    }
    if(valide)addPoints();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    seconde +=1;
  }

  void maj(int i,int j,int valeur){
    this.grille[i][j] = valeur;
  }

  void retour(){
    route(context, nouvellepartie(widget.online));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:false,enjeu:true,retour:this.retour, enligne: widget.online),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: height(context)/10,
            ),
            Center(
              child: scene(kakuro,maj),
            ),
            SizedBox(
              height: 30,
            ),
            boutton(
                value: "VALIDER",
                onPress: (){
                  testValide();
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: navbar(10,widget.online,
        (){
        Navigator.push(
        context,
            MaterialPageRoute(builder: (context) => parametre(widget.online,widget))).then((value) { setState(() {});});}
      ));
  }


}