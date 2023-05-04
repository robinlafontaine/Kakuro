import 'dart:async';
import 'dart:convert';
import 'package:kakuro/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/kakuro.dart';
import 'package:kakuro/leaderboard.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/screens/parametres.dart';
import 'package:kakuro/screens/scene.dart';
import 'package:kakuro/widgets/appbar.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu.dart';
import 'mesparties.dart';

class game extends StatefulWidget{
  final Kakuro kakuro;
  final List? base;
  final int? index;
  final int? chrono;

  const game({super.key, required this.kakuro, this.base, this.index, this.chrono});


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
    if(widget.base==null && widget.chrono==null){
      grille = kakuro.getBase();
    }else{
      seconde = widget.chrono!;
      grille = widget.base!;
    }
    startTimer();
  }

  void addPoints(){
    int puntos = (20*(kakuro.n +kakuro.m +kakuro.difficulte) -seconde) as int ;
    Leaderboard.addNewScore(puntos);
  }

  String getEtat(){
    var s = json.encode(grille);
    return s;
  }

  Future<void> saveGrille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? grilles = await prefs.getStringList("grilles");
    List<String>? chronos = await prefs.getStringList("chronos");
    List<String>? etats = await prefs.getStringList("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.add(kakuro.toXML());
    chronos.add(seconde.toString());
    String etatsActuel = getEtat();
    etats.add(etatsActuel);
    await prefs.setStringList('grilles', grilles);
    await prefs.setStringList('chronos', chronos);
    await prefs.setStringList('etats', etats);

  /*  await prefs.setStringList('grilles', []);
    await prefs.setStringList('chronos', []);
    await prefs.setStringList('etats', []);*/
  }

  Future<void> majGrille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? etats = await prefs.getStringList("etats");
    List<String>? chronos = await prefs.getStringList("chronos");
    etats ??= [];
    chronos ??= [];
    String etatsActuel = getEtat();
    String chronoActuel = seconde.toString();
    etats[widget.index!]=etatsActuel;
    chronos[widget.index!]=chronoActuel;
    await prefs.setStringList('etats', etats);
    await prefs.setStringList('chronos', chronos);
  }

  Future<void> suppGrille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? grilles = await prefs.getStringList("grilles");
    List<String>? chronos = await prefs.getStringList("chronos");
    List<String>? etats = await prefs.getStringList("etats");
    grilles ??= [];
    chronos ??= [];
    etats ??= [];
    grilles.remove(grilles[widget.index!]);
    chronos.remove(chronos[widget.index!]);
    etats.remove(etats[widget.index!]);
    await prefs.setStringList('grilles', grilles);
    await prefs.setStringList('chronos', chronos);
    await prefs.setStringList('etats', etats);
  }

  void testValide(){
    bool valide=true;
    for(int i=0;i<kakuro.n;i++){
      for(int j=0;j<kakuro.m;j++){
        if(grille[i][j]!=kakuro.grilleUpdated[i][j]){
          valide=false;
          break;
        }
      }
    }
    if(valide){
      addPoints();
      if(config.newgame==false) suppGrille();
      route(context, menu());
    }
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
    if(config.newgame){
      saveGrille();
      route(context, nouvellepartie());
    }else{
      majGrille();
      route(context, mesparties());
    }
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
          preferredSize: Size(double.infinity, width(context)/6),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: appbar(home:false,enjeu:true,retour:this.retour,chrono : widget.chrono, abandon: openDialogAbandon,),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: height(context)/10,
              ),
              Center(
                child:
                (widget.base==null)?
                  scene(kakuro:kakuro,maj:maj):
                  scene(kakuro:kakuro,maj:maj,base: widget.base)
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
        bottomNavigationBar: navbar(
            actif:10,
            checkGrille: (){
              (config.newgame)
                  ?saveGrille()
                  :majGrille();
              } ,
            reaload:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => parametre())).then((value) { setState(() {});});})
      ),
    );
  }

  Future openDialogAbandon() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Abandon'),
        content: Text('Etes-vous sûr de vouloir abandonner cette partie ?'),
        actions: [
          TextButton(onPressed: (){
            if(config.newgame==true){
              route(context, nouvellepartie());
            }else{
              suppGrille().then((value) => route(context, mesparties()));
            }
          }, child: Text("Oui",style: TextStyle(color: config.colors.defaultPrimary),)),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("NON",style: TextStyle(color: config.colors.defaultPrimary),))
        ],
      )
  );


}