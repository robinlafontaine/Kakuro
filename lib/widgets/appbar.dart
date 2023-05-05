import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakuro/config/config.dart';
import 'package:kakuro/config/fonctions.dart';
import '../auth.dart';
import '../leaderboard.dart';
import '../screens/menu.dart';

class appbar extends StatefulWidget {
  bool home;
  bool enjeu;
  Function retour;
  Function? abandon;
  int? chrono;

  appbar({
    required this.home,
    required this.enjeu,
    required this.retour,
    this.abandon,
    this.chrono,
  });

  @override
  State<appbar> createState() => _appbarState(this.retour);
}

class _appbarState extends State<appbar> {
  String time = "0", seconde = "00", minute = "00";
  Timer? timer;
  Function? timerFunction;
  Function retour;
  Duration duration = Duration();

  _appbarState(this.retour);

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
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    }
  }

  void addTime() {
    final addSeconds = 1;
    if (this.mounted) {
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
                    color: config.colors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon((config.online) ? Icons.wifi : Icons.wifi_off),
                      iconSize: width(context) / 15,
                      color: (config.online) ? Colors.green : Colors.red,
                      onPressed: () {
                        (config.online)
                            ? {config.online = false, route(context, menu())}
                            : {
                                FirebaseAuth.instance
                                    .authStateChanges()
                                    .listen((User? user) {
                                  if (user == null) {
                                    Auth(FirebaseAuth.instance)
                                        .signInGoogle(context)
                                        .then((value) =>
                                            Leaderboard().userExists(context));
                                  } else {
                                    config.online = true;
                                    route(context, menu());
                                  }
                                }).onError((error, stackTrace) {})
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
                      color: config.colors.primaryColor),
                  child: Center(
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.arrowLeftLong),
                      iconSize: width(context) / 20,
                      color: config.colors.primaryTextColor,
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
                  color: config.colors.primaryTitreSelect,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "$minute:$seconde",
                  style: TextStyle(
                      color: config.colors.primaryTitreSelect,
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
                    color: config.colors.primaryColor,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                    child: InkWell(
                  child: FaIcon(
                    FontAwesomeIcons.ban,
                    size: width(context) / 20,
                  ),
                  onTap: () {
                    widget.abandon!();
                  },
                )))
            : SizedBox(
                width: 0.0001,
              )
      ],
    );
  }
}
