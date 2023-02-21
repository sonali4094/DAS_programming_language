bison -y -d dasyacc.y
flex daslexerfile.l
gcc -c y.tab.c lex.yy.c
gcc y.tab.o lex.yy.o dasc.c -o daslan
 

