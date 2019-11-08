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
struct statement_t *new_statement_t(int nodetype, struct assignment_t *assignment, struct if_statement_t *if_statement, struct while_statement_t *while_statement, struct write_int_t *write_int);
struct assignment_t *new_assignment_t(int nodetype, char *ident, struct expression_t *expression);
struct if_statement_t *new_if_statement_t(int nodetype, struct expression_t *expression, struct statement_sequence_t *statement_sequence, struct else_clause_t *else_clause);
struct else_clause_t *new_else_clause_t(int nodetype, struct statement_sequence_t *statement_sequence);
struct while_statement_t *new_while_statement_t(int nodetype, struct expression_t *expression, struct statement_sequence_t *statement_sequence);
struct write_int_t *new_write_int_t(int nodetype, struct expression_t *expression);
struct expression_t *new_expression_t(int nodetype, struct simple_expression_t *simple_expression, struct simple_expression_t *simple_expression_2);
struct simple_expression_t *new_simple_expression_t(int nodetype, struct term_t *term, struct term_t *term_2);
struct term_t *new_term_t(int nodetype, struct factor_t *factor, struct factor_t *factor_2);
struct factor_t *new_factor_t(int nodetype, char *ident, int num, char *boollit, struct expression_t *expression);


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

statement : assignment { struct statement_t *statement = new_statement_t(4, $1, NULL, NULL, NULL); $$ = statement; }
            | ifStatement { struct statement_t *statement = new_statement_t(4, NULL, $1, NULL, NULL); $$ = statement; }
            | whileStatement { struct statement_t *statement = new_statement_t(4, NULL, NULL, $1, NULL); $$ = statement; }
            | writeInt { struct statement_t *statement = new_statement_t(4, NULL, NULL, NULL, $1); $$ = statement; }

assignment : IDENT ASGN expression { struct assignment_t *assignment = new_assignment_t(5, $1, $3); $$ = assignment; }
             | IDENT ASGN READINT { struct assignment_t *assignment = new_assignment_t(5, $1, $3); $$ = assignment; }


ifStatement : IF expression THEN statementSequence elseClause END { struct if_statement_t *if_statement_t = new_if_statement_t(6, $2, $4, $5); $$ = if_statement_t; }

elseClause : ELSE statementSequence { struct else_clause_t *else_clause = new_else_clause_t(7, $2); $$ = else_clause; }
             |
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

struct statement_t *new_statement_t(int nodetype, struct assignment_t *assignment, struct if_statement_t *if_statement, struct while_statement_t *while_statement, struct write_int_t *write_int) {
	struct statement_t *return_val = malloc(sizeof(struct statement_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->assignment = assignment;
	return_val->if_statement = if_statement;
	return_val->while_statement = while_statement;
	return_val->write_int = write_int;
	return return_val;
}

struct assignment_t *new_assignment_t(int nodetype, char *ident, struct expression_t *expression) {
	struct assignment_t *return_val = malloc(sizeof(struct assignment_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->ident = ident;
	return_val->expression = expression;
	return return_val;
}

struct if_statement_t *new_if_statement_t(int nodetype, struct expression_t *expression, struct statement_sequence_t *statement_sequence, struct else_clause_t *else_clause) {
	struct if_statement_t *return_val = malloc(sizeof(struct if_statement_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->expression = expression;
	return_val->statement_sequence = statement_sequence;
	return_val->else_clause = else_clause;
	return return_val;
}

struct else_clause_t *new_else_clause_t(int nodetype, struct statement_sequence_t *statement_sequence) {
	struct else_clause_t *return_val = malloc(sizeof(struct else_clause_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->statement_sequence = statement_sequence;
	return return_val;
}

struct while_statement_t *new_while_statement_t(int nodetype, struct expression_t *expression, struct statement_sequence_t *statement_sequence) {
	struct while_statement_t *return_val = malloc(sizeof(struct while_statement_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->expression = expression;
	return_val->statement_sequence = statement_sequence;
	return return_val;
}

struct write_int_t *new_write_int_t(int nodetype, struct expression_t *expression) {
	struct write_int_t *return_val = malloc(sizeof(struct write_int_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->expression = expression;
	return return_val;
}

struct expression_t *new_expression_t(int nodetype, struct simple_expression_t *simple_expression, struct simple_expression_t *simple_expression_2) {
	struct expression_t *return_val = malloc(sizeof(struct expression_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->simple_expression = simple_expression;
	return_val->simple_expression_2 = simple_expression_2;
	return return_val;
}

struct simple_expression_t *new_simple_expression_t(int nodetype, struct term_t *term, struct term_t *term_2) {
	struct simple_expression_t *return_val = malloc(sizeof(struct simple_expression_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->term = term;
	return_val->term_2 = term_2;
	return return_val;
}

struct term_t *new_term_t(int nodetype, struct factor_t *factor, struct factor_t *factor_2){
	struct term_t *return_val = malloc(sizeof(struct term_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->factor = factor;
	return_val->factor_2 = factor_2;
	return return_val;
}

struct factor_t *new_factor_t(int nodetype, char *ident, int num, char *boollit, struct expression_t *expression) {
	struct factor_t *return_val = malloc(sizeof(struct factor_t));
	
	if(!return_val) {
		yyerror("out of space");
		exit(0);
	}
	return_val->nodetype = nodetype;
	return_val->ident = ident;
	return_val->num = num;
	return_val->boollit = boollit;
	return_val->expression = expression;
	return return_val;
}

