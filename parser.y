%{
#include<stdio.h>
#include<stdlib.h>

void yyerror(char*);
int yywrap(void);

struct factor_t {
	int nodetype;
	char *ident;
	int num;
	char *boollit;
	struct expression_t *expression;
};

struct term_t {
	int nodetype;
	struct factor_t *factor;
	struct factor_t *factor_2;
};

struct simple_expression_t {
	int nodetype;
	struct term_t *term;
	struct term_t *term_2;
};

struct else_clause_t {
	int nodetype;
	struct statement_sequence_t *statement_sequence;
};

struct expression_t {
	int nodetype;
	struct simple_expression_t *simple_expression;
	struct simple_expression_t *simple_expression_2;
};

struct write_int_t {
	int nodetype;
	struct expression_t *expression;
};

struct while_statement_t {
	int nodetype;
	struct expression_t *expression;
	struct statement_sequence_t *statement_sequence;
};

struct assignment_t {
	int nodetype;
	char *ident;
	struct expression_t *expression; /* expression could be a readInt */
};

struct if_statement_t {
	int nodetype;
	struct expression_t *expression;
	struct statement_sequence_t *statement_sequence;
	struct else_clause_t *else_clause;
};

struct statement_t {
	int nodetype;
	struct assignment_t *assignment;
	struct if_statement_t *if_statement;
	struct while_statement_t *while_statement;
	struct write_int_t *write_int;
};

struct statement_sequence_t {
	int nodetype;
	struct statement_t *statement;
	struct statement_sequence_t *next;
};

struct type_t {
	int nodetype;
	char *value;
};

struct declaration_t {
	int nodetype;
	char *ident;
	char *type;
	struct declaration_t *inner;
};

struct program_t {
	int nodetype;
	struct declaration_t *declarations;
	struct statement_sequence_t *statements;
};

struct program_t *new_program_t(int nodetype, struct declaration_t *l, struct statement_sequence_t *r);
struct declaration_t *new_declaration_t(int nodetype, char *ident, char *type, struct declaration_t *inner);
struct type_t *new_type_t(int nodetype, char *value);
struct statement_sequence_t *new_statement_sequence_t(int nodetype, struct statement_t *statement, struct statement_sequence_t *next);

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

%token BOOLLIT
%token NUM
%token IDENT

%%
program : PROGRAM declarations BGN statementSequence END { $$ = new_program_t(1, $2, $4); }

declarations : VAR IDENT AS type SC declarations { $$ = new_declaration_t(2, $2, $4, $5); }
               |
	       ;

type : INT  { $$ = new_type_t(3, $1); }
     | BOOL { $$ = new_type_t(3, $1); }

statementSequence : statement SC statementSequence { $$ = new_statement_sequence_t(3, $1, $3); }
                    |
		    ;

statement : assignment
            | ifStatement
            | whileStatement
            | writeInt

assignment : IDENT ASGN expression
             | IDENT ASGN READINT

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

factor : IDENT
         | NUM
         | BOOLLIT
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
void yyerror(char *s) {
   fprintf(stdout, "%s\n", s);
}

struct program_t *new_program_t(int nodetype, struct declaration_t *l, struct statement_sequence_t *r)
{
	struct program_t *a = malloc(sizeof(struct program_t));
	
	if(!a) {
		yyerror("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->declarations = l;
	a->statements = r;
	return a;
}

struct declaration_t *new_declaration_t(int nodetype, char *ident, char *type, struct declaration_t *inner)
{
	struct declaration_t *return_val = malloc(sizeof(struct declaration_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->ident = ident;
	return_val->type = type;
	return_val->inner = inner;
	return return_val;
}

struct type_t *new_type_t(int nodetype, char *value) {
	struct type_t *return_val = malloc(sizeof(struct type_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->value = value;
	return return_val;
}

struct statement_sequence_t *new_statement_sequence_t(int nodetype, struct statement_t *statement, struct statement_sequence_t *next) {
	struct statement_sequence_t *return_val = malloc(sizeof(struct statement_sequence_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->statement = statement;
	return_val->next = next;
	return return_val;
}

