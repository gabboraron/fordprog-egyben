%baseclass-preinclude "semantics.h"

%lsp-needed

%token TOKEN_PROGRAM
%token TOKEN_BEGIN
%token TOKEN_END
%token TOKEN_INTEGER 
%token TOKEN_BOOLEAN
%token TOKEN_SKIP
%token TOKEN_IF
%token TOKEN_THEN
%token TOKEN_ELSE
%token TOKEN_ENDIF
%token TOKEN_WHILE
%token TOKEN_DO
%token TOKEN_DONE
%token TOKEN_READ
%token TOKEN_WRITE
%token TOKEN_SEMICOLON
%token TOKEN_ASSIGN
%token TOKEN_OPEN
%token TOKEN_CLOSE
%token <name> TOKEN_NUM
%token TOKEN_TRUE
%token TOKEN_FALSE
%token <name> TOKEN_ID

%left TOKEN_OR
%left TOKEN_AND
%left TOKEN_NOT
%left TOKEN_EQ
%left TOKEN_LESS TOKEN_GR
%left TOKEN_ADD TOKEN_SUB
%left TOKEN_MUL TOKEN_DIV TOKEN_MOD

%type <expr_attr> expression
%type <code> instruction
%type <code> instructions
%type <code> assignment
%type <code> read
%type <code> write
%type <code> branch
%type <code> loop

%union
{
	std::string *name;
	type *expr_type;
	std::string *code;
	expr_attribute *expr_attr;
}

%%

start:
    TOKEN_PROGRAM TOKEN_ID declarations TOKEN_BEGIN instructions TOKEN_END
    {
		std::cout << "global main" << std::endl;
		std::cout << "extern read_unsigned" << std::endl;
		std::cout << "extern write_unsigned" << std::endl;
		std::cout << "extern read_boolean" << std::endl;
		std::cout << "extern write_boolean" << std::endl;
		std::cout << std::endl;
		std::cout << "section .bss" << std::endl;
		for(std::pair<std::string,row> v : symbol_table) {
			if(v.second.var_type == type_integer) {
				std::cout << v.second.label << ": resd 1" << std::endl;
			} else {
				std::cout << v.second.label << ": resb 1" << std::endl;	
			}
		}
		std::cout << std::endl;
		std::cout << "section .text" << std::endl;
		std::cout << "main:" << std::endl;
		std::cout << *$5 << std::endl;
		std::cout << "ret" << std::endl;
    }
;

declarations:
    // empty
    {
    }
|
    declaration declarations
    {
    }
;

declaration:
    TOKEN_INTEGER TOKEN_ID TOKEN_SEMICOLON
    {
		if(symbol_table.count(*$2) > 0) {
			error("Redeclared variable.");
		}
        symbol_table[*$2] = row(type_integer,d_loc__.first_line,new_label());
		delete $2;
    }
|
    TOKEN_BOOLEAN TOKEN_ID TOKEN_SEMICOLON
    {
		if(symbol_table.count(*$2) > 0) {
			error("Redeclared variable.");
		}
        symbol_table[*$2] = row(type_boolean,d_loc__.first_line,new_label());
		delete $2;
    }
;

instructions:
    instruction
    {
		$$ = $1;
    }
|
    instruction instructions
    {
		$$ = new std::string(*$1 + *$2);
		delete $1;
		delete $2;
    }
;

instruction:
    TOKEN_SKIP TOKEN_SEMICOLON
    {
		$$ = new std::string("nop");
    }
|
    assignment
    {
		$$ = $1;
    }
|
    read
    {
		$$ = $1;
    }
|
    write
    {
		$$ = $1;
    }
|
    branch
    {
		$$ = $1;
    }
|
    loop
    {
		$$ = $1;
    }
;

assignment:
    TOKEN_ID TOKEN_ASSIGN expression TOKEN_SEMICOLON
    {
        if(symbol_table.count(*$1) < 1) {
			std::stringstream ss;
			ss << "Undeclared variable: " << *$1;
			error(ss.str().c_str());
        }
        if(symbol_table[*$1].var_type != $3->expr_type) {
			error("Type error in assignment.");
        }
        
        if(symbol_table[*$1].var_type == type_integer) {
			$$ = new std::string(
				 $3->code
				 + "mov [" + symbol_table[*$1].label + "],eax\n"
				 );
		} else {
			$$ = new std::string(
				 $3->code
				 + "mov [" + symbol_table[*$1].label + "],al\n"
				 );
		}
		delete $1;
		delete $3;
    }
