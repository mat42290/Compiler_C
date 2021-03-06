%{
  #include "y.tab.h"
  #include "symbol_table.h"
%}

%option noyywrap

spaces [ \t\n]+

%%

{spaces} ;

"main" return t_main;
"(" return t_op;
")" return t_cp;
"{" return t_oa;
"}" return t_ca;
"const" return t_const;
"int" return t_int;
"+" return t_add;
"-" return t_sou;
"*" return t_mul;
"/" return t_div;
"=" return t_eq;
"," return t_comma;
";" return t_sc;
"printf" return t_printf;
[0-9]+[eE][+]?[0-9]+ {
    yylval.Integer=(int)atof(yytext);
    return t_expnum;
    }
[0-9]+ {
    yylval.Integer=atoi(yytext);
    return t_num;
    }
[a-zA-Z][a-zA-Z0-9_]* {
    strcpy(yylval.Variable, yytext);
    return t_var;
};

%%
