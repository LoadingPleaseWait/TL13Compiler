//
//  bisonFunctions.c
//  bisonprint.h
//
//  Created by Samuel Button on 11/9/19.
//  Copyright © 2019 Samuel Button. All rights reserved.
//
#include <stdio.h>
#include <stdlib.h>
#include "bisonprint.h"
#include "bisonnodes.h"

void printProgram(struct program_t *p)
{
    printf("#include <stdio.h>\n\nint main(int argc, const char * argv[]) {\n");
    printDeclarations(p->declarations);
    printStatementSequ(p->statements);
    printf("return 0;\n}");
}
void printDeclarations(struct declaration_t *d)
{
    //printf("begin printDeclarations\n %s\n", d->ident);
    //printf("d->type, d->ident: %s, %s\n", d->type, d->ident);
    //printf("should have printed info for printDeclarations\n");
    printf("%s %s;\n", "int", d->ident);
    if(d->inner)
    {
        printDeclarations(d->inner);
    }
}
void printStatementSequ(struct statement_sequence_t *ss)
{
    printStatement(ss->statement);
    if(ss->next)
    {
        printStatementSequ(ss->next);
    }
}
void printStatement(struct statement_t *s)
{
    int nt = s->nodetype;
    switch (nt) {
        case 0:
            // Done
            printAssignement(s->assignment);
            break;
        case 1:
            //done
            printIfStatement(s->if_statement);
            break;
        case 2:
            //done
            printWhileStatement(s->while_statement);
            break;
        case 3:
            //done
            printWriteInt(s->write_int);
            break;
        default:
            break;
    }
}
void printWriteInt(struct write_int_t *wi)
{
    printf("printf(\"\%%d\", (");
    printExpression(wi->expression);
    printf("));\n");
}
void printWhileStatement(struct while_statement_t *w)
{
    printf("while(");
    printExpression(w->expression);
    printf(")\n{\n");
    if(w->statement_sequence)
    {
        printStatementSequ(w->statement_sequence);
    }
    printf("}\n");
}
void printIfStatement(struct if_statement_t *i)
{
    printf("if(");
    printExpression(i->expression);
    printf(")\n{\n");
    if(i->statement_sequence)
    {
        printStatementSequ(i->statement_sequence);
    }
    printf("}\n");
    if(i->else_clause)
    {
        printElse(i->else_clause);
    }
}
void printElse(struct else_clause_t *e)
{
    printf("else\n{\n");
    printStatementSequ(e->statement_sequence);
    printf("}\n");
}
void printAssignement(struct assignment_t *a)
{
    if(a->nodetype == 0)
    {
        //printf("BEGIN IDENT:%sENDIDENT", a->ident);
        printf("%s = ", isolate_identifier(a->ident));
        printExpression(a->expression);
        printf(";\n");
        
    }
    else if(a->nodetype == 1)
    {
        printf("scanf(\"%%d\",&%s);\n", a->ident);
    }
}
void printExpression(struct expression_t *e)
{
    //printf("Expression goes here");
    if (e->simple_expression)
        printSimpleExpression(e->simple_expression);
    if (e->simple_expression_2)
        printSimpleExpression(e->simple_expression_2);

}
void printSimpleExpression(struct simple_expression_t *simple)
{
    // CURRENTLY HARD CODED FOR MULTIPLICATION AND SUBTRACTION
    // TODO support other operations
    //printf("simple->term: %s.\n", simple->term);
    //printf("%s * %s", simple->term, simple->term_2);
    if (simple->term)
    {
        printTerm(simple->term);
    }
    if (simple->term_2)
    {
        printf("-");
        printTerm(simple->term_2);
    }
}
void printTerm(struct term_t *term)
{
    if (term->factor)
    {
        printFactor(term->factor);
    }
    if (term->factor_2)
    {
        printf("*");
        printFactor(term->factor_2);
    }
}
void printFactor(struct factor_t *factor)
{
    if (factor->ident)
    {
        printf("%s", factor->ident);
    }
    else if (factor->expression)
    {
        printf("(");
        printExpression(factor->expression);
        printf(")");
    }
    else if (factor->boollit)
    {
        printf("%d", factor->boollit);
    }
    else //if (factor->num)
    {
        printf("%d", factor->num);
    }

}


/// Utility function to get the first word of a string
char *isolate_identifier(char *input)
{
    char delimiter[] = " ";
    int length = strlen(input);
    char *strtokReturn = (char*) calloc(length + 1, sizeof(char));
    char *output = (char*) calloc(length + 1, sizeof(char));
    strncpy(output, input, length);
    strtokReturn = strtok(output, delimiter);
    // TODO figure out why strtokReturn gives a bad memory address
    //printf("identifier: %s\n", output);

    return output;
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

struct declaration_t *new_declaration_t(int nodetype, char *ident, struct type_t *type, struct declaration_t *inner)
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

struct type_t *new_type_t(int nodetype) {
    struct type_t *return_val = malloc(sizeof(struct type_t));
    
    if(!return_val) {
        yyerror("out of space");
        exit(0);
    }
    return_val->nodetype = nodetype;
    if(nodetype ==0)
    {
        return_val->value = "INT";
    }
    else
    {
        return_val->value = "BOOL";
    }
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

struct factor_t *new_factor_t(int nodetype1, char *ident1, int num1, int boollit1, struct expression_t *expression1) {
    struct factor_t *return_val = malloc(sizeof(struct factor_t));
    
    if(!return_val) {
        yyerror("out of space");
        exit(0);
    }
    return_val->nodetype = nodetype1;
    return_val->ident = ident1;
    return_val->num = num1;
    return_val->boollit = boollit1;
    return_val->expression = expression1;
    return return_val;
}
