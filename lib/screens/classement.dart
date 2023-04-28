import 'package:flutter/material.dart';
import 'package:kakuro/config/config.dart';

import '../config/fonctions.dart';
import '../leaderboard.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

const int limite = 6; //une limite variable ?

class classement extends StatefulWidget {
  const classement({super.key});

  @override
  //Leaderboard.getLeaderboard(limite)
  State<classement> createState() => classementState();
}

class classementState extends State<classement> {
  final Future scoresFuture = Leaderboard.getLeaderboard(limite);

  void retour() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.colors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, width(context) / 6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: appbar(
            home: false,
            enjeu: false,
            retour: () => {retour()},
            enligne: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: scoresFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration:
                              BoxDecoration(color: config.colors.primaryColor),
                          width: width(context) / 1.1,
                          child: Row(
                            children: [
                              Container(
                                  width: width(context) / 5,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Center(
                                      child: Text(
                                    "RANG",
                                    style: TextStyle(
                                        color: config.colors.primaryTextColor),
                                  ))),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  width: width(context) / 2.7,
                                  height: 40,
                                  child: Text("JOUEUR",
                                      style: TextStyle(
                                          color:
                                              config.colors.primaryTextColor))),
                              Container(
                                  width: width(context) / 3.3,
                                  height: 40,
                                  child: Center(
                                      child: Text("POINTS",
                                          style: TextStyle(
                                              color: config
                                                  .colors.primaryTextColor)))),
                            ],
                          ),
                        ),
                        for (int i = 0; i < limite; i++)
                          Container(
                            width: width(context) / 1.1,
                            decoration: BoxDecoration(
                                color: (i % 2 == 0)
                                    ? config.colors.primaryTextColor
                                    : Colors.white54),
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: width(context) / 5,
                                    height: 40,
                                    child: Center(
                                        child: Text((i + 1).toString()))),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    width: width(context) / 2.7,
                                    height: 40,
                                    child: Text(snapshot.data[i]["name"])),
                                Container(
                                    width: width(context) / 3.3,
                                    height: 40,
                                    child: Center(
                                        child: Text(snapshot.data[i]["score"]
                                            .toString()))),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Erreur");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
      bottomNavigationBar: navbar(10, true),
    );
  }
}
