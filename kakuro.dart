import 'dart:math';

class Kakuro {
  late int n, m, maxi, difficulte;
  late dynamic grille, entete;

  Kakuro(int n, int m, int difficulte) {
    grille = List.generate(n, (i) => List.generate(m, (j) => 0));
    entete = List.generate(n, (i) => List.generate(m, (j) => 0));
    maxi = max(n, m);
    this.n = n;
    this.m = m;
    this.difficulte = difficulte;

    genererGrille();
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
        if (grille[i][j] != -1 && j > 0 && grille[i][j - 1] != -1) {
          entete[i][j] = [0, entete[i][j][1]];
        }
        if (grille[i][j] != -1 && i > 0 && grille[i - 1][j] != -1) {
          entete[i][j] = [entete[i][j][0], 0];
        }
        if (entete[i][j] == [0, 0]) {
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

// test main
void main() {
  Kakuro g = Kakuro(5, 5, 9);
  g.affiche();
  g.afficheEntete();
}
