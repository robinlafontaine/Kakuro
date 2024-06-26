// ignore_for_file: curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';

class Kakuro {
  late int n, m, maxi, difficulte;
  late List<List<int>> grille;
  late List<List<List<int>>> entete;
  late List<List<int>> grilleUpdated, indiceColonne, indiceLigne;

  Kakuro(this.n, this.m, this.difficulte) {
    grille = List.generate(n, (i) => List.generate(m, (j) => 0));
    entete = List.generate(n, (i) => List.generate(m, (j) => []));
    maxi = max(n, m);
    if (maxi < 9) maxi = 9;

    genererGrille();
    updateGrille();
  }

  Kakuro.withXML(String xml) {
    var infos = XmlDocument.parse(xml);
    String? ns = infos.getElement("kakuro")?.getElement("n")?.text;
    String? ms = infos.getElement("kakuro")?.getElement("m")?.text;
    String? diff = infos.getElement("kakuro")?.getElement("diff")?.text;
    if (ns != null && ms != null && diff != null) {
      n = int.parse(ns);
      m = int.parse(ms);
      difficulte = int.parse(diff);
    }
    var cases = infos.getElement("kakuro")?.findAllElements("case").toList();
    var nb = 0;
    if (cases != null) {
      grille = List.generate(n, (i) => List.generate(m, (j) => 0));
      entete = List.generate(n, (i) => List.generate(m, (j) => []));
      grilleUpdated = List.generate(n, (i) => List.generate(m, (j) => 0));
      indiceColonne = List.generate(n, (i) => List.generate(m, (j) => 0));
      indiceLigne = List.generate(n, (i) => List.generate(m, (j) => 0));
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
          if (cases[nb].getElement("type")?.text == "vide") {
            grille[i][j] = -1;
            grilleUpdated[i][j] = -1;
            indiceLigne[i][j] = 0;
            indiceColonne[i][j] = 0;
          } else {
            if (cases[nb].getElement("type")?.text == "indice") {
              grille[i][j] =
                  int.parse(cases[nb].getElement("valeur")?.text as String);
              grilleUpdated[i][j] =
                  int.parse(cases[nb].getElement("valeur")?.text as String);
              indiceLigne[i][j] = int.parse(
                  cases[nb].getElement("indiceligne")?.text as String);
              indiceColonne[i][j] = int.parse(
                  cases[nb].getElement("indicecolonne")?.text as String);
              List<int> l = [];
              l.add(int.parse(
                  cases[nb].getElement("indiceligne")?.text as String));
              l.add(int.parse(
                  cases[nb].getElement("indicecolonne")?.text as String));
              entete[i][j] = l;
            } else {
              grille[i][j] =
                  int.parse(cases[nb].getElement("valeur")?.text as String);
              grilleUpdated[i][j] =
                  int.parse(cases[nb].getElement("valeur")?.text as String);
            }
          }
          nb++;
        }
      }
    }
  }

  String toXML() {
    String cases = "";
    for (var i = 0; i < n; i++)
      for (var j = 0; j < m; j++)
        if (grilleUpdated[i][j] == -1 &&
            indiceLigne[i][j] == 0 &&
            indiceColonne[i][j] == 0)
          cases = cases +
              "<case>"
                  "<type>vide</type>"
                  "<indiceligne>0</indiceligne>"
                  "<indicecolonne>0</indicecolonne>"
                  "<valeur>-1</valeur>"
                  "</case>";
        else if (indiceLigne[i][j] != 0 || indiceColonne[i][j] != 0)
          cases = cases +
              "<case>"
                  "<type>indice</type>"
                  "<indiceligne>${indiceLigne[i][j]}</indiceligne>"
                  "<indicecolonne>${indiceColonne[i][j]}</indicecolonne>"
                  "<valeur>-1</valeur>"
                  "</case>";
        else
          cases = cases +
              "<case>"
                  "<type>click</type>"
                  "<indiceligne>0</indiceligne>"
                  "<indicecolonne>0</indicecolonne>"
                  "<valeur>${grilleUpdated[i][j]}</valeur>"
                  "</case>";
    var xml = '''<?xml version="1.0"?>
    <kakuro>
      <n>$n</n>
      <m>$m</m>
      <diff>$difficulte</diff>
      $cases
    </kakuro>''';
    return xml;
  }

  void genererGrille() {
    genererTrou();
    estValideRandom(0, 0, 0);
    genererEntete();
    deleteUselessTuples();
  }

  bool estDansLigneOuColonne(int i, int j, int val) {
    for (int k = 0; k < m; k++) {
      if (grille[i][k] == val) {
        return true;
      }
    }
    for (int k = 0; k < n; k++) {
      if (grille[k][j] == val) {
        return true;
      }
    }
    return false;
  }

  void genererTrou() {
    if (difficulte == 1) difficulte = 2;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (i == 0 || j == 0 || emptyNeighbour(i, j)) {
          // try two times to generate a hole
          if (Random().nextInt(difficulte).toInt() == 1) {
            grille[i][j] = -1;
          } else if (Random().nextInt(difficulte).toInt() == 1) {
            grille[i][j] = -1;
          }
        } else if (Random().nextInt(difficulte).toInt() == 1) {
          grille[i][j] = -1;
        }
      }
    }
    checkTrou();
    genererEntete();
  }

  bool emptyNeighbour(int i, int j) {
    // check if there is an empty neighbour
    if (i > 0 && (grille[i - 1][j] == -1 || grille[i - 1][j] == 0)) {
      return true;
    }
    if (i < n - 1 && (grille[i + 1][j] == -1 || grille[i + 1][j] == 0)) {
      return true;
    }
    if (j > 0 && (grille[i][j - 1] == -1 || grille[i][j - 1] == 0)) {
      return true;
    }
    if (j < m - 1 && (grille[i][j + 1] == -1 || grille[i][j + 1] == 0)) {
      return true;
    }
    return false;
  }

  void checkTrou() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (grille[i][j] == -1) {
          int k = j;
          while (k < m && grille[i][k] != -1) {
            k++;
          }
          if (k - j > 9) {
            grille[i][Random().nextInt(k - j) + j] = -1;
          }
        }
      }
    }
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (grille[j][i] == -1) {
          int k = j;
          while (k < n && grille[k][i] != -1) {
            k++;
          }
          if (k - j > 9) {
            grille[Random().nextInt(k - j) + j][i] = -1;
          }
        }
      }
    }
  }

  void genererEntete() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (grille[i][j] == -1) {
          entete[i][j] = [];
        } else {
          entete[i][j] = [sommeLigne(i, j), sommeColonne(i, j)];
        }
      }
    }
  }

  int sommeLigne(int i, int j) {
    num somme = 0;
    int k = j;
    while (k < m && grille[i][k] != -1) {
      somme += grille[i][k];
      k++;
    }
    return somme.toInt();
  }

  int sommeColonne(int i, int j) {
    num somme = 0;
    int k = i;
    while (k < n && grille[k][j] != -1) {
      somme += grille[k][j];
      k++;
    }
    return somme.toInt();
  }

  void deleteUselessTuples() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (grille[i][j] != -1 &&
            j > 0 &&
            entete[i][j].length > 1 &&
            grille[i][j - 1] != -1) {
          entete[i][j] = [0, entete[i][j][1]];
        }
        if (grille[i][j] != -1 &&
            i > 0 &&
            grille[i - 1][j] != -1 &&
            entete[i][j].length > 1) {
          entete[i][j] = [entete[i][j][0], 0];
        }
        if (entete[i][j].isNotEmpty &&
            entete[i][j][0] == 0 &&
            entete[i][j][1] == 0) {
          entete[i][j] = [];
        }
      }
    }
  }

  bool estValide(i, j, position) {
    if (position == n * m) return true;
    if (grille[i][j] != 0) {
      if (j == m - 1) {
        return estValide(i + 1, 0, position + 1);
      } else {
        return estValide(i, j + 1, position + 1);
      }
    }

    for (int val = 1; val <= maxi; val++) {
      if (!estDansLigneOuColonne(i, j, val)) {
        grille[i][j] = val;
        if (j == m - 1) {
          if (estValide(i + 1, 0, position + 1)) {
            return true;
          }
        } else {
          if (estValide(i, j + 1, position + 1)) {
            return true;
          }
        }
        grille[i][j] = 0;
      }
    }
    return false;
  }

  bool estValideRandom(i, j, position) {
    if (position == n * m) return true;
    if (grille[i][j] != 0) {
      if (j == m - 1) {
        return estValideRandom(i + 1, 0, position + 1);
      } else {
        return estValideRandom(i, j + 1, position + 1);
      }
    }
    for (int val = 1; val <= maxi; val++) {
      int valeur = Random().nextInt(maxi) + 1;
      if (!estDansLigneOuColonne(i, j, valeur)) {
        grille[i][j] = valeur;
        if (j == m - 1) {
          if (estValideRandom(i + 1, 0, position + 1)) {
            return true;
          }
        } else {
          if (estValideRandom(i, j + 1, position + 1)) {
            return true;
          }
        }
        grille[i][j] = 0;
      }
    }
    return false;
  }

  List<List<int>> getGrille() {
    return grille;
  }

  List<List<int>> getBase() {
    List<List<int>> base = List.generate(n, (i) => List.generate(m, (j) => 0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (grilleUpdated[i][j] == -1) {
          base[i][j] = -1;
        }
      }
    }
    return base;
  }

  void affiche() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (kDebugMode) {
          print(grille[i][j]);
        }
      }
      if (kDebugMode) {
        print("");
      }
    }
  }

  void afficheEntete() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (kDebugMode) {
          print(entete[i][j]);
        }
      }
      if (kDebugMode) {
        print("");
      }
    }
  }

  List<List<int>> getGrilleUpdated() {
    // add a row and column of zeros in the first position of the grid
    List<List<int>> grilleUpdated =
        List.generate(n + 1, (i) => List.generate(m + 1, (j) => 0));
    for (int i = n - 1; i >= 0; i--) {
      for (int j = m - 1; j >= 0; j--) {
        grilleUpdated[i + 1][j + 1] = grille[i][j];
      }
    }
    grilleUpdated[0][0] = -1;
    return grilleUpdated;
  }

  List<List<int>> getIndiceColomnes() {
    List<List<int>> indiceColomnes =
        List.generate(n + 1, (i) => List.generate(m + 1, (j) => 0));
    for (int i = n - 1; i >= 0; i--) {
      for (int j = m - 1; j >= 0; j--) {
        if (entete[i][j].isNotEmpty) indiceColomnes[i][j + 1] = entete[i][j][1];
      }
    }
    return indiceColomnes;
  }

  List<List<int>> getIndiceLignes() {
    List<List<int>> indiceLignes =
        List.generate(n + 1, (i) => List.generate(m + 1, (j) => 0));
    for (int i = n - 1; i >= 0; i--) {
      for (int j = m - 1; j >= 0; j--) {
        if (entete[i][j].isNotEmpty) indiceLignes[i + 1][j] = entete[i][j][0];
      }
    }
    return indiceLignes;
  }

  void updateGrille() {
    grilleUpdated = List.generate(n + 1, (i) => List.generate(m + 1, (j) => 0));
    for (int i = n - 1; i >= 0; i--) {
      for (int j = m - 1; j >= 0; j--) {
        grilleUpdated[i + 1][j + 1] = grille[i][j];
      }
      for (int i = 0; i <= n; i++) {
        grilleUpdated[i][0] = -1;
      }
      for (int i = 0; i <= m; i++) {
        grilleUpdated[0][i] = -1;
      }
    }
    indiceColonne = List.generate(n + 1, (i) => List.generate(m + 1, (j) => 0));
    for (int i = n - 1; i >= 0; i--) {
      for (int j = m - 1; j >= 0; j--) {
        if (entete[i][j].isNotEmpty) indiceColonne[i][j + 1] = entete[i][j][1];
      }
    }
    indiceLigne = List.generate(n + 1, (i) => List.generate(m + 1, (j) => 0));
    for (int i = n - 1; i >= 0; i--) {
      for (int j = m - 1; j >= 0; j--) {
        if (entete[i][j].isNotEmpty) indiceLigne[i + 1][j] = entete[i][j][0];
      }
    }
    n += 1;
    m += 1;
  }

  // check validity of the grid in parameter knowing the updated grid, indiceColonne and indiceLigne
  bool estValideDiff(List grilleAVerif) {
    // we count the sum of the values in each row and each column until we find a -1
    // if the sum is equal to the indice, we continue
    // else we return false
    // if we reach the end of the grid, we return true
    for (int i = 1; i < n; i++) {
      int sum = 0;
      for (int j = 1; j < m; j++) {
        if (grilleUpdated[i][j] == -1) {
          if (sum != indiceLigne[i][j]) {
            return false;
          }
          sum = 0;
        } else {
          sum += (grilleAVerif[i][j] as int);
        }
      }
    }
    for (int j = 1; j < m; j++) {
      int sum = 0;
      for (int i = 1; i < n; i++) {
        if (grilleUpdated[i][j] == -1) {
          if (sum != indiceColonne[i][j]) {
            return false;
          }
          sum = 0;
        } else {
          sum += (grilleAVerif[i][j] as int);
        }
      }
    }
    return true;
  }
}

// // test main
// void main() {
//   Kakuro g = Kakuro(5, 5, 9);
//   // g.affiche();
//   // g.afficheEntete();
//   print(g.getGrilleUpdated());
//   // print(g.getIndiceColomnes());
// }
