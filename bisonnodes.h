//
//  bisonnodes.h
//  bisonprint.h
//
//  Created by Samuel Button on 11/9/19.
//  Copyright © 2019 Samuel Button. All rights reserved.
//

#ifndef bisonnodes_h
#define bisonnodes_h
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

struct declaration_t *new_declaration_t(int nodetype, char *ident, type_t *type, struct declaration_t *inner)
{
    struct declaration_t *return_val = malloc(sizeof(struct declaration_t));
    
    if(!return_val) {
        yyerror("out of space");
        exit(0);
    }
    return_val->nodetype = nodetype;
    return_val->ident = ident;
    return_val->type = type->value;
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
#endif /* bisonnodes_h */
