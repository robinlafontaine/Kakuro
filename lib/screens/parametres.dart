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

  @override
  State<parametre> createState() => parametreState();
}

class parametreState extends State<parametre> {

  String son="";
  String etatPlayer="";
  Color pickerColor = Color(0xFFFFFFF);
  bool picker=false;

  void initState(){
    son=config.sons.sons[0];
    if(config.sons.player.state==PlayerState.playing){
      etatPlayer="play";
    }
  }

  void stopMusic(){
    config.sons.player.stop();
    setState(() {
      etatPlayer="pause";
    });
    print(etatPlayer);
  }

  void PlayBreak() {
      if(config.sons.player.state == PlayerState.playing){
        config.sons.player.pause();
        setState(() {
          etatPlayer="pause";
        });
      }else{
        if(config.sons.player.state==PlayerState.paused){
          config.sons.player.resume();
        }
        config.sons.player.play(AssetSource(son));
        setState(() {
          etatPlayer="play";
        });
      }
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
      config.colors.primarySelectItem=config.colors.primaryColor;
    });
  }

  void toPerso(){
    setState(() {
      config.colors.primaryBackground=pickerColor.withOpacity(1);
      config.colors.primaryColor = Colors.black.withOpacity(0.3);
      config.colors.primaryTextBlack=config.colors.defaultPrimaryText;
      config.colors.primarySelect=Colors.black.withOpacity(0.3);
      config.colors.primarySelectItem=config.colors.defaultPrimary;
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
                          items: config.sons.sons.map((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Container(
                                child: Text(
                                  items.replaceRange(items.length-4, items.length, ""),
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
                              etatPlayer="pause";
                              config.sons.player.stop();
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
      bottomNavigationBar: navbar(3,(){setState(() {});}),
    );
  }

}