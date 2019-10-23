%{
#include<stdio.h>

#include"parser.tab.h"
%}

%%

%.* {}
[\t ] {}

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
