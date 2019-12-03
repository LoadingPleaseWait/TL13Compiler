%{
#include<stdio.h>
#include <string.h>
#include"parser.tab.h"
%}

%%

%.* {}
[\t\n ]+ {}

"("	return LP;
")"	return RP;
":="	return ASGN;
";"	return SC;
"*"|"div"|"mod"	{yylval.sIndex = strdup(yytext); return OP2;}
"+"|"-"	{yylval.sIndex = strdup(yytext); return OP3;}
"="|"!="|"<"|">"|"<="|">="	{yylval.sIndex = strdup(yytext); return OP4};

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

[1-9][0-9]*|0	{yylval.iValue = atoi(yytext); return NUM;}
"false" {yylval.boolType = 0; return BOOLLIT;}
"true"	{yylval.boolType = 1; return BOOLLIT;}
[A-Za-z][0-9A-Za-z]*	{yylval.sIndex = strdup(yytext); return IDENT;}
%%
/*
int main()
{
	int ret = 0;
	
	while((ret = yylex()))
	{
		 printf("Token: %i Lexeme: %s\t", ret, yylval);
		 yylval = "";
	}
}
*/
