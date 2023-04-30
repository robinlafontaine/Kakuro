import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  var player;
  final widgetBack;

  parametre(this.online,this.widgetBack,this.player);

  @override
  State<parametre> createState() => parametreState();
}

class parametreState extends State<parametre> {

  var themes = ["Light", "Dark"];
  String theme="";
  String son="";
  var player = AudioPlayer();
  String etatPlayer="";
  Color pickerColor = Color(0xFFFFFFF);
  bool picker=false;

  void initState(){
    player = widget.player;
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

  void toLight(){
    setState(() {
      config.colors.primaryColor=config.colors.defaultPrimary;
      config.colors.primaryBackground=config.colors.defaultBackground;
      config.colors.primaryTextBlack=config.colors.defaultTextBlack;
      config.colors.primarySelect=config.colors.defaultPrimarySelect;
    });
  }

  void toDark(){
    setState(() {
      config.colors.primaryColor=config.colors.defaultPrimary;
      config.colors.primaryBackground=config.colors.DarkBackground;
      config.colors.primaryTextBlack=config.colors.defaultPrimaryText;
      config.colors.primarySelect=config.colors.primaryColor;
    });
  }

  void toPerso(){
    setState(() {
      config.colors.primaryBackground=pickerColor;
      config.colors.primaryColor = Colors.black.withOpacity(0.3);
      config.colors.primaryTextBlack=config.colors.defaultPrimaryText;
      config.colors.primarySelect=Colors.black.withOpacity(0.3);
      picker=false;
    });
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: (picker)?
            Container(
              width: width(context)/1.1,
              decoration: BoxDecoration(
                color: config.colors.defaultPrimaryText
              ),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: boutton(value: "APPLIQUER", onPress: (){
                            toPerso();
                          })
                      )
                    ],
                  ),
              ),
            ):
            Column(
              children: [
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
                  children: [
                    InkWell(
                      child: Container(
                        height: width(context)/6,
                        width: (width(context)/3) - 10,
                        decoration: BoxDecoration(
                          color: config.colors.primarySelect,
                          border: Border(
                            right: BorderSide(width: 2,color: config.colors.primaryBackground)
                          )
                        ),
                        child: Center(
                          child:Icon(
                            Icons.wb_sunny,
                            size: width(context)/15,
                            color: config.colors.primaryTextBlack,
                          )
                        ),
                      ),
                      onTap: (){
                        toLight();
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: width(context)/6,
                        width:(width(context)/3) - 10,
                        decoration: BoxDecoration(
                            color: config.colors.primarySelect,
                            border: Border(
                                right: BorderSide(width: 2,color: config.colors.primaryBackground)
                            )
                        ),
                        child: Center(
                            child:Icon(
                              Icons.format_paint,
                              size: width(context)/15,
                              color: config.colors.primaryTextBlack,
                            )
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          picker=true;
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: width(context)/6,
                        width: (width(context)/3) - 10,
                        decoration: BoxDecoration(
                            color: config.colors.primarySelect,
                        ),
                        child: Center(
                            child:FaIcon(
                              FontAwesomeIcons.solidMoon,
                              size: width(context)/15,
                              color: config.colors.primaryTextBlack,
                            )
                        ),
                      ),
                      onTap: (){
                        toDark();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: navbar(3, widget.online,(){setState(() {});},widget.player),
    );
  }

}