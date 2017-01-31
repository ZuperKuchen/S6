%{
int res =0;
int pos = 0;
%}

%%

cabb {res=1;}
cbab {res=1;}
cbb {res=1;}
cbbba {res=1;}
<<EOF>> {return(res);}
.|\n {;}
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

