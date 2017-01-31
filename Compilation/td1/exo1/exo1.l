%{
int res = 0;
%}

indent [abc]

%%
[abb] {res=1;}
[c] {printf("It works \n");}
<<EOF>> {return res;}
%%

int main(int argc, char **argv){
int ana = 0;
ana= yylex();
if (ana ==0){
printf("0 \n");
}
else{
printf(" 1\n");
}
}

