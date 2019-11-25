%baseclass-preinclude "semantics.h"
%lsp-needed

%union
{
  std::string *szoveg;
}

%token <szoveg> IDENT;
%token NATURAL;
%token BOOLEAN;
%token TRUE;
%token FALSE;
%token NUMBER;
%token ASSIGN;

%%

start:
    declarations assignments
;

declarations:
    // ures
|
    declaration declarations
;

declaration:
    NATURAL IDENT
	{
	  std::cout << *$2 << std::endl;
	}
|
    BOOLEAN IDENT
;

assignments:
    // ures
|
    assignment assignments
;

assignment:
    IDENT ASSIGN expr
;

expr:
    IDENT
|
    NUMBER
|
    TRUE
|
    FALSE
;
