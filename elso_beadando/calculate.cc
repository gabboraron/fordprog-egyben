#include <iostream>
#include <fstream>
#include <string>
#include <FlexLexer.h>
#include <cstdlib>

using namespace std;



void input_handler( ifstream& in, int argc, char* argv[] );

int main( int argc, char* argv[] )
{
    ifstream in;
    input_handler( in, argc, argv );
    yyFlexLexer fl(&in, &cout);
    fl.yylex();
    return 0;
}

void input_handler( ifstream& in, int argc, char* argv[] )
{
    if( argc < 2 )
    {
        cerr << "A forditando fajl nevet parancssori parameterben kell megadni." << endl;
        exit(1);
    }
    in.open( argv[1] );
    if( !in )
    {
        cerr << "A " << argv[1] << "fajlt nem sikerult megnyitni." << endl;
        exit(1);
    }
}
