import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/invitation.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/widgets/boutton.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class classement extends StatefulWidget{

  @override
  State<classement> createState() => classementState();
}

class classementState extends State<classement> {

  void retour() {
    Navigator.pop(context);
  }

  var infos = [
    ["1","Maverick","5500"],
    ["2","Robinette", "4903"],
    ["3","Korantino", "12"],
    ["4","MaxiFlop", "-39"]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:false,enjeu:false,retour: ()=>{retour()}, enligne: true,),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: config.colors.primaryColor
                ),
                width: width(context)/1.1,
                child: Row(
                  children: [
                    Container(
                      width: width(context)/5, height: 40,
                      margin: EdgeInsets.only(right: 10),
                      child: Center(child: Text("RANG", style: TextStyle(color: config.colors.primaryTextColor),))
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: width(context)/2.7,height: 40,
                        child: Text("JOUEUR", style: TextStyle(color: config.colors.primaryTextColor))
                    ),
                    Container(
                        width: width(context)/3.3,height: 40,
                        child: Center(child: Text("POINTS", style: TextStyle(color: config.colors.primaryTextColor)))
                    ),
                  ],
                ),
              ),
              for(int i=0;i<infos.length;i++)
                Container(
                  width: width(context)/1.1,
                  decoration: BoxDecoration(
                    color: (i%2==0)?config.colors.primaryTextColor:Colors.white54
                  ),
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          width: width(context)/5,height: 40,
                          child: Center(child: Text(infos[i][0]))
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: width(context)/2.7,height: 40,
                          child: Text(infos[i][1])
                      ),
                      Container(
                          width: width(context)/3.3,height: 40,
                          child: Center(child: Text(infos[i][2]))
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: navbar(10, true),
    );
  }


}