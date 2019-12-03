//
//  bisonprint.h
//  bisonprint.h
//
//  Created by Samuel Button on 11/9/19.
//  Copyright © 2019 Samuel Button. All rights reserved.
//

#ifndef bisonprint_h
#define bisonprint_h
#include "bisonnodes.h"

void printProgram(struct program_t *);
void printDeclarations(struct declaration_t *);
void printStatementSequ(struct statement_sequence_t *);
void printStatement(struct statement_t *);
void printWriteInt(struct write_int_t *);
void printWhileStatement(struct while_statement_t *);
void printIfStatement(struct if_statement_t *);
void printElse(struct else_clause_t *);
void printAssignement(struct assignment_t *);
void printExpression(struct expression_t *);
void printSimpleExpression(struct simple_expression_t *);
void printTerm(struct term_t *);
void printFactor(struct factor_t *);

char *isolate_identifier(char *input);

#endif /* bisonprint_h */
