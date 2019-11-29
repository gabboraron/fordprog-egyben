%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
#include "Parserbase.h"
%}

DIGIT  		[0-9]
WS          [ \t\n]
LETTER      [a-zA-Z]

%%

program     return Parser::TOKEN_PROGRAM;
begin       return Parser::TOKEN_BEGIN;
end         return Parser::TOKEN_END;
integer     return Parser::TOKEN_INTEGER; 
boolean     return Parser::TOKEN_BOOLEAN;
skip        return Parser::TOKEN_SKIP;
if          return Parser::TOKEN_IF;
then        return Parser::TOKEN_THEN;
else        return Parser::TOKEN_ELSE;
endif       return Parser::TOKEN_ENDIF;
while       return Parser::TOKEN_WHILE;
do          return Parser::TOKEN_DO;
done        return Parser::TOKEN_DONE;
read        return Parser::TOKEN_READ;
write       return Parser::TOKEN_WRITE;
";"         return Parser::TOKEN_SEMICOLON;
":="        return Parser::TOKEN_ASSIGN;
"="         return Parser::TOKEN_EQ;
"<"         return Parser::TOKEN_LESS;
">"         return Parser::TOKEN_GR;
"+"         return Parser::TOKEN_ADD;
"-"         return Parser::TOKEN_SUB;
"*"         return Parser::TOKEN_MUL;
and         return Parser::TOKEN_AND;
or          return Parser::TOKEN_OR;
not         return Parser::TOKEN_NOT;
div         return Parser::TOKEN_DIV; 
mod         return Parser::TOKEN_MOD;
"("         return Parser::TOKEN_OPEN;
")"         return Parser::TOKEN_CLOSE;

{DIGIT}+	return Parser::TOKEN_NUM;
true        return Parser::TOKEN_TRUE;
false       return Parser::TOKEN_FALSE;

"#".*\n    // nothing to do

{LETTER}({LETTER}|{DIGIT}|_)*    return Parser::TOKEN_ID;

{WS}+   // nothing to do

. {
    std::cerr << "Line " << lineno() << ": Lexical error." << std::endl;
    exit(1);
}

%%
