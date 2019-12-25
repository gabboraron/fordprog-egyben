%option noyywrap c++ yylineno

%{
#include "Parserbase.h"
%}


DIGIT		    [0-9]
WS  			[ \t\n]
CHAR  			[a-zA-Z]
UNDERSCORE		"_"

%%

PROGRAM		    {
					//std::cerr <<  "PROGARM: " << YYText() <<std::endl;
					return Parser::PROGRAM;
				}
PROGRAM_VEGE    {
					//std::cerr <<  "PROGARM_vege: " << YYText() <<std::endl;
					return Parser::PROGRAM_VEGE;
				}
VALTOZOK:         return Parser::VALTOZOK;
UTASITASOK:     {
					//std::cerr <<  "utasitasok: " << YYText() <<std::endl;
					return Parser::UTASITASOK;
				}

EGESZ             return Parser::EGESZ;
LOGIKAI        	  return Parser::LOGIKAI;
IGAZ         	  return Parser::IGAZ;
HAMIS          	  return Parser::HAMIS;
ES         	  	  return Parser::ES;
VAGY	          return Parser::VAGY;
NEM    	      	  return Parser::NEM;
SKIP         	  {
					//std::cerr <<  "skip " << YYText() <<std::endl;
					return Parser::SKIP;
				  }
HA         	  	  return Parser::HA;
AKKOR         	  return Parser::AKKOR;
KULONBEN          return Parser::KULONBEN;
HA_VEGE           return Parser::HA_VEGE;
CIKLUS         	  return Parser::CIKLUS;
AMIG              return Parser::AMIG;
CIKLUS_VEGE       return Parser::CIKLUS_VEGE;
KI:               return Parser::KI;
BE:         	  return Parser::BE;


{DIGIT}+   		  return Parser::NUMBER;
{WS}+    		  //whitespace
"#"+.*+\n	 	  {
					//std::cout << "megjegyzes: "   << YYText()<< std::endl;
				  }	

({CHAR}|{UNDERSCORE})+({CHAR}|{DIGIT}|{UNDERSCORE})*			{
																	//std::cerr <<  "azonosito: " << YYText() <<std::endl;
																	return Parser::AZONOSITO;
																}

":="        	  return Parser::SETTER;
"."        		  //return Parser::POINT;
"<"         	  return Parser::LT;
"<="         	  return Parser::LTOREQ;
">"         	  return Parser::GT;
">="         	  return Parser::GTOREQ;
"="         	  return Parser::EQ;
"("         	  return Parser::OPEN;
")"         	  return Parser::CLOSE;
"+"         	  return Parser::PLUS;
"-"         	  return Parser::MINUS;
"*"         	  return Parser::STAR;
"/"         	  return Parser::DIV;
"%"         	  return Parser::MOD;


.           {
                std::cerr << lineno() << ": Lexikalis hiba: " << YYText() << std::endl;
                exit(1);
            }
%%