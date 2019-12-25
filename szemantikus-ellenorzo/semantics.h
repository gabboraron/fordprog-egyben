#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <iostream>
#include <string>
#include <map>
#include <sstream>

enum type {natural, boolean};


struct var_data
{
    int decl_row;  
    type var_type;  
    var_data(int id=0,type tp= natural)
    	: decl_row(id), var_type(tp)
    {}
};

struct expr_data
{
	int decl_row;
	type k_type;
	expr_data( int id, type tp )
		: decl_row(id), k_type(t)
    {}
};

struct order_data
{
	int decl_row;
	order_data( int id )
		: decl_row(id)
    {}
};



#endif