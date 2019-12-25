%baseclass-preinclude "semantics.h"
%lsp-needed

%union
{
  std::string *szoveg;
  var_data *var;
  expr_data *expr;
  order_data *order;
}

%token NUMBER
%token <szoveg> AZONOSITO
%token PROGRAM
%token PROGRAM_VEGE
%token VALTOZOK
%token UTASITASOK
%token EGESZ
%token LOGIKAI
%token IGAZ
%token HAMIS
%token SKIP
%token HA
%token AKKOR
%token KULONBEN
%token HA_VEGE
%token CIKLUS
%token AMIG
%token CIKLUS_VEGE
%token KI
%token BE
%token OPEN
%token CLOSE


%left NEM
%left STAR
%left DIV
%left MOD
%left ES
%left VAGY
%left EQ
%left GT
%left GTOREQ
%left LT
%left LTOREQ
%left PLUS
%left MINUS
%left SETTER

%type<expr>     kifejezes
%type<order>    ertekadas
%type<order>    be
%type<order>    ki
%type<order>    elagazas
%type<order>    ciklus
%type<order>    utasitas
%type<order>    utasitasok
%type<order>    utasitaslista
%type<order>    deklaracio
%type<order>    deklaraciok
%type<order>    valtozolista
%type<order>    kezdes
%type<order>    befejezes

%%

start:
    starter declarations orders ending
    {
       delete $1;
       delete $2;
       delete $3;
       delete $4;
    }
;

starter:
    PROGARM AZONOSITO
    {
        $$ = new order_data(d_loc__.first_line);
    }
;

ending:
    PROGRAM_VEGE
    {
        $$ = new order_data(d_loc__.first_line);
    }
;

declarations:
    {
        //empty
        $$ = new order_data(d_loc__.first_line);
    }
|
    VALTOZOK declarationlist
    {
        $$ = new order_data(d_loc__.first_line);
        delete $2;
    }
;

declarationlist:
    declaration
|
    declaration declarations
    {
        $$ = new order_data($1 -> decl_row);
        delete $1;
        delete $2;
    }
;


declaration:
    EGESZ AZONOSITO
    {
        //std::cout << "declaration -> type AZONOSITO" << std::endl;
      if( szimbolumtabla.count(*$2) > 0 )
      {
        std::stringstream ss;
        ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
        << "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
        error( ss.str().c_str() );
      } else{
         szimbolumtabla[*$2] = var_data( d_loc__.first_line, natural);
         $$ = new order_data(d_loc__.first_line);
      }
      delete $2;
    }
|
    LOGIKAI AZONOSITO
    {
        //std::cout << "declaration -> type AZONOSITO" << std::endl;
      if( szimbolumtabla.count(*$2) > 0 )
      {
        std::stringstream ss;
        ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
        << "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
        error( ss.str().c_str() );
      } else{
         szimbolumtabla[*$2] = var_data( d_loc__.first_line, natural);
         $$ = new order_data(d_loc__.first_line);
      }
      delete $2;
    }
;
      
orders:
    UTASITASOK order orderlist
    {
        $$ = new order_data(d_loc__.first_line);
        delete $2;
        delete $3;
    }
;

orderlist:
    {
        //empty
        $$=new order_data(d_loc__.first_line);
    }
|
    order orderlist
    {
        $$ = new order_data($ ->decl_row);
        delete $1;
        delete $2;
    }
;

order:
    SKIP
    {
        $$ = new order_data(d_loc__.first_line);
    }
|
    assignment
    {
        //std::cout << "utasitas -> assignment" << std::endl;
    }
|
    be
    {
        //std::cout << "utasitas -> be" << std::endl;
    }
|
    ki
    {
        //std::cout << "utasitas -> ki" << std::endl;
    }
|
    elagazas
    {
        //std::cout << "utasitas -> elagazas" << std::endl;
    }
|
    ciklus
    {
        //std::cout << "utasitas -> ciklus" << std::endl;
    }
;

assignment:
    AZONOSITO SETTER kifejezes
    {
        //std::cout << "assignment -> AZONOSITO SETTER kifejezes" << std::endl;  
        if (szimbolumtabla.count(*$1) == 0)
        {
            std::stringstream ss;
            ss << d_loc__.first_line << " nem deklaralt valtozo: "<<*$1<<std::endl;
            error( ss.str().c_str() );
            exit(1);
        }
        else if( szimbolumtabla[*$1].var_type != *$3->k_type )
        {
          std::cerr<<d_loc__.first_line<<" Az ertekadasban kulonbozo tipusu kifejezesek"<<std::endl;
          exit(1);
        } 
        else
        {
            $$ = new order_data(d_loc__.first_line);
        }
        delete($3);
    }
;

be:
    BE AZONOSITO
    {
        if( szimbolumtabla.count( *$2 ) == 0 )
        {
            std::cerr << d_loc__.first_line <<"' valtozo nincs deklaralva: " << *$2 << std::endl;
            exit(1);
        }
        else
        {
            $$ = new order_data( d_loc__.first_line );
        }
        delete $2;
    }
;

ki:
    KI kifejezes
    {
        $$ = new order_data( d_loc__.first_line );
        delete $2;
    }
;


elagazas:
    HA kifejezes AKKOR order orderlist HA_VEGE
    {
        if( $2->k_type != boolean )
        {
            std::cerr << d_loc__.first_line << " Nem logikai tipusu elagazas feltetel." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new order_data( $2->decl_row );
        }
        delete $2;
        delete $4;
        delete $5;
    }
