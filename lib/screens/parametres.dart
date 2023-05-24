import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/theme.dart';
import 'package:kakuro/widgets/navbar.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:kakuro/config/config.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:kakuro/auth.dart';
import 'package:kakuro/config/fonctions.dart';
import 'package:kakuro/widgets/appbar.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => ParametreState();
}

class ParametreState extends State<Parametre> {
  String son = "";
  String etatPlayer = "";

  late Color pickerColor;

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  @override
  void initState() {
    super.initState();
    //A changer avec SharedPreferences
    pickerColor = Config.theme!.primaryColor;
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

  void changeTheme(ThemeData newTheme) {
    setState(() {
      Storage.storeTheme(newTheme);
      MyThemeData.of(context).updateTheme(newTheme);
    });
  }

  void resetTheme() {
    setState(() {
      Storage.storeTheme(Config.themeDefault);
      MyThemeData.of(context).updateTheme(Config.themeDefault);
    });
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: pickerColor,
      onColorChanged: (Color color) => setState(() => pickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      showMaterialName: true,
      showColorName: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
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
              child: Column(
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
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                borderRadius: BorderRadius.circular(10),
                                dropdownColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                value: son,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                                items: Config.sons.sons.map((items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: SizedBox(
                                      width: width(context) / 2.5,
                                      child: Text(
                                        items.replaceRange(
                                            items.length - 4, items.length, ""),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
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
                              width(context) / 15, // button width and height
                            ),
                          ),
                          onPressed: () {
                            stopMusic();
                          },
                          child: Icon(
                            Icons.stop,
                            size: width(context) / 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      ]),
                  SizedBox(height: height(context) / 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            changeTheme(Config.theme!.copyWith(
                                colorScheme: ColorScheme.fromSwatch(
                              primarySwatch: generateMaterialColor(
                                  color: Color.fromARGB(255, 187, 121, 121)),
                              brightness: Brightness.light,
                            )));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          final Color newColor = await showColorPickerDialog(
                            context,
                            pickerColor,
                            width: 40,
                            height: 40,
                            spacing: 0,
                            runSpacing: 0,
                            borderRadius: 0,
                            wheelDiameter: 165,
                            enableOpacity: true,
                            showColorCode: true,
                            colorCodeHasColor: true,
                            pickersEnabled: <ColorPickerType, bool>{
                              ColorPickerType.wheel: true,
                            },
                            copyPasteBehavior:
                                const ColorPickerCopyPasteBehavior(
                              pasteButton: true,
                              longPressMenu: true,
                            ),
                            actionButtons: const ColorPickerActionButtons(
                              okButton: true,
                              closeButton: true,
                              dialogActionButtons: false,
                            ),
                            transitionBuilder: (BuildContext context,
                                Animation<double> a1,
                                Animation<double> a2,
                                Widget widget) {
                              final double curvedValue =
                                  Curves.easeInOutBack.transform(a1.value) -
                                      1.0;
                              return Transform(
                                transform: Matrix4.translationValues(
                                    0.0, curvedValue * 200, 0.0),
                                child: Opacity(
                                  opacity: a1.value,
                                  child: widget,
                                ),
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            constraints: const BoxConstraints(
                                minHeight: 480, minWidth: 320, maxWidth: 320),
                          );
                          setState(() {
                            changeTheme(Config.theme!.copyWith(
                                colorScheme: ColorScheme.fromSwatch(
                              primarySwatch:
                                  generateMaterialColor(color: newColor),
                            )));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            changeTheme(Config.theme!.copyWith(
                              colorScheme: ColorScheme.fromSwatch(
                                primarySwatch: Colors.grey,
                                accentColor: Colors.grey,
                                brightness: Brightness.dark,
                              ),
                            ));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      )
                    ],
                  ),
                  // put space between buttons
                  SizedBox(height: height(context) / 20),
                  ElevatedButton(
                    onPressed: () => {
                      // reset theme with config.themeDefault
                      resetTheme(),
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Config.colors.primarySelect,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      padding: EdgeInsets.symmetric(
                        horizontal: width(context) *
                            0.20, // Change the horizontal padding to 20% of the screen width
                      ),
                      minimumSize: Size(
                          width(context) * 0.90,
                          height(context) *
                              0.08), // Change the height to 40 pixels
                    ),
                    child: const Text(
                      "Réinitialiser le thème",
                    ),
                  ),
                  Row(
                    children: [
                      Divider(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        thickness: 2,
                        // put adaptive height to the divider to make it responsive to the screen size and put it at the bottom of the page
                        height: height(context) / 5,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Auth(FirebaseAuth.instance).signOutGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Text(
                      "SIGN OUT",
                      selectionColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  // put space to the bottom of the page
                  // TODO: A REMPLACER PAR SPACER
                  // const Spacer(),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
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
