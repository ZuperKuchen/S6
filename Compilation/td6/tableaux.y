/* ppascal.y */
%{
 #include <stdio.h>
 #include <ctype.h>
 #include <string.h>
 #include "arbre.h"
 #include "interp.h"
/* ------------------VARIABLES GLOBALES -------------------------*/
  NOE syntree;          /* commande  globale                     */
  BILENVTY benvty;      /* environnement global                  */
  int ligcour=1;        /* ligne  courante                       */
  type tycour;          /* type courant                          */
  ENVTY vtycour;        /* var typee courante                    */
/* -------------------------------- -----------------------------*/
%}
%start MP
%union{NOE NO; type TYP; BILENVTY LARGT;}
/* attributs NOE: noeud binaire (IfThEl est "binarise")                                */
/* attributs TYP: contient un type                                                     */
/* attributs LARGT: liste d'arguments types(var globales)                              */
%type <NO> MP Ca C E T F Et 
%type <TYP> TP
%type <LARGT> Argt L_vart L_vartnn
/* Non-terminaux MP Ca C E T F Et TP Argt L_vart L_vartnn*/
/* P:main_program; Ca:commande atomique; C:commande; E:expression; T:terme; F:facteur;*/
/* Et: expr tableau; */
/* TP:TyPe; Argt:argument_type; */
/* L_vart: Liste_variables_typees,   L_vartnn: Liste_variables_typees non-nil */
%token <NO> I V Def Dep NFon NPro Mp Af Sk NewAr Se Ind If Th El Var Wh Do Pl Mo Mu And Or Not Lt Eq 
%token <TYP> T_int T_err T_bot T_ar T_com

/* Unités lexicales<NO>: Integer Variable Main_prog                            */
/* Affectation Skip NewArrayOf                                                 */
/* Sequence Index If Then Else Var While Do                                    */
/* Plus Moins Mult And Or Not Lessthan Equal                                   */
/* Unités lexicales<TYP>:
Type_int Type_erreur Type_indefini  Type_array Type_commande                   */


%%
MP :  L_vart C            {benvty=$1;
			   syntree=$2;
			   YYACCEPT;}
   ;

E : E Pl T                {$$=Nalloc();
                           $$->codop=Pl;
                           $$->FG=$1;
                           $$->FD=$3;
                           $$->ETIQ=malloc(2);
                           strcpy($$->ETIQ,"+");}
  | E Mo T               {$$=Nalloc();
                          $$->codop=Mo;
                          $$->FG=$1;
                          $$->FD=$3;
		          $$->ETIQ=malloc(2);
                          strcpy($$->ETIQ,"-");}
  | E Or T               {$$=Nalloc();
                          $$->codop=Or;
                          $$->FG=$1;
                          $$->FD=$3;
                          $$->ETIQ=malloc(2);
                          strcpy($$->ETIQ,"Or");}
  | E Lt T               {$$=Nalloc();
                          $$->codop=Lt;
                          $$->FG=$1;
                          $$->FD=$3;
                          $$->ETIQ=malloc(2);
                          strcpy($$->ETIQ,"Lt");}
  | E Eq T                {$$=Nalloc();
                          $$->codop=Eq;
                          $$->FG=$1;
                          $$->FD=$3;
                          $$->ETIQ=malloc(2);
                          strcpy($$->ETIQ,"Eq");}
  | T                    {$$=$1;}
  ;

T : T Mu  F               {$$=Nalloc();
                           $$->codop=Mu;
                           $$->FG=$1;
                           $$->FD=$3;
                           $$->ETIQ=malloc(2);
                           strcpy($$->ETIQ,"*");}

  | T And F               {$$=Nalloc();
                           $$->codop=And;
                           $$->FG=$1;
                           $$->FD=$3;
                           $$->ETIQ=malloc(2);
                           strcpy($$->ETIQ,"And");}
  | Not F                  {$$=Nalloc();
                            $$->codop=Not;
			    $$->FG=$2;
                            $$->FD=NULL;
			    $$->ETIQ=malloc(2);
                            strcpy($$->ETIQ,"Not");}
  | F                      {$$=$1;}
  ;

