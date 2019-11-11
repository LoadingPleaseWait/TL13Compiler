%{
    
    
    #include<stdio.h>
    #include<stdlib.h>
    #include "bisonprint.h"
    #include "bisonnodes.h"
    #include <glib.h>
    GHashTable * syb = g_hash_table_new();
    
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

%union {
    double iValue; /* double value */
    char sIndex; /* symbol table index */
    int boolType; /*true or false*/
    (void) *nPtr; /* node pointer */
};

%token <boolType> BOOLLIT
%token <iValue> NUM
%token <sIndex> IDENT

%%
program : PROGRAM declarations BGN statementSequence END { $$ = new_program_t(1, $2, $4); }

declarations : VAR IDENT AS type SC declarations { $$ = new_declaration_t(0, $2, $4, $5); }
| {g_hash_table_insert(IDENT, IDENT); $$ = new_declaration_t(1, NULL, NULL, NULL);}
;

type : INT  { $$ = new_type_t(0, $1); }
| BOOL { $$ = new_type_t(1, $1); }

statementSequence : statement SC statementSequence { $$ = new_statement_sequence_t(0, $1, $3); }
| {$$ = new_statement_sequence_t(1, NULL, NULL);}
;

statement : assignment { struct statement_t *statement = new_statement_t(0, $1, NULL, NULL, NULL); $$ = statement; }
| ifStatement { struct statement_t *statement = new_statement_t(1, NULL, $1, NULL, NULL); $$ = statement; }
| whileStatement { struct statement_t *statement = new_statement_t(2, NULL, NULL, $1, NULL); $$ = statement; }
| writeInt { struct statement_t *statement = new_statement_t(3, NULL, NULL, NULL, $1); $$ = statement; }

assignment : IDENT ASGN expression { struct assignment_t *assignment = new_assignment_t(0, $1, $3); $$ = assignment; }
| IDENT ASGN READINT { struct assignment_t *assignment = new_assignment_t(1, $1, $3); $$ = assignment; }


ifStatement : IF expression THEN statementSequence elseClause END { struct if_statement_t *if_statement_t = new_if_statement_t(6, $2, $4, $5); $$ = if_statement_t; }

elseClause : ELSE statementSequence { struct else_clause_t *else_clause = new_else_clause_t(0, $2); $$ = else_clause; }
| {struct else_clause_t *else_clause = new_else_clause_t(1, NULL); $$ = else_clause;}
;

whileStatement : WHILE expression DO statementSequence END { struct while_statement_t *while_statement = new_while_statement_t(8, $2, $4); $$ = while_statement; }

writeInt : WRITEINT expression { struct write_int_t *write_int = new_write_int_t(9, $2); $$ = write_int; }

expression : simpleExpression { struct expression_t *expression = new_expression_t(10, $1, NULL); $$ = expression; }
| simpleExpression OP4 simpleExpression { struct expression_t *expression = new_expression_t(10, $1, $3); $$ = expression; }

simpleExpression : term OP3 term { struct simple_expression_t *simple_expression = new_simple_expression_t(11, $1, $3); $$ = simple_expression; }
| term { struct simple_expression_t *simple_expression = new_simple_expression_t(11, $1, NULL); $$ = simple_expression; }


term : factor OP2 factor { struct term_t *term = new_term_t(12, $1, $3); $$ = term; }
| factor { struct term_t *term = new_term_t(12, $1, NULL); $$ = term; }

factor : IDENT { struct factor_t *factor = new_factor_t(13, $1, NULL, NULL, NULL); $$ = factor; }
| NUM { struct factor_t *factor = new_factor_t(13, NULL, $1, NULL, NULL); $$ = factor; }
| BOOLLIT { struct factor_t *factor = new_factor_t(13, NULL, NULL, $1, NULL); $$ = factor; }
| LP expression RP { struct factor_t *factor = new_factor_t(13, NULL, NULL, NULL, $1); $$ = factor; }

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
void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}
