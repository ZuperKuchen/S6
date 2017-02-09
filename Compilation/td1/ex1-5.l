%{




%}






%%

(aa)+b { printf("[%s]", yytext); }
(ab)+b { printf("[%s]", yytext); }
[ab] {printf("[%s]", yytext); }

<<EOF>> { return 1; }
%%


int main(){
yylex();
printf("\n");



}
