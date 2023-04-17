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
        for i in range(self.n):
            for j in range(self.m):
                if self.grille[i][j] == 0:
                    valeur = random.randint(1, self.maxi)
                    while self.estDansLigneOuColonne(i, j, valeur):
                        valeur = random.randint(1, self.maxi)
                    self.grille[i][j] = valeur
        self.genererEntete()
        self.deleteUselessTuples()
        

    def estDansLigneOuColonne(self, i, j, val):
        # on vérifie que la valeur n'est pas déjà dans la ligne ou la colonne, on s'arrête si on est sur un trou
        k = j
        while k < self.m and self.grille[i][k] != -1:
            if self.grille[i][k] == val:
                return True
            k += 1
        k = i
        while k < self.n and self.grille[k][j] != -1:
            if self.grille[k][j] == val:
                return True
            k += 1
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

    def getGrille(self):
        return self.grille
    

    
    # def solve(self):
    #     # backtracking algorithm to solve the grid
    #     # we start at the top left corner
    #     # if the cell is empty, we try to fill it with a number
    #     # if the number is valid, we go to the next cell
    #     # if the number is not valid, we try another number
    #     # if we have tried all the numbers and none of them are valid, we go back to the previous cell

    #     while 
    
test = grilleKakuro(11, 11, 10)
test.affiche()
print()
test.afficheEntete()

