%baseclass-preinclude <iostream>
%lsp-needed

%token NUMBER
%token AZONOSITO
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


%right NEM
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

%%

start:
    program
    {
        std::cout << "start -> program" << std::endl;
    }
;

program:
    PROGRAM AZONOSITO VALTOZOK declarations UTASITASOK mainpart PROGRAM_VEGE
    {
        std::cout << "program -> PROGRAM AZONOSITO VALTOZOK: declarations UTASITASOK: mainpart PROGRAM_VEGE" << std::endl;
    }
|   
    PROGRAM AZONOSITO UTASITASOK mainpart PROGRAM_VEGE
    {
        std::cout << "program -> PROGRAM AZONOSITO UTASITASOK: mainpart PROGRAM_VEGE" << std::endl;
    }
;


declarations:
    declaration
    {
        std::cout << "declarations -> declaration" << std::endl;
    }
|
    declarations declaration
    {
        std::cout << "declarations -> declarations declaration" << std::endl;
    }
;


declaration:
    type AZONOSITO
    {
        std::cout << "declaration -> type AZONOSITO" << std::endl;
    }
;


type:
    EGESZ
    {
        std::cout << "type -> EGESZ" << std::endl;
    }
|
    LOGIKAI
    {
        std::cout << "type -> LOGIKAI" << std::endl;
    }
;
      

mainpart:
    utasitas
    {
        std::cout << "mainpart -> utasitas" << std::endl;
    }
|    
    utasitas mainpart
    {
        std::cout << "mainpart -> utasitas mainpart" << std::endl;
    }
;

utasitas:
    SKIP
    {
        std::cout << "utasitas -> SKIP" << std::endl;
    }
| 
    assignment
    {
        std::cout << "utasitas -> assignment" << std::endl;
    }
|
    be
    {
        std::cout << "utasitas -> be" << std::endl;
    }
|
    ki
    {
        std::cout << "utasitas -> ki" << std::endl;
    }
|
    elagazas
    {
        std::cout << "utasitas -> elagazas" << std::endl;
    }
|
    ciklus
    {
        std::cout << "utasitas -> ciklus" << std::endl;
    }
;

assignment:
    AZONOSITO SETTER kifejezes
    {
        std::cout << "assignment -> AZONOSITO SETTER kifejezes" << std::endl;   
    }
;

be:
    BE AZONOSITO
    {
        std::cout << "be -> BE AZONOSITO" << std::endl;   
    }
;

ki:
    KI kifejezes
    {
        std::cout << "ki -> KI kifejezes" << std::endl;   
    }
;


elagazas:
    HA kifejezes AKKOR mainpart HA_VEGE
    {
        std::cout << "elagazas -> HA kifejezes AKKOR mainpart HA_VEGE" << std::endl;   
    }
|
    HA kifejezes AKKOR mainpart KULONBEN mainpart HA_VEGE
    {
        std::cout << "elagazas -> HA kifejezes AKKOR mainpart KULONBEN mainpart HA_VEGE" << std::endl;   
    }
;

ciklus:
    CIKLUS AMIG kifejezes mainpart CIKLUS_VEGE
    {
        std::cout << "ciklus -> CIKLUS AMIG kifejezes mainpart CIKLUS_VEGE" << std::endl;   
    }
;    


kifejezes:
    kifejezes EQ kifejezes 
    {
        std::cout << "kifejezes -> EQ" << std::endl;
    }
|
    kifejezes GT kifejezes 
    {
        std::cout << "kifejezes -> GT" << std::endl;
    }
|
    kifejezes GTOREQ kifejezes 
    {
        std::cout << "kifejezes -> GTOREQ" << std::endl;
    }
|
    kifejezes LT kifejezes 
    {
        std::cout << "kifejezes -> LT" << std::endl;
    }
|
    kifejezes LTOREQ kifejezes 
    {
        std::cout << "kifejezes -> LTOREQ" << std::endl;
    }
|
    kifejezes STAR kifejezes 
    {
        std::cout << "kifejezes -> STAR " << std::endl;
    }
|
    kifejezes DIV kifejezes 
    {
        std::cout << "kifejezes -> DIV " << std::endl;
    }
|
    kifejezes MOD kifejezes 
    {
        std::cout << "kifejezes -> MOD " << std::endl;
    }
|
    kifejezes ES kifejezes
    {
        std::cout << "kifejezes -> kifejezes ES kifejezes" << std::endl;
    }
|
    kifejezes VAGY kifejezes
    {
        std::cout << "kifejezes -> kifejezes VAGY kifejezes" << std::endl;
    }
|
    OPEN kifejezes CLOSE    
    {
        std::cout << "kifejezes -> OPEN kifejezes CLOSE" << std::endl;
    }
|    
    kifejezes PLUS kifejezes    
    {
        std::cout << "kifejezes -> kifejezes PLUS kifejezes" << std::endl;
    }
|
    kifejezes MINUS kifejezes    
    {
        std::cout << "kifejezes -> kifejezes MINUS kifejezes" << std::endl;
    }
|
    IGAZ    
    {
        std::cout << "kifejezes -> IGAZ" << std::endl;
    }
|
    HAMIS    
    {
        std::cout << "kifejezes -> HAMIS" << std::endl;
    }
|
    AZONOSITO    
    {
        std::cout << "kifejezes -> AZONOSITO" << std::endl;
    }
|
    NEM kifejezes
    {
        std::cout << "kifejezes -> NEM kifejezes" << std::endl;
    }

|   NUMBER
    {
        std::cout << "kifejezes -> NUMBER" << std::endl;
    }
;