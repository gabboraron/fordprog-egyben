%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
%}

SZAMJEGY    [0-9]
WS          [ \t\n]
BETU        [a-zA-Z]

%%

program     std::cout << "program" << std::endl;
begin       std::cout << "begin" << std::endl;
end         std::cout << "end" << std::endl;
integer     std::cout << "integer" << std::endl; 
boolean     std::cout << "boolean" << std::endl;
skip        std::cout << "skip" << std::endl;
if          std::cout << "if" << std::endl;
then        std::cout << "then" << std::endl;
else        std::cout << "else" << std::endl;
endif       std::cout << "endif" << std::endl;
while       std::cout << "while" << std::endl;
do          std::cout << "do" << std::endl;
done        std::cout << "done" << std::endl;
read        std::cout << "read" << std::endl;
write       std::cout << "write" << std::endl;
";"         std::cout << "utasitas vege" << std::endl;
":="        std::cout << "ertekadas" << std::endl;
"="         std::cout << "egyenlo" << std::endl;
"<"         std::cout << "kisebb" << std::endl;
">"         std::cout << "nagyobb" << std::endl;
"+"         std::cout << "plusz" << std::endl;
"-"         std::cout << "minusz" << std::endl;
"*"         std::cout << "szorzas" << std::endl;
and         std::cout << "and" << std::endl;
or          std::cout << "or" << std::endl;
not         std::cout << "not" << std::endl;
div         std::cout << "div" << std::endl; 
mod         std::cout << "mod" << std::endl;
"("         std::cout << "balzarojel" << std::endl;
")"         std::cout << "jobbzarojel" << std::endl;

{SZAMJEGY}+ std::cout << "szamkonstans: " << YYText() <<std::endl;
true        std::cout << "true" << std::endl;
false       std::cout << "false" << std::endl;

"#".*\n    // nem kell semmit csinalni

{BETU}({BETU}|{SZAMJEGY}|_)*    std::cout << "azonosito: " << YYText() <<std::endl;

{WS}+   // feher szokozok: semmi teendo

. {
    std::cerr << lineno() << ". sor: Lexikalis hiba!" << std::endl;
    exit(1);
}

%%