|
    HA kifejezes AKKOR order orderlist KULONBEN order orderlist HA_VEGE
    {
        if( $2->k_type != boolean)
        {
            std::cerr << d_loc__.first_line << ": Nem logikai tipusu elagazas feltetel." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new order_data( $2->decl_row );
        }
        delete $2;
        delete $4;
        delete $5;
        delete $7;
        delete $8;
    }
;

ciklus:
    CIKLUS AMIG kifejezes order orderlist CIKLUS_VEGE
    {
        if( $3->k_type != boolean )
        {
            std::cerr << d_loc__.first_line << ": Nem logikai ciklus feltetel" << std::endl;
            exit(1);
        }
        else
        {
            $$ = new order_data( $3->decl_row );
        }
        delete $3;
        delete $4;
        delete $5;
    }
;    


kifejezes:
    kifejezes EQ kifejezes 
    {
        //std::cout << "kifejezes -> EQ" << std::endl;
        if( $1->k_type != $3->k_type )
        {
            std::cerr << $1->decl_row << ": Az '=' operator jobb- es baloldala kulonbozo tipusu" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;
    }
|
    kifejezes GT kifejezes 
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '>' operator baloldalan nem natural tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '>' operator jobboldalan nem natural tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;
    }
|
    kifejezes GTOREQ kifejezes 
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '>=' operator baloldalan nem natural tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '>=' operator jobboldalan nem natural tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;
    }
|
    kifejezes LT kifejezes 
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '<' operator baloldalan nem natural" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '<' operator jobboldalan nem natural" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;
    }
|
    kifejezes LTOREQ kifejezes 
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '<=' operator baloldalan nem natural tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '<=' operator jobboldalan nem natural tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;
    }
|
    kifejezes STAR kifejezes 
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '*' operator baloldalan nem natural tipus all." << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '*' operator jobboldalan nem natural tipus all." << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, natural );
        delete $1;
        delete $3;
    }
|
    kifejezes DIV kifejezes 
    {
        //std::cout << "kifejezes -> DIV " << std::endl;
        if( szimbolumtabla[*$1].var_type != *$3 )
        {
          error( "Tipushibas muvelet.\n" );
        } else {
            if ($1->var_type != natural)
            {
                std::cerr << $3->decl_row << "Tipushibas osztas muvelet";
                exit(1);
            }
        }
        $$ = new type($1->var_type, natural);
        delete $1;
        delete $3;        
    }
|
    kifejezes MOD kifejezes 
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '%' operator baloldalan nem natural tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '%' operator jobboldalan nem natural tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, natural );
        delete $1;
        delete $3;
    }
|
    kifejezes ES kifejezes
    {
        //std::cout << "kifejezes -> kifejezes ES kifejezes" << std::endl;
        if( $1->k_type != boolean )
        {
            std::cerr << $1->decl_row << " 'ES' operator baloldalan nem boolean tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != boolean )
        {
            std::cerr << $3->decl_row << " 'ES' operator jobboldalan nem boolean tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;       
    }
|
    kifejezes VAGY kifejezes
    {
        //std::cout << "kifejezes -> kifejezes VAGY kifejezes" << std::endl;
        if( $1->k_type != boolean )
        {
            std::cerr << $1->decl_row << " 'VAGY' operator baloldalan nem boolean tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != boolean )
        {
            std::cerr << $3->decl_row << " 'VAGY' operator jobboldalan nem boolean tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $1;
        delete $3;        
    }
|
    OPEN kifejezes CLOSE    
    {
        //std::cout << "kifejezes -> OPEN kifejezes CLOSE" << std::endl;
        $$ = $2;
    }
|    
    kifejezes PLUS kifejezes    
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '+' operator baloldala nem natural tipus" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '+' operator jobboldala nem natural tipus" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, natural );
        delete $1;
        delete $3;
    }
|
    kifejezes MINUS kifejezes    
    {
        if( $1->k_type != natural )
        {
            std::cerr << $1->decl_row << " '-' operator baloldalan nem natural" << std::endl;
            exit(1);
        }
        if( $3->k_type != natural )
        {
            std::cerr << $3->decl_row << " '-' operator jobboldalan nem natural" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, natural );
        delete $1;
        delete $3;
    }
|
    IGAZ    
    {
        //std::cout << "kifejezes -> IGAZ" << std::endl;
        $$ = new type(d_loc__.first_line, boolean);
    }
|
    HAMIS    
    {
        //std::cout << "kifejezes -> HAMIS" << std::endl;
        $$ = new type(d_loc__.first_line, boolean);
    }
|
    AZONOSITO    
    {
        if( szimbolumtabla.count( *$1 ) == 0 )
        {
            std::cerr << d_loc__.decl_row << "' valtozo nincs deklaralva: "  << *$1  << std::endl;
            exit(1);
        }
        else
        {
            var_data vd = szimbolumtabla[*$1];
            $$ = new expr_data( vd.decl_row, vd.var_type );
            delete $1;
        }
    }
|
    NEM kifejezes
    {
        //std::cout << "kifejezes -> NEM kifejezes" << std::endl;
        if( $2->k_type != boolean )
        {
            std::cerr << $2->decl_row << " 'NEM' operator utan nem boolean tipus jon" << std::endl;
            exit(1);
        }
        $$ = new expr_data( d_loc__.first_line, boolean );
        delete $2;
    }

|   NUMBER
    {
        //std::cout << "kifejezes -> NUMBER" << std::endl;
        $$ = new type(d_loc__.first_line, natural);
        delete $1;
    }
;