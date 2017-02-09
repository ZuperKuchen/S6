%{




%}







%%
a { printf("b"); }
b { printf("c"); }
c { printf("a"); }

<<EOF>> { return 1; }
%%


int main(){
yylex();




}
