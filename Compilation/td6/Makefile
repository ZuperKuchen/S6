#Makefile 
CC = gcc 
CPPFLAGS=
CFLAGS=-g -Wall -std=c99
LDFLAGS=-lm 
FLEX = flex 
BISON = bison
BFLAGS=-d --report=all
HEADERS= tableaux.tab.h arbre.h interp.h

NOM = tableaux
#interpreteur de tableaux

$(NOM):	$(NOM).tab.o arbre.o interp.o 
	$(CC) $^ $(LDFLAGS) -o $@

$(NOM).tab.c: $(NOM).y lex.yy.c arbre.h interp.h 
	$(BISON) $(BFLAGS) $(NOM).y

lex.yy.c: $(NOM).l
	$(FLEX) $(NOM).l

$(NOM).tab.h: $(NOM).tab.c

lex.yy.o: lex.yy.c $(NOM).tab.h
arbre.o: arbre.c arbre.h $(NOM).tab.h
interp.o: interp.c interp.h $(NOM).tab.h

.PHONY: clean nickel

clean:
	rm -f *.tab.? lex.*.c *.o *~ \#*\#

