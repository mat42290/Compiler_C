all: comp

comp: y.tab.o lex.yy.o
	gcc -Wall y.tab.o lex.yy.o -o comp

y.tab.c: c.y
	yacc --verbose --debug -d c.y

lex.yy.c: c.l
	lex c.l
