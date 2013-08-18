all:
	lex -o lex.yy.cc --header-file=lex.yy.h lexer.l
	yacc -d parser.y -o y.tab.cc
	g++ -g -ggdb -std=gnu++0x -Wall lex.yy.cc y.tab.cc -o main -Wno-unused #`llvm-config --cppflags --ldflags --libs core`
