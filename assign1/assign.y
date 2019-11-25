%baseclass-preinclude <iostream>
%lsp-needed

%token NATURAL;
%token BOOLEAN;
%token TRUE;
%token FALSE;
%token NUMBER;
%token IDENT;
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