;

read:
    TOKEN_READ TOKEN_OPEN TOKEN_ID TOKEN_CLOSE TOKEN_SEMICOLON
    {
        if(symbol_table.count(*$3) < 1) {
			std::stringstream ss;
			ss << "Undeclared variable: " << *$3;
			error(ss.str().c_str());
        }
        if(symbol_table[*$3].var_type == type_integer) {
			$$ = new std::string(
				std::string("call read_unsigned\n")
				+ "mov [" + symbol_table[*$3].label + "],eax\n"
			);
        } else {
			$$ = new std::string(
				std::string("call read_unsigned\n")
				+ "mov [" + symbol_table[*$3].label + "],al\n"
			);
        }
		delete $3;
    }
;

write:
    TOKEN_WRITE TOKEN_OPEN expression TOKEN_CLOSE TOKEN_SEMICOLON
    {
        if($3->expr_type == type_integer) {
			$$ = new std::string(
				$3->code
				+ "push eax\n" + "call write_unsigned\n"
				+ "pop eax\n"
			);
        } else {
			$$ = new std::string(
				$3->code
				+ "push eax\n" + "call write_boolean\n"
				+ "pop eax\n"
			);
        }
		delete $3;
    }
;

branch:
    TOKEN_IF expression TOKEN_THEN instructions TOKEN_ENDIF
    {
		if($2->expr_type != type_boolean) {
			error("Condition of if-instruction is not boolean.");
		}
		std::string endlabel = new_label();
		$$ = new std::string(
			$2->code
			+ "cmp al,1\n"
			+ "jne near " + endlabel + "\n"
			+ *$4
			+ endlabel + ":\n"
		);
		delete $2;
		delete $4;
    }
|
    TOKEN_IF expression TOKEN_THEN instructions TOKEN_ELSE instructions TOKEN_ENDIF
    {
		if($2->expr_type != type_boolean) {
			error("Condition of if-instruction is not boolean.");
		}
		std::string endlabel = new_label();
		std::string elselabel = new_label();
		$$ = new std::string(
			$2->code
			+ "cmp al,1\n"
			+ "jne near " + elselabel + "\n"
			+ *$4
			+ "jmp " + endlabel + "\n"
			+ elselabel + ":\n"
			+ *$6
			+ endlabel + ":\n"
		);
		delete $2;
		delete $4;
		delete $6;
    }
;

loop:
    TOKEN_WHILE expression TOKEN_DO instructions TOKEN_DONE
    {
		if($2->expr_type != type_boolean) {
			error("Condition of while-loop is not boolean.");
		}
		std::string beginlabel = new_label();
		std::string endlabel = new_label();
		$$ = new std::string(
			beginlabel + ":\n"
			+ $2->code
			+ "cmp al,1\n"
			+ "jne near " + endlabel + "\n"
			+ *$4
			+ "jmp " + beginlabel + "\n"
			+ endlabel + ":\n"
		);
		delete $2;
		delete $4;
    }
;

expression:
    TOKEN_NUM
    {
        $$ = new expr_attribute(type_integer,"mov eax," + *$1 + "\n");
    }
|
    TOKEN_TRUE
    {
        $$ = new expr_attribute(type_boolean, "mov al,1\n");
    }
|
    TOKEN_FALSE
    {
        $$ = new expr_attribute(type_boolean, "mov al,0\n");
    }
|
    TOKEN_ID
    {
        if(symbol_table.count(*$1) == 0) {
			std::stringstream ss;
			ss << "Undeclared variable: " << *$1;
			error(ss.str().c_str());
        }
        if(symbol_table[*$1].var_type == type_integer) {
    	    $$ = new expr_attribute(type_integer,
    	                 std::string("mov eax,[") + symbol_table[*$1].label + "]\n");
    	} else {
    	    $$ = new expr_attribute(type_boolean,
    	                 std::string("mov al,[") + symbol_table[*$1].label + "]\n");
    	}
		delete $1;
    }
|
    expression TOKEN_ADD expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of '+' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of '+' is not integer.");
		}
		$$ = new expr_attribute(type_integer,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "add eax,ebx\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_SUB expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of '-' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of '-' is not integer.");
		}
		$$ = new expr_attribute(type_integer,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "sub eax,ebx\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_MUL expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of '*' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of '*' is not integer.");
		}
		$$ = new expr_attribute(type_integer,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "mul ebx\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_DIV expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of 'div' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of 'div' is not integer.");
		}
		$$ = new expr_attribute(type_integer,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "mov edx,0\n"
		  + "div ebx\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_MOD expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of 'mod' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of 'mod' is not integer.");
		}
		$$ = new expr_attribute(type_integer,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "mov edx,0\n"
		  + "div ebx\n"
		  + "mov eax,edx\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_LESS expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of '<' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of '<' is not integer.");
		}
		std::string label_yes = new_label();
		std::string label_end = new_label();
		$$ = new expr_attribute(type_boolean,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "cmp eax,ebx\n"
		  + "jb " + label_yes + "\n"
		  + "mov al,0\n"
		  + "jmp " + label_end + "\n"
		  + label_yes + ":\n"
		  + "mov al,1\n"
		  + label_end + ":\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_GR expression
    {
		if($1->expr_type != type_integer) {
			error("Left operand of '>' is not integer.");
		}
		if($3->expr_type != type_integer) {
			error("Right operand of '>' is not integer.");
		}
		std::string label_yes = new_label();
		std::string label_end = new_label();
		$$ = new expr_attribute(type_boolean,
		  $3->code
		  + "push eax\n"
		  + $1->code
		  + "pop ebx\n"
		  + "cmp eax,ebx\n"
		  + "ja " + label_yes + "\n"
		  + "mov al,0\n"
		  + "jmp " + label_end + "\n"
		  + label_yes + ":\n"
		  + "mov al,1\n"
		  + label_end + ":\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_EQ expression
    {
		if($1->expr_type != $3->expr_type) {
			error("Left and right operands of '=' have different types.");
		}
		std::string label_yes = new_label();
		std::string label_end = new_label();
		std::string reg_a, reg_b;
		if($1->expr_type == type_integer) {
		    reg_a = "eax";
		    reg_b = "ebx";
		} else {
		    reg_a = "ax";
		    reg_b = "bx";
		}
		$$ = new expr_attribute(type_boolean,
		  $3->code
		  + "push " + reg_a + "\n"
		  + $1->code
		  + "pop " + reg_b + "\n"
		  + "cmp " + reg_a + "," + reg_b + "\n"
		  + "je " + label_yes + "\n"
		  + "mov al,0\n"
		  + "jmp " + label_end + "\n"
		  + label_yes + ":\n"
		  + "mov al,1\n"
		  + label_end + ":\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_AND expression
    {
		if($1->expr_type != type_boolean) {
			error("Left operand of 'and' is not boolean.");
		}
		if($3->expr_type != type_boolean) {
			error("Right operand of 'and' is not boolean.");
		}
		$$ = new expr_attribute(type_boolean,
		  $3->code
		  + "push ax\n"
		  + $1->code
		  + "pop bx\n"
		  + "and al,bl\n"
		);
		delete $1;
		delete $3;
    }
|
    expression TOKEN_OR expression
    {
		if($1->expr_type != type_boolean) {
			error("Left operand of 'or' is not boolean.");
		}
		if($3->expr_type != type_boolean) {
			error("Right operand of 'or' is not boolean.");
		}
		$$ = new expr_attribute(type_boolean,
		  $3->code
		  + "push ax\n"
		  + $1->code
		  + "pop bx\n"
		  + "or al,bl\n"
		);
		delete $1;
		delete $3;
    }
|
    TOKEN_NOT expression
    {
		if($2->expr_type != type_boolean) {
			error("Operand of 'not' is not boolean.");
		}
		$$ = new expr_attribute(type_boolean,
		  $2->code
		  + "xor al,1\n"
		);
		delete $2;
    }
|
    TOKEN_OPEN expression TOKEN_CLOSE
    {
        $$ = $2;
    }
;
