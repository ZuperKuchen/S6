%{
#include <stdio.h>
int yylex();
 int yywrap();
 int yyerror();

  %}

%start A

%%
A : S '\n'   {printf("mot reconnu\n");}
S : 'a' S 'b' {;}
|  'a' 'b' {;}
%%

int yylex(){
  char c = getchar();
  if ( c==EOF) return 0;
  else return c;
}

int yywrap(){
  printf("reading done! \n");
  return 1;
}

int yyerror(char *s){
  fprintf(stderr, "*** ERROR; %s\n", s );
  return 0;
}

int main(int argc, char **argv){
  yyparse();
  return 0;
}
