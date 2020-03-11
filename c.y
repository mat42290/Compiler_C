%{
    
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
int yydebug = 1;

void ffprintf(char * instruction, char * params) {
    fprintf(yyout,"\t%s\t%s\n", instruction, params);
}

%}

%union {int Integer;
        char * Variable;}

%token t_main t_printf t_return
%token t_int t_const
%token t_add t_mul t_sou t_div t_eq
%token t_op t_cp t_oa t_ca
%token t_cr t_space t_tab t_comma t_sc
%token <Integer> t_expnum 
%token <Integer> t_num 
%token <Variable> t_var

%left t_add t_sou
%left t_mul t_div
%left t_neg

%start File

%%

File:
     /* Vide */
    | t_int t_main t_op { fprintf(yyout,"main:\n"); ffprintf("push","rbp"); ffprintf("mov","rbp, rsp"); } Params t_cp t_oa Body t_return t_num { ffprintf("mov", "eax, 0"); } t_sc t_ca { ffprintf("pop","rbp"); ffprintf("ret",""); }
    ;

Body:
     /* Vide */
    | Line t_sc Body
    ;

Params:
     /* Vide */
    | NonEmptyParams
    ;

SingleParam:
    t_var
    ;

NonEmptyParams:
    SingleParam
    | SingleParam t_comma NonEmptyParams  
    ;

Line:
    Definition
    | Affectation
    | Print
    ;

Number:
    t_num
    | t_expnum
    ;

Expression:
    Number 
    | t_var
    | Expression t_add Expression 
    | Expression t_sou Expression 
    | Expression t_mul Expression 
    | Expression t_div Expression
    | t_sou Expression %prec t_neg 
    | t_op Expression t_cp
    ;

SingleDefinition:
    t_var
    ;

Definitions:
    SingleDefinition
    | SingleDefinition t_comma Definitions  
    ;

Definition:
    t_const t_int Definitions
    | t_int Definitions 
    ;

Affectation:
    Definition t_eq Expression 
    | t_var t_eq Expression 
    ;

Print:
    t_printf t_op NonEmptyParams t_cp
    ;

%%

int yyerror(char *s) {
  printf("%s\n",s);
  exit(2);
  return 1;
}


int main(int argc, char *argv[]) {
  if (argc == 3) {

   yyout = fopen(argv[2],"w");
   yyin = fopen(argv[1], "r");
   yyparse();
   fclose(yyin);
   fclose(yyout);
  }
  else {
    printf("Wrong usage !\n");
  }

  return 0;
}
