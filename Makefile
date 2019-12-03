all: lex.yy.c parser.tab.c
	gcc -o tl13compiler -w -g -Dparse.trace bisonFunctions.c parser.tab.c lex.yy.c

lex.yy.c:
	flex project-lexer.l

parser.tab.c: parser.tab.h

parser.tab.h:
	bison -d -t --debug -Dparse.trace parser.y

.PHONY: all clean

clean:
	rm -f tl13compiler parser.tab.h parser.tab.c lex.yy.c
