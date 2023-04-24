import 'dart:math';
import 'package:xml/xml.dart';

class Kakuro {
  late int n, m, maxi, difficulte;
  late List<List<int>> grille;
  late List<List<List<int>>> entete;

  Kakuro(int n, int m, int difficulte) {
    grille = List.generate(n, (i) => List.generate(m, (j) => 0));
    entete = List.generate(n, (i) => List.generate(m, (j) => []));
    maxi = max(n, m);
    this.n = n;
    this.m = m;
    this.difficulte = difficulte;

    genererGrille();
  }

  Kakuro.withXML(String xml){
    var infos = XmlDocument.parse(xml);
    String? ns = infos.getElement("kakuro")?.getElement("n")?.text;
    String? ms = infos.getElement("kakuro")?.getElement("m")?.text;
    String? diff = infos.getElement("kakuro")?.getElement("diff")?.text;
    if(ns != null && ms != null && diff != null){
      n = int.parse(ns);
      m = int.parse(ms);
      difficulte = int.parse(diff);
    }
    var cases = infos.getElement("kakuro")?.findAllElements("case").toList();
    var nb=0;
    if(cases!=null) {
      grille = List.generate(n, (i) => List.generate(m, (j) => 0));
      entete = List.generate(n, (i) => List.generate(m, (j) => []));
      print(cases[1].getElement("type"));
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
          if (cases[nb].getElement("type")?.text == "vide") {
            grille[i][j] = -1;
          }
          else {
            if (cases[nb].getElement("type")?.text == "indice") {
              grille[i][j] =
                  int.parse(cases[nb].getElement("valeur")?.text as String);
              List<int> l = [];
              l.add(int.parse(cases[nb].getElement("indiceligne")?.text as String));
              l.add(int.parse(cases[nb].getElement("indicecolonne")?.text as String));
              entete[i][j] = l;
            } else {
              grille[i][j] =
                  int.parse(cases[nb].getElement("valeur")?.text as String);
            }
          }
          nb++;
        }
      }
    }
  }

  String toXML(){
    String cases="";
    for(var i=0;i<n;i++)
      for(var j=0;j<n;j++)
        if(grille[i][j]==-1)
          cases = cases + "<case>"
              "<type>vide</type>"
              "<indiceligne>0</indiceligne>"
              "<indicecolonne>0</indicecolonne>"
              "<valeur>-1</valeur>"
              "</case>";
        else
          if(entete[i][j].isNotEmpty)
            cases = cases + "<case>"
                "<type>indice</type>"
                "<indiceligne>${entete[i][j][0]}</indiceligne>"
                "<indicecolonne>${entete[i][j][1]}</indicecolonne>"
                "<valeur>${grille[i][j]}</valeur>"
                "</case>";
          else
            cases = cases + "<case>"
                "<type>click</type>"
                "<indiceligne>0</indiceligne>"
                "<indicecolonne>0</indicecolonne>"
                "<valeur>${grille[i][j]}</valeur>"
                "</case>";
    var xml = '''<?xml version="1.0"?>
    <kakuro>
      <n>${n}</n>
      <m>${m}</m>
      <diff>${difficulte}</diff>
      ${cases}
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
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (Random().nextInt(difficulte).toInt() == 1) {
          grille[i][j] = -1;
        }
      }
    }
    checkTrou();
    genererEntete();
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

  List<List<int>> getGrille(){
    return grille;
  }

  void affiche() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        print(grille[i][j]);
      }
      print("");
    }
  }

  void afficheEntete() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        print(entete[i][j]);
      }
      print("");
    }
  }
}

// // test main
// void main() {
//   Kakuro g = Kakuro(5, 5, 9);
//   g.affiche();
//   g.afficheEntete();
// }
