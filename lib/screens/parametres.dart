import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/widgets/Boutton.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:dynamic_color/dynamic_color.dart';

import '../auth.dart';
import '../Config/fonctions.dart';
import '../widgets/appbar.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => ParametreState();
}

class ParametreState extends State<Parametre> {
  String son = "";
  String etatPlayer = "";
  Color pickerColor = const Color(0x0fffffff);
  bool picker = false;

  @override
  void initState() {
    super.initState();
    son = Config.sons.actuel;
    if (Config.sons.player.state == PlayerState.playing) {
      etatPlayer = "play";
    }
  }

  void stopMusic() {
    Config.sons.player.stop();
    setState(() {
      etatPlayer = "pause";
    });
    if (kDebugMode) {
      print(etatPlayer);
    }
  }

  void playBreak() {
    if (Config.sons.player.state == PlayerState.playing) {
      Config.sons.player.pause();
      setState(() {
        etatPlayer = "pause";
      });
    } else {
      if (Config.sons.player.state == PlayerState.paused) {
        Config.sons.player.resume();
      }
      Config.sons.player.play(AssetSource(son));
      setState(() {
        etatPlayer = "play";
      });
    }
  }

  void retour() {
    Navigator.pop(context);
  }

  void toLight() {
    setState(() {
      Config.colors.primaryColor = Config.colors.defaultPrimary;
      Config.colors.primaryBackground = Config.colors.defaultBackground;
      Config.colors.primaryTextBlack = Config.colors.defaultTextBlack;
      Config.colors.primarySelect = Config.colors.defaultPrimarySelect;
      Config.colors.primaryTitreSelect = Config.colors.defaultTextBlack;
      Config.colors.primaryTextBackground = Config.colors.primaryColor;
    });
  }

  void toDark() {
    setState(() {
      ThemeData theme = Theme.of(context);
      Config.colors.primaryColor = theme.colorScheme.primary;
      Config.colors.primaryBackground = theme.colorScheme.primaryVariant;
      Config.colors.primaryTextBlack = theme.colorScheme.onPrimary;
      Config.colors.primarySelect = theme.colorScheme.primary;
      Config.colors.primarySelectItem = theme.colorScheme.primary;
      Config.colors.primaryTitreSelect = theme.colorScheme.onPrimary;
      Config.colors.primaryTextBackground = theme.colorScheme.primary;
    });
  }

  void toPerso() {
    setState(() {
      Config.colors.primaryBackground = pickerColor.withOpacity(1);
      if (pickerColor.red > 200 &&
          pickerColor.green > 200 &&
          pickerColor.blue > 200) {
        Config.colors.primaryColor = Config.colors.defaultPrimary;
        Config.colors.primarySelect = Config.colors.defaultPrimary;
        Config.colors.primaryTextBlack = Config.colors.defaultPrimaryText;
        Config.colors.primarySelectItem = Config.colors.defaultPrimary;
        Config.colors.primaryTitreSelect = Config.colors.defaultTextBlack;
        Config.colors.primaryTextBackground = Config.colors.primaryColor;
      } else {
        Config.colors.primarySelect = Colors.black.withOpacity(0.3);
        Config.colors.primaryColor = Colors.black.withOpacity(0.3);
        Config.colors.primaryTextBlack = Config.colors.defaultPrimaryText;
        Config.colors.primarySelectItem = Config.colors.defaultPrimary;
        Config.colors.primaryTitreSelect = Config.colors.defaultPrimaryText;
        Config.colors.primaryTextBackground = Config.colors.primaryBackground;
      }
      picker = false;
    });
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        retour();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, width(context) / 6),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Appbar(home: false, enjeu: false, retour: retour),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: (picker)
                  ? Container(
                      width: width(context) / 1.1,
                      decoration: BoxDecoration(
                          color: Config.colors.defaultPrimaryText),
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
                                child: Boutton(
                                    value: "APPLIQUER",
                                    onPress: () {
                                      toPerso();
                                    }))
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: width(context) / 8,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      dropdownColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      value: son,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Config.colors.primaryTextBlack,
                                      ),
                                      items: Config.sons.sons.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: SizedBox(
                                            width: width(context) / 2.5,
                                            child: Text(
                                              items.replaceRange(
                                                  items.length - 4,
                                                  items.length,
                                                  ""),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          value == null ? "" : son = value;
                                          Config.sons.actuel = value!;
                                          etatPlayer = "pause";
                                          Config.sons.player.stop();
                                        });
                                      }),
                                ),
                              ),
                              ElevatedButton(
                                // play button
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  minimumSize: Size(
                                    width(context) / 15,
                                    width(context) / 15,
                                  ),
                                ),
                                onPressed: () {
                                  playBreak();
                                },
                                child: Icon(
                                  (etatPlayer == "play")
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: width(context) / 20,
                                  color: Config.colors.primaryTextBlack,
                                ),
                              ),
                              ElevatedButton(
                                // circular shape for stop button
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  minimumSize: Size(
                                    width(context) / 15,
                                    width(context) /
                                        15, // button width and height
                                  ),
                                ),
                                onPressed: () {
                                  stopMusic();
                                },
                                child: Icon(
                                  Icons.stop,
                                  size: width(context) / 20,
                                  color: Config.colors.primaryTextBlack,
                                ),
                              ),
                            ]),
                        SizedBox(height: height(context) / 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                toLight();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                padding: EdgeInsets.symmetric(
                                  horizontal: (width(context)) * 0.1,
                                  vertical: width(context) / 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: FaIcon(
                                Icons.wb_sunny,
                                size: width(context) / 20,
                                color: Config.colors.primaryTextBlack,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  picker = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                padding: EdgeInsets.symmetric(
                                  horizontal: (width(context)) * 0.1,
                                  vertical: width(context) / 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: FaIcon(
                                Icons.format_paint,
                                size: width(context) / 20,
                                color: Config.colors.primaryTextBlack,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                toDark();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                padding: EdgeInsets.symmetric(
                                  horizontal: (width(context)) * 0.1,
                                  vertical: width(context) / 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.solidMoon,
                                size: width(context) / 20,
                                color: Config.colors.primaryTextBlack,
                              ),
                            )
                          ],
                        ),

                        Row(
                          children: [
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              thickness: 2,
                              // put adaptive height to the divider to make it responsive to the screen size and put it at the bottom of the page
                              height: height(context) / 4,
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Auth(FirebaseAuth.instance)
                                  .signOutGoogle(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: const Text("SIGN OUT")),
                        TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Config.colors.primaryTextBlack,
                              ),
                            ),
                            onPressed: () {
                              throw Exception();
                            },
                            child: const Text("Throw Test Exception")),
                        // put space to the bottom of the page
                        // TODO: A REMPLACER PAR SPACER
                        // const Spacer(),
                        TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Config.colors.primaryTextBlack,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text("Développeurs"),
                                        content: const Text(
                                            "Ce projet a été réalisé par : \n\n- Robin Lafontaine\n- Korantin Varnière\n- Tristan Versel \n- Maxime Zimmermann"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Fermer"),
                                          )
                                        ],
                                      ));
                            },
                            child: const Text("Développeurs"))
                      ],
                    ),
            ),
          ),
        ),
        bottomNavigationBar: Navbar(
            actif: 3,
            reaload: () {
              setState(() {});
            }),
      ),
    );
  }
}
