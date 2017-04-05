var X1 : integer,
var X2 : integer,
var X3 : integer,
var X4 : integer,
var X5 : array of integer,
var X6 : array of integer

X2 := 5;
X5 := new array of integer [6];
X5[0] := 1;
X5[1] := 0;
X5[2] := 1;
X5[3] := 0;
X5[4] := 1;
X5[5] := 0;
X3 := X5[0] or X5[1];
X4 := not ( X5[0] and  X5[1]);
X6 := new array of integer [4];
X6[0] := 10;
X6[1] := 11;
X6[2] := 12;
X6[3] := 13

/* apres exec:
------------------------:
variable X1 DIM:0,TAILLE:0,TYPEF:284valeur 0 
variable X2 DIM:0,TAILLE:0,TYPEF:284valeur 5 
variable X3 DIM:0,TAILLE:0,TYPEF:284valeur 1 
variable X4 DIM:0,TAILLE:0,TYPEF:284valeur 1 
variable X5 DIM:1,TAILLE:0,TYPEF:284valeur 1 
variable X6 DIM:1,TAILLE:0,TYPEF:284valeur 2 
fin d'environnement 

Le tableau ADR:
------------------------:
0:1:7:0:0:
Le tableau TAL:
------------------------:
0:6:4:0:0:
Le tableau TAS:
------------------------:
0:1:0:1:0:1:0:10:11:12:13:0:0:0:0:0:0:0:0:0:
*/
