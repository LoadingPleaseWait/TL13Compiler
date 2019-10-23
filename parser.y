%{
#include<stdio.h>

void yyerror(char*,...);
int yywrap(void);
%}
%token BGN
%token END
%token VAR
%token AS
%token LP
%token RP
%token ASGN
%token SC
%token OP2
%token OP3
%token OP4
%token IF
%token THEN
%token ELSE
%token WHILE
%token DO
%token PROGRAM
%token INT
%token BOOL
%token WRITEINT
%token READINT        
%%
program : PROGRAM declarations BGN statementSequence END

declarations : VAR ident AS type SC declarations
               |
	       ;

type : INT | BOOL

statementSequence : statement SC statementSequence
                    |
		    ;

statement : assignment
            | ifStatement
            | whileStatement
            | writeInt

assignment : ident ASGN expression
             | ident ASGN READINT

ifStatement : IF expression THEN statementSequence elseClause END

elseClause : ELSE statementSequence
             |
	     ;

whileStatement : WHILE expression DO statementSequence END

writeInt : WRITEINT expression

expression : simpleExpression
             | simpleExpression OP4 simpleExpression

simpleExpression : term OP3 term
                   | term

term : factor OP2 factor
       | factor

factor : ident
         | num
         | boollit
         | LP expression RP

%%
int main(void)
{
 yyparse();
 return 0;
}
int yywrap(void)
{
 return 1;
}
void yyerror(char* msg, ...)
{
 printf("\nError Occurred\n");
}
