//
//  bisonprint.h
//  bisonprint.h
//
//  Created by Samuel Button on 11/9/19.
//  Copyright © 2019 Samuel Button. All rights reserved.
//

#ifndef bisonprint_h
#define bisonprint_h
void printProgram(struct program_t *p)
{
    printf("#include <stdio.h>\n\nint main(int argc, const char * argv[]) {\n");
    printDeclarations(p->declarations);
    printStatementSequ(p->statements);
    printf("return 0;\n}");
}
void printDeclarations(struct declaration_t *d)
{
    printf("%s %s;\n", d->type, d->ident);
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
            printAssignment(s->assignment);
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
    printf("printf(\"%n\", ");
    printExpression(wi->expression);
    printf(");\n");
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
        printf("%s = ", a->ident);
        printExpression(a->expression);
        printf(";\n");
        
    }
    else if(a->nodetype == 1)
    {
        printf("scanf(\"\%d\",&%s);\n", a->ident);
    }
}
void printExpression(struct expression_t)
{
    printf("Expression goes here");
}

#endif /* bisonprint_h */
