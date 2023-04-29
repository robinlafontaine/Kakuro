import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/screens/enligne.dart';
import 'package:kakuro/screens/horsligne.dart';
import 'package:kakuro/screens/nouvellepartie.dart';
import 'package:kakuro/widgets/boutton.dart';
import 'package:kakuro/widgets/navbar.dart';

import '../config/fonctions.dart';
import '../widgets/appbar.dart';

class parametre extends StatefulWidget{
  final bool online;
  final widgetBack;

  parametre(this.online,this.widgetBack);

  @override
  State<parametre> createState() => parametreState();
}

class parametreState extends State<parametre> {

  var themes = ["Light", "Dark"];
  String theme="";
  String son="";
  var player = AudioPlayer();
  String etatPlayer="";

  void initState(){
    son=config.audios.sons[0];
    theme=themes[1];
    if(config.colors.primaryBackground==config.colors.defaultBackground){
      theme=themes[0];
    }

  }

  void stopMusic(){
    player.stop();
    setState(() {
      etatPlayer="pause";
    });
  }

  void PlayBreak() {
      print(son);
      if(player.state == PlayerState.playing){
        player.pause();
        setState(() {
          etatPlayer="pause";
        });
      }else{
        if(player.state==PlayerState.paused){
          player.resume();
        }
        player.play(AssetSource(son));
        setState(() {
          etatPlayer="play";
        });
      }
      print(etatPlayer);
  }

  void retour() {
    Navigator.pop(context);
  }

  void changeTheme(){
    setState(() {
      if(theme==themes[1]){
        config.colors.primaryBackground=config.colors.DarkBackground;
        config.colors.primaryTextBlack=config.colors.defaultPrimaryText;
        config.colors.primarySelect=config.colors.primaryColor;
      }else{
        config.colors.primaryBackground=config.colors.defaultBackground;
        config.colors.primaryTextBlack=config.colors.defaultTextBlack;
        config.colors.primarySelect=config.colors.defaultPrimarySelect;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context)/6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(home:false,enjeu:false,retour:retour),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: height(context)/10,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: config.colors.primarySelect
                  ),
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        dropdownColor: config.colors.primarySelect,
                        value: son,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: config.colors.primaryTextBlack,
                        ),
                        items: config.audios.sons.map((items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Container(
                              child: Text(
                                items,
                                style: TextStyle(
                                    color: config.colors.primaryTextBlack
                                ),
                              ),
                              width: width(context)/2.5,),
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            value == null?"":
                            son = value;
                            player.stop();
                            etatPlayer = "";
                          });
                        }
                    ),
                  ),
                ),
                Container(
                  width: width(context)/7,
                  height: width(context)/7,
                  decoration: BoxDecoration(
                    color: config.colors.primarySelect
                  ),
                  child: Center(
                    child: InkWell(
                      child: Icon(
                        (etatPlayer=="play")?Icons.pause:Icons.play_arrow,
                        size: width(context)/15,
                        color: config.colors.primaryTextBlack,
                      ),
                      onTap: (){
                        PlayBreak();
                      },
                    ),
                  ),
                ),
                Container(
                  width: width(context)/7,
                  height: width(context)/7,
                  decoration: BoxDecoration(
                      color: config.colors.primarySelect
                  ),
                  child: Center(
                    child: InkWell(
                      child: Icon(
                        Icons.square,
                        size: width(context)/20,
                        color: config.colors.primaryTextBlack,
                      ),
                      onTap: (){
                        stopMusic();
                      },
                    ),
                  ),
                )
                ]
              ),
              SizedBox(height:height(context)/20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: config.colors.primarySelect
                    ),
                    padding: EdgeInsets.only(left: 15, right: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: config.colors.primarySelect,
                          value: theme,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: config.colors.primaryTextBlack,
                          ),
                          items: themes.map((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Container(
                                child: Text(
                                  items,
                                  style: TextStyle(
                                      color: config.colors.primaryTextBlack
                                  ),
                                ),
                                width: width(context)/2.5,),
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              value == null?"":
                              theme = value;
                            });
                          }
                      ),
                    ),
                  ),
                  Container(
                    width: width(context)/3,
                    height: width(context)/7,
                    decoration: BoxDecoration(
                        color: config.colors.primarySelect
                    ),
                    child: Center(
                      child: InkWell(
                        child: Icon(
                          Icons.ads_click,
                          size: width(context)/20,
                          color: config.colors.primaryTextBlack,
                        ),
                        onTap: (){
                          changeTheme();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: navbar(3, widget.online,(){setState(() {});}),
    );
  }

}