%{
    
    
    #include<stdio.h>
    #include<stdlib.h>
    #include "bisonprint.h"
    #include "bisonnodes.h"
    #include "uthash.h"
    struct idHashable {
        char * identify;
        int init;
        UT_hash_handle hh;
    };
    struct idHashable * idents, *s = NULL;
    struct program_t * prgrm;
    
    extern int yylineno;
%}

%union {
double iValue; /* double value */
char * sIndex; /* symbol table index */
int boolType; /*true or false*/
void* NodePtr;
}


%token BGN
%token END
%token VAR
%token AS
%token LP
%token RP
%token ASGN
%token SC
%token <sIndex> OP2
%token <sIndex> OP3
%token <sIndex> OP4
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

%token <boolType> BOOLLIT
%token <iValue> NUM
%token <sIndex> IDENT

%type <NodePtr> program declarations type statementSequence statement assignment ifStatement
%type <NodePtr> elseClause whileStatement writeInt expression simpleExpression term factor

%%
program : PROGRAM declarations BGN statementSequence END { prgrm = new_program_t(1, $2, $4); printProgram(prgrm); }

declarations : VAR IDENT AS type SC declarations
{   s = (struct idHashable *)malloc(sizeof *s);
    s->identify = $2;
    //printf("$1, $2, $3, $4, $5, $6: %s, %s, %s, %s, %s, %s\n", 0, $2, 0, $4, 0, $6);
    //printf("$2, $4, s->identify: %s, %s, %s\n", $2, $4, yylval.sIndex);
    //printf("sIndex: %s\n", yylval.sIndex);
    s->init = 0;
    HASH_ADD_KEYPTR( hh, idents, s->identify, strlen(s->identify), s);
    //printf("identifier: %s\n", identifier);
    $$ = new_declaration_t(0, $2, $4, $6); }
| {$$ = NULL;}
;

type : INT  { $$ = new_type_t(0); }
| BOOL { $$ = new_type_t(1); }

statementSequence : statement SC statementSequence {/*printf("statement sequence seen");*/ $$ = new_statement_sequence_t(0, $1, $3); }
| {$$ = NULL;}
;

statement : assignment { struct statement_t *statement = new_statement_t(0, $1, NULL, NULL, NULL); $$ = statement; }
| ifStatement { struct statement_t *statement = new_statement_t(1, NULL, $1, NULL, NULL); $$ = statement; }
| whileStatement { struct statement_t *statement = new_statement_t(2, NULL, NULL, $1, NULL); $$ = statement; }
| writeInt { struct statement_t *statement = new_statement_t(3, NULL, NULL, NULL, $1); $$ = statement; }

assignment : IDENT ASGN expression { /*printf("(asgn)$1: %s\n", $1);*/ struct assignment_t *assignment = new_assignment_t(0, $1, $3); $$ = assignment; }
| IDENT ASGN READINT { 
    //printf("identifier: %s\n", identifier);
    struct assignment_t *assignment = new_assignment_t(1, $1, NULL); $$ = assignment; }


ifStatement : IF expression THEN statementSequence elseClause END { struct if_statement_t *if_statement_t = new_if_statement_t(6, $2, $4, $5); $$ = if_statement_t; }

elseClause : ELSE statementSequence { struct else_clause_t *else_clause = new_else_clause_t(0, $2); $$ = else_clause; }
| {$$ = NULL;}
;

whileStatement : WHILE expression DO statementSequence END {/*printf("while statement seen");*/ struct while_statement_t *while_statement = new_while_statement_t(8, $2, $4); $$ = while_statement; }

writeInt : WRITEINT expression { struct write_int_t *write_int = new_write_int_t(9, $2); $$ = write_int; }

expression : simpleExpression { struct expression_t *expression = new_expression_t(0, $1, NULL, NULL); $$ = expression; }
| simpleExpression OP4 simpleExpression { struct expression_t *expression = new_expression_t(1, $1, $2, $3); $$ = expression; }

simpleExpression : term OP3 term { struct simple_expression_t *simple_expression = new_simple_expression_t(1, $1, $2, $3); $$ = simple_expression; }
| term { struct simple_expression_t *simple_expression = new_simple_expression_t(0, $1, NULL, NULL); $$ = simple_expression; }


term : factor OP2 factor { struct term_t *term = new_term_t(1, $1, $2, $3); $$ = term; }
| factor { struct term_t *term = new_term_t(0, $1, NULL, NULL); $$ = term; }

factor : IDENT {
    struct factor_t *factor = new_factor_t(0, $1, 0, 0, NULL); $$ = factor; }
| NUM { struct factor_t *factor = new_factor_t(1, NULL, $1, 0, NULL); $$ = factor; }
| BOOLLIT { struct factor_t *factor = new_factor_t(2, NULL, 0, $1, NULL); $$ = factor; }
| LP expression RP { struct factor_t *factor = new_factor_t(3, NULL, 0, 0, $2); $$ = factor; }

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
