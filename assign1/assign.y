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
 if( szimbolumtabla.count(*$2) > 0 )
  {
    std::stringstream ss;
    ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
    << "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
    error( ss.str().c_str() );
  }
  else
  {
    szimbolumtabla[*$2] = var_data( d_loc__.first_line, natural );
  }
}
|
BOOLEAN IDENT
{
 if( szimbolumtabla.count(*$2) > 0 )
  {
    std::stringstream ss;
    ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
    << "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
    error( ss.str().c_str() );
  }
  else
  {
	szimbolumtabla[*$2] = var_data( d_loc__.first_line, boolean );
  }
}
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
