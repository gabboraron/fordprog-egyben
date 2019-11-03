%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
using namespace std;
%}

DIGIT		    [0-9]
WS  			[ \t\n]
CHAR  			[a-zA-Z]
UNDERSCORE		"_"

%%

PROGRAM		      std::cout << "kulcsszo: PROGRAM" 		<< std::endl;
PROGRAM_VEGE      std::cout << "kulcsszo: PROGRAM_VEGE" << std::endl;
VALTOZOK:         std::cout << "kulcsszo: VALTOZOK:"	<< std::endl;
UTASITASOK:       std::cout << "kulcsszo: UTASITASOK:" 	<< std::endl;
EGESZ             std::cout << "kulcsszo: EGESZ" 		<< std::endl;
LOGIKAI        	  std::cout << "kulcsszo: LOGIKAI" 		<< std::endl;
IGAZ         	  std::cout << "kulcsszo: IGAZ" 		<< std::endl;
HAMIS          	  std::cout << "kulcsszo: HAMIS" 		<< std::endl;
ES         	  	  std::cout << "kulcsszo: ES" 			<< std::endl;
VAGY	          std::cout << "kulcsszo: VAGY" 		<< std::endl;
NEM    	      	  std::cout << "kulcsszo: NEM" 			<< std::endl;
SKIP         	  std::cout << "kulcsszo: SKIP" 		<< std::endl;
HA         	  	  std::cout << "kulcsszo: HA" 			<< std::endl;
AKKOR         	  std::cout << "kulcsszo: AKKOR" 		<< std::endl;
KULONBEN          std::cout << "kulcsszo: KULONBEN" 	<< std::endl;
HA_VEGE           std::cout << "kulcsszo: HA_VEGE" 		<< std::endl;
CIKLUS         	  std::cout << "kulcsszo: CIKLUS" 		<< std::endl;
AMIG              std::cout << "kulcsszo: AMIG" 		<< std::endl;
CIKLUS_VEGE       std::cout << "kulcsszo: CIKLUS_VEGE" 	<< std::endl;
KI:               std::cout << "kulcsszo: KI:" 			<< std::endl;
BE:         	  std::cout << "kulcsszo: BE:" 			<< std::endl;


{DIGIT}+   		  std::cout << "karakter(ek): "		 << YYText()<< std::endl;
{WS}+    		  std::cout << "ureskarakter(ek): "  << YYText()<< std::endl;
"#"+.*+\n	 	  std::cout << "megjegyzes: "   	 << YYText()<< std::endl;

({CHAR}|{UNDERSCORE})+({CHAR}|{DIGIT}|{UNDERSCORE})*			std::cout << "azonosito: " << YYText() << std::endl;

":="        	  std::cout << "ertekadas "   		<< YYText() << std::endl;
"."        		  std::cout << "pont "			   	<< YYText() << std::endl;
"<"         	  std::cout << "kisebb "		   	<< YYText() << std::endl;
"<="         	  std::cout << "kisebbegyenlo "    	<< YYText() << std::endl;
">"         	  std::cout << "nagyobb " 			<< YYText() << std::endl;
">="         	  std::cout << "nagyobbegyenlo "	<< YYText() << std::endl;
"="         	  std::cout << "egynelo "			<< YYText() << std::endl;
"("         	  std::cout << "nyito kerek "	  	<< YYText() << std::endl;
")"         	  std::cout << "zaro kerek "   		<< YYText() << std::endl;
"+"         	  std::cout << "plusz "				<< YYText() << std::endl;
"-"         	  std::cout << "minusz "			<< YYText() << std::endl;
"*"         	  std::cout << "csillag "			<< YYText() << std::endl;
"/"         	  std::cout << "egeszosztas "		<< YYText() << std::endl;
"%"         	  std::cout << "maradekkepzes "		<< YYText() << std::endl;


.           {
                std::cerr << lineno() << ": Lexikalis hiba." << std::endl;
                exit(1);
            }
%%