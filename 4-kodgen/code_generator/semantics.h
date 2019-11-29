#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <iostream>
#include <map>
#include <sstream>

enum type { type_integer, type_boolean };

struct row
{
	type var_type;
	int def_line;
	std::string label;
	
	row(type t, int l, std::string lab) : var_type(t), def_line(l), label(lab) {}
	row() {}
	
};

struct expr_attribute
{
	type expr_type;
	std::string code;
	
	expr_attribute(type t, std::string c) : expr_type(t), code(c) {}
};


#endif
