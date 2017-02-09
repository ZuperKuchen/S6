%option noyywrap
%{


%}

LETTRE [a-zA-Z]
MOT {LETTRE}+
SEP [ \n\t\.]
PLUR[Les|Des|Quelques|des|les|quelques]
SING[le|un|Le|Un]

%s PLURIEL SINGULIER
%%
<INITIAL,SINGULIER>{PLUR} {BEGIN PLURIEL; ECHO;}
<INITIAL,PLURIEL>{SING} {BEGIN SINGULIER; ECHO;}
Alpes {printf("Pyrenees"); }
Pralognan {printf("Saint-Girons"); }
loup/{SEP} {printf("ours") ;}
loups/{SEP} {printf("ours") ;}
<PLURIEL>chamois/{SEP} {printf("izards"); }
<SINGULIER>chamois/{SEP} {printf("izard"); }

%%


int main(){
yylex();
printf("\n");
}
