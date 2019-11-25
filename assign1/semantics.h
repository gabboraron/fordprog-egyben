#include <iostream>
#include <string>
#include <map>
#include <sstream>

enum type {natural, boolean};


struct var_data
{
    int decl_row;  
    type var_type;  
    var_data(int id,type tp){
        decl_row = id;
        var_type = tp;
    };
    var_data(){};
};

