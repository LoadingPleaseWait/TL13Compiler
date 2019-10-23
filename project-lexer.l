%{
#include<stdio.h>

enum yytokentype{ 
	NUM = 1,
	BOOLLIT = 2,
	IDENT = 3,
	LP = 4,
	RP = 5,
	ASGN = 6,
	SC = 7,
	OP2 = 8,
	OP3 = 9,
	OP4 = 10,
	IF = 11,
	THEN = 12,
	ELSE = 13,
	BGN = 14,
	END = 15,
	WHILE = 16,
	DO = 17,
	PROGRAM = 18,
	VAR = 19,
	AS = 20,
	INT = 21,
	BOOL = 22,
	READINT = 23,
	WRITEINT = 24
};

char* yylval = "";
%}

%%

%.* {}

"("	return LP;
")"	return RP;
":="	return ASGN;
";"	return SC;
"*"|"div"|"mod"	return OP2;
"+"|"-"	return OP3;
"="|"!="|"<"|">"|"<="|">="	return OP4;

"if"	return IF;
"then"	return THEN;
"else"	return ELSE;
"begin"	return BGN;
"end"	return END;
"while"	return WHILE;
"do"	return DO;
"program"	return PROGRAM;
"var"	return VAR;
"as"	return AS;
"int"	return INT;
"bool"	return BOOL;

"writeInt"	return WRITEINT;
"readInt"	return READINT;

[1-9][0-9]*|0	{yylval = yytext; return NUM;}
"false"|"true"	{yylval = yytext; return BOOLLIT;}
[A-Za-z][0-9A-Za-z]*	{yylval = yytext; return IDENT;}
%%

int main()
{
	int ret = 0;
	
	while((ret = yylex()))
	{
		 printf("Token: %i Lexeme: %s\t", ret, yylval);
		 yylval = "";
	}
}

