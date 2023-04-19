import random

# algorithme de backtracking pour génération de kakuro

class grilleKakuro:
    def __init__(self, n, m, difficulte):
        self.n = n
        self.m = m
        self.maxi = max(n, m)
        self.grille = [[0 for i in range(m)] for j in range(n)]
        self.entete = [[0 for i in range(m)] for j in range(n)]
        self.difficulte = difficulte
        self.genererGrille()

    # on remplit la grille avec des des valeurs de 1 à maxi
    def genererGrille(self):
        self.genererTrou()
        # for i in range(self.n):
        #     for j in range(self.m):
        #         if self.grille[i][j] == 0:
        #             valeur = random.randint(1, self.maxi)
        #             while self.estDansLigneOuColonne(i, j, valeur):
        #                 valeur = random.randint(1, self.maxi)
        #             self.grille[i][j] = valeur
        # self.estValide(0, 0, 0)
        self.estValideRandom(0, 0, 0)
        self.genererEntete()
        self.deleteUselessTuples()
        

    def estDansLigneOuColonne(self, i, j, val):
        # on vérifie que la valeur n'est pas déjà dans la ligne ou la colonne, on s'arrête si on est sur un trou
        k = 0
        while k < self.m and self.grille[i][k] != -1:
            if self.grille[i][k] == val:
                return True
            k += 1
        k = 0
        while k < self.n and self.grille[k][j] != -1:
            if self.grille[k][j] == val:
                return True
            k += 1
        return False
    
    # algo de backtracking
    def estValide(self, i, j, position):
        if position == self.n * self.m:
            return True
        
        if self.grille[i][j] != 0:
            if j == self.m - 1:
                return self.estValide(i + 1, 0, position + 1)
            else:
                return self.estValide(i, j + 1, position + 1)
            
        for val in range(1, self.maxi + 1):
            if not self.estDansLigneOuColonne(i, j, val):
                self.grille[i][j] = val
                if j == self.m - 1:
                    if self.estValide(i + 1, 0, position + 1):
                        return True
                else:
                    if self.estValide(i, j + 1, position + 1):
                        return True
                self.grille[i][j] = 0
        return False
    
    # on refait la même fonction en utilisant des valeurs aléatoires pour la génération de la grille
    def estValideRandom(self, i, j, position):
        if position == self.n * self.m:
            return True
        
        if self.grille[i][j] != 0:
            if j == self.m - 1:
                return self.estValideRandom(i + 1, 0, position + 1)
            else:
                return self.estValideRandom(i, j + 1, position + 1)
            
        for val in range(1, self.maxi + 1):
            valeur = random.randint(1, self.maxi)
            if not self.estDansLigneOuColonne(i, j, valeur):
                self.grille[i][j] = valeur
                if j == self.m - 1:
                    if self.estValideRandom(i + 1, 0, position + 1):
                        return True
                else:
                    if self.estValideRandom(i, j + 1, position + 1):
                        return True
                self.grille[i][j] = 0
        return False
    
    
    # on fait des trous au hasard dans la grille en fonction de la difficulté, plus la difficulté est grande, moins il y a de trous
    def genererTrou(self):
        for i in range(self.n):
            for j in range(self.m):
                if random.randint(1, self.difficulte) == 1:
                    self.grille[i][j] = -1

        self.checkTrou()
        self.genererEntete()

    # on vérifie si chaque ligne et chaque colonne n'a pas plus de 9 cases d'affilée
    # si c'est le cas, on remplace une valeur par un trou aléatoirement
    def checkTrou(self):
        for i in range(self.n):
            for j in range(self.m):
                if self.grille[i][j] != -1:
                    k = j
                    while k < self.m and self.grille[i][k] != -1:
                        k += 1
                    if k - j > 9:
                        self.grille[i][random.randint(j, k - 1)] = -1
        for j in range(self.m):
            for i in range(self.n):
                if self.grille[i][j] != -1:
                    k = i
                    while k < self.n and self.grille[k][j] != -1:
                        k += 1
                    if k - i > 9:
                        self.grille[random.randint(i, k - 1)][j] = -1

    # on génère les entêtes de la grille
    def genererEntete(self):
        # On doit avoir un tuple pour chaque case de la grille indiquant la somme de la colonne et de la ligne
        # si la case est un trou, on met un tuple vide
        for i in range(self.n):
            for j in range(self.m):
                if self.grille[i][j] == -1:
                    self.entete[i][j] = ()
                else:
                    self.entete[i][j] = (self.sommeLigne(i, j), self.sommeColonne(i, j))


    # on calcule la somme de la ligne
    def sommeLigne(self, i, j):
        # on s'arrête si on est sur un trou et on retourne la somme
        somme = 0
        while j < self.m and self.grille[i][j] != -1:
            somme += self.grille[i][j]
            j += 1
        return somme
    
    # on calcule la somme de la colonne
    def sommeColonne(self, i, j):
        # on s'arrête si on est sur un trou et on retourne la somme
        somme = 0
        while i < self.n and self.grille[i][j] != -1:
            somme += self.grille[i][j]
            i += 1
        return somme
    
    # on affiche la grille
    def affiche(self):
        for i in range(self.n):
            for j in range(self.m):
                print(self.grille[i][j], end = " ")
            print()

    # on affiche les entêtes
    def afficheEntete(self):
        for i in range(self.n):
            for j in range(self.m):
                print(self.entete[i][j], end = " ")
            print()

    def deleteUselessTuples(self):
        # on met à 0 le premier tuple si on a un voisin à gauche
        for i in range(self.n):
            for j in range(self.m):
                if self.grille[i][j] != -1 and j > 0 and self.grille[i][j - 1] != -1:
                    self.entete[i][j] = (0, self.entete[i][j][1])
        # on met à 0 le premier tuple si on a un voisin en haut
        for i in range(self.n):
            for j in range(self.m):
                if self.grille[i][j] != -1 and i > 0 and self.grille[i - 1][j] != -1:
                    self.entete[i][j] = (self.entete[i][j][0], 0)
        # change all the tuples with o,0 to an empty tuple
        for i in range(self.n):
            for j in range(self.m):
                if self.entete[i][j] == (0, 0):
                    self.entete[i][j] = ()

    def enteteVide(self, i, j):
        return self.entete[i][j] == ()

    def getGrille(self):
        return self.grille
    
    
test = grilleKakuro(6, 6, 10)
test.affiche()
print()
test.afficheEntete()

