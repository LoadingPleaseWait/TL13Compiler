/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BGN = 258,
     END = 259,
     VAR = 260,
     AS = 261,
     LP = 262,
     RP = 263,
     ASGN = 264,
     SC = 265,
     OP2 = 266,
     OP3 = 267,
     OP4 = 268,
     IF = 269,
     THEN = 270,
     ELSE = 271,
     WHILE = 272,
     DO = 273,
     PROGRAM = 274,
     INT = 275,
     BOOL = 276,
     WRITEINT = 277,
     READINT = 278,
     BOOLLIT = 279,
     NUM = 280,
     IDENT = 281
   };
#endif
/* Tokens.  */
#define BGN 258
#define END 259
#define VAR 260
#define AS 261
#define LP 262
#define RP 263
#define ASGN 264
#define SC 265
#define OP2 266
#define OP3 267
#define OP4 268
#define IF 269
#define THEN 270
#define ELSE 271
#define WHILE 272
#define DO 273
#define PROGRAM 274
#define INT 275
#define BOOL 276
#define WRITEINT 277
#define READINT 278
#define BOOLLIT 279
#define NUM 280
#define IDENT 281




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 19 "parser.y"
{
double iValue; /* double value */
char * sIndex; /* symbol table index */
int boolType; /*true or false*/
void* NodePtr;
}
/* Line 1529 of yacc.c.  */
#line 108 "parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

