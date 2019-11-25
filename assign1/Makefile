COMPILERNAME=assign

all: $(COMPILERNAME)
	-

clean:
	rm -rf $(COMPILERNAME) lex.yy.cc Parserbase.h parse.cc *~

lex.yy.cc: $(COMPILERNAME).l
	flex $(COMPILERNAME).l

parse.cc: $(COMPILERNAME).y
	bisonc++ $(COMPILERNAME).y

$(COMPILERNAME): $(COMPILERNAME).cc lex.yy.cc parse.cc Parser.ih Parser.h
	g++ -o$(COMPILERNAME) $(COMPILERNAME).cc parse.cc lex.yy.cc
