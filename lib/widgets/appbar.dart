import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/Config/Config.dart';
import 'package:kakuro/Config/fonctions.dart';
import '../auth.dart';
import '../leaderboard.dart';
import '../screens/menu.dart';

class Appbar extends StatefulWidget {
  bool home;
  bool enjeu;
  Function retour;
  Function? abandon;
  int? chrono;

  Appbar({
    super.key,
    required this.home,
    required this.enjeu,
    required this.retour,
    this.abandon,
    this.chrono,
  });

  @override
  State<Appbar> createState() => AppbarState(retour);
}

class AppbarState extends State<Appbar> {
  String time = "0", seconde = "00", minute = "00";
  Timer? timer;
  Function? timerFunction;
  Function retour;
  Duration duration = const Duration();

  AppbarState(this.retour);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  String getAffichage(int n) {
    return n.toString().padLeft(2, "0");
  }

  void startTimer() {
    if (widget.enjeu) {
      if (widget.chrono != null) {
        duration = Duration(seconds: widget.chrono!);
        minute = getAffichage(duration.inMinutes.remainder(60));
        seconde = getAffichage(duration.inSeconds.remainder(60));
      }
      timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    }
  }

  void addTime() {
    const addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
        minute = getAffichage(duration.inMinutes.remainder(60));
        seconde = getAffichage(duration.inSeconds.remainder(60));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: width(context) / 9,
      centerTitle: true,
      leading: (widget.home)
          ? Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon((Config.online) ? Icons.wifi : Icons.wifi_off),
                      iconSize: width(context) / 15,
                      color: (Config.online) ? Colors.green : Colors.red,
                      onPressed: () {
                        (Config.online)
                            ? {
                                Config.online = false,
                                route(context, const Menu())
                              }
                            : {
                                Auth(FirebaseAuth.instance)
                                    .signedIn()
                                    .then(((connected) => {
                                          if (!connected)
                                            {
                                              Auth(FirebaseAuth.instance)
                                                  .signInGoogle(context)
                                                  .then((value) => Leaderboard()
                                                      .userExists(context)
                                                      .then((value) => {
                                                            if (FirebaseAuth
                                                                    .instance
                                                                    .currentUser !=
                                                                null)
                                                              Config.online =
                                                                  true,
                                                            route(context,
                                                                const Menu())
                                                          }))
                                            }
                                          else
                                            {
                                              Config.online = true,
                                              route(context, const Menu())
                                            }
                                        }))
                              };
                      },
                    ),
                  ),
                );
              },
            )
          : Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Center(
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeftLong),
                      iconSize: width(context) / 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        widget.retour();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                );
              },
            ),
      title: (widget.enjeu)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: width(context) / 12,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "$minute:$seconde",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: width(context) / 11),
                ),
              ],
            )
          : null,
      actions: [
        (widget.enjeu)
            ? Container(
                width: width(context) / 9,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                    child: InkWell(
                  child: FaIcon(
                    FontAwesomeIcons.ban,
                    size: width(context) / 20,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  onTap: () {
                    widget.abandon!();
                  },
                )))
            : const SizedBox(
                width: 0.0001,
              )
      ],
    );
  }
}
