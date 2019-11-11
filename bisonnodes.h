//
//  bisonnodes.h
//  bisonprint.h
//
//  Created by Samuel Button on 11/9/19.
//  Copyright © 2019 Samuel Button. All rights reserved.
//

#ifndef bisonnodes_h
#define bisonnodes_h
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
struct declaration_t *new_declaration_t(int nodetype, char *ident, struct type_t *type, struct declaration_t *inner);
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


#endif /* bisonnodes_h */
