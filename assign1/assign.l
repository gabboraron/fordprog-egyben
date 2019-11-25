%option noyywrap c++ yylineno

%{
#include "Parserbase.h"
%}

DIGIT   [0-9]
ALPHA   [A-Za-z]
WS  [ \t\n]

%%

natural                         return Parser::NATURAL;
boolean                          return Parser::BOOLEAN;
true                            return Parser::TRUE;
false                           return Parser::FALSE;
{DIGIT}+                        return Parser::NUMBER;
{ALPHA}({DIGIT}|{ALPHA})*       return Parser::IDENT;
":="                             return Parser::ASSIGN;
{WS}+                           // feher szokozok: semmi teendo

.           {
                std::cerr << lineno() << ": Lexikalis hiba." << std::endl;
                exit(1);
            }

%%