F : '(' E ')'                  {$$=$2;}
  | I                          {$$=$1;} 
  | V                          {$$=$1;}
  | NewAr TP '[' E ']'         {$$=Nalloc();
                                $$->codop=NewAr;
				/* calcul_type */
      				type_copy(&($$->typno),$2); /* DIM,TYPEF sont connus   */
				($$->typno).DIM++; /* mise a jour DIM                  */
      				$$->FG=NULL;
				$$->FD=$4;/* TAILLE a calculer a partir de E */}
  | Et                          {$$=$1;}
  ;

Et: V  '[' E ']'                {$$=Nalloc();/* un seul indice                        */
                                $$->codop=Ind;
				$$->FG=$1;
				$$->FD=$3;
				}
  | Et '[' E ']'                {$$=Nalloc();/* plusieurs indices                     */
                                $$->codop=Ind;
				$$->FG=$1;
				$$->FD=$3;
                                }
  ;

C : C Se Ca                     {$$=Nalloc();      /* sequence */
                                 $$->codop=Se;
                                 $$->FG=$1;
                                 $$->FD=$3;
                                 $$->ETIQ=malloc(2);
                                 strcpy($$->ETIQ,"Se");
                                 }    
  | Ca                          {$$=$1;}
  ;

Ca : Et Af E            {$$=Nalloc();
                        $$->codop=Af;
                        $$->FG=$1;
                        $$->FD=$3;
                        $$->ETIQ=malloc(2);
                        strcpy($$->ETIQ,"Af");
			}
  | V Af E              {$$=Nalloc();
                        $$->codop=Af;
                        $$->FG=$1;
                        $$->FD=$3;
                        $$->ETIQ=malloc(2);
                        strcpy($$->ETIQ,"Af");
			}
  | Sk                  {$$=$1;}      
  | '{' C '}'           {$$=$2;}     
  | If E Th C  El Ca    {$$=Nalloc();
                        $$->codop=If;
                        $$->FG=$2;         /* condition     */
                        $$->FD=Nalloc();   /* alternative   */
			$$->FD->ETIQ="";   /* champ inutile */
			$$->FD->FG=$4;     /* branche true  */
			$$->FD->FD=$6;     /* branche false */
                        $$->ETIQ=malloc(2);
                        strcpy($$->ETIQ,"IfThEl");
                        }
  | Wh E Do Ca         {$$=Nalloc();
                        $$->codop=Wh;
                        $$->FG=$2;         /* condition d'entree dans le while */
                        $$->FD=$4;         /* corps du while                   */
                        $$->ETIQ=malloc(2);
                        strcpy($$->ETIQ,"Wh");
                         }
  ;


/* un (ident, type) */ 
Argt:  V ':' TP         {vtycour=creer_envty($1->ETIQ,$3,0); $$=creer_bilenvty(vtycour);}
    ;
    
/* un type */
TP: T_int               {$$=$1;}
  | T_ar TP             {$$=$2;$$.DIM++;}
  ;

/* table des variables globales  */
L_vart: %empty           {$$=bilenvty_vide();}
      | L_vartnn         {$$=$1;}
      ;

L_vartnn: Var Argt                {$$=$2;}
| L_vartnn ',' Var Argt           {$$=concatty($1,$4);}
        ;

%%

#include "arbre.h"
#include "lex.yy.c"


   /*  pour tester l'analyse */ /*
int main(int argn, char **argv)
{yyparse();
  ecrire_prog(benvty,syntree);
  return(1);
}
*/


				 //pour tester l'interpreteur 
int main(int argn, char **argv)
{//ligcour=0;
  yyparse();
  ecrire_prog(benvty,syntree);
  init_memoire();
  printf("Les variables globales avant exec:\n");
  printf("------------------------:\n");
  ecrire_bilenvty(benvty); printf("\n");
  ecrire_memoire(5,5,20);
  semop_gp(benvty,syntree);
  printf("Les variables globales apres exec:\n");
  printf("------------------------:\n");
  ecrire_bilenvty(benvty); printf("\n");
  ecrire_memoire(5,5,20);
  return(1);
}

int yyerror(s)
     char *s;
{
  fprintf(stderr, "%s: ligne %d\n", s, ligcour);
    return EXIT_FAILURE;
}

