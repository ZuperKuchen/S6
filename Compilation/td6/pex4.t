var X1 : integer,
var X2 : integer,
var Z: integer,
var X3 : array of integer,
var X4 : array of array of integer

X2:= 2;
X4 := new array of array of integer [3];
X4[0] := new array of integer [2];
X4[1] := new array of integer [3];
X4[2] := new array of integer [4];
X4[2][3]:= 0 - 1;
X3 := X4[X2];
Z := X4[2][3]



/* Les variables globales apres exec:
------------------------:
variable X1 DIM:0,TYPEF:284valeur 0 
variable X2 DIM:0,TYPEF:284valeur 2 
variable Z DIM:0,TYPEF:284valeur -1 
variable X3 DIM:1,TYPEF:284valeur 4 
variable X4 DIM:2,TYPEF:284valeur 1 
fin d'environnement 

Le tableau ADR:
------------------------:
0:1:4:6:9:
Le tableau TAL:
------------------------:
0:3:2:3:4:
Le tableau TAS:
------------------------:
0:2:3:4:0:0:0:0:0:0:0:0:-1:0:0:0:0:0:0:0:
*/