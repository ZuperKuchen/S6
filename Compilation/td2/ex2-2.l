%option noyywrap
%{


%}
Lettre [a-z]
%s Je Tu IlElle Nous Vous IlsElles
%%
(J|j)e {BEGIN Je}
(T|t)u {BEGIN Tu}
((I|i)l)|((E|e)lle) {BEGIN IlElle}
nous {BEGIN Nous}
vous {BEGIN Vous}
ils|elles {BEGIN IlsElles}
<Je>\[[Lettre+]er\] {
<Tu>\[[Lettre+]er\] 
<IlElle>\[[Lettre+]er\] 
<Nous>\[[Lettre+]er\] 
<Vous>\[[Lettre+]er\] 
<IlsElles>\[[Lettre+]er\] 

%%


int main(){
yylex();
printf("\n");
}
