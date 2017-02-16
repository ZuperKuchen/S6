%option noyywrap
%{
int pos;

%}



%%
cabbb {printf("(%d, 0)", pos); REJECT;}
bbc {printf("(%d, 1)", pos); REJECT;}
. {pos++;}
<<EOF>> {return 1;}
%%


int main(){
yylex();
printf("\n");
}
