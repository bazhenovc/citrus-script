%{
	#include "lex.yy.h"

	//#include "ast.hh"

	#include <string>
	#include <iostream>

	#ifndef YYERROR_VERBOSE
	#define YYERROR_VERBOSE 1
	#endif

	#define YYSTYPE std::string
	#define YYPARSE_PARAM module_ptr

	//-----------------------------------------------------------------------------
	void yyerror(const char *str)
	{
		fprintf(stderr,"error: %s at line %i\n", str, yyget_lineno());
	}
	 
	int yywrap()
	{
		return 1;
	} 
%}

%token tkClass
%token tkDigit
%token tkStringLiteral
%token tkColon
%token tkSemicolon
%token tkDot
%token tkComma
%token tkLBrace
%token tkRBrace
%token tkLCBrace
%token tkRCBrace
%token tkLSBrace
%token tkRSBrace
%token tkQuote
%token tkStar
%token tkSlash
%token tkPlus
%token tkMinus
%token tkLesser
%token tkGreater
%token tkIdentifier
%token tkEquals
%token tkPrivate
%token tkPublic
%token tkProtected
%token tkIf
%token tkElse
%token tkEqualsEquals
%token tkReturn

%start translation_unit

%%

translation_unit
	: toplevel_expr
	| translation_unit toplevel_expr
	;

name
	: tkIdentifier
	{ $$ = $1; }
	;

numeric_constant
	: tkDigit
	{ std::cout << "const ref: " << $1 << std::endl; }
	| tkDigit tkDot tkDigit
	{ std::cout << "const ref: " << $1 << "." << $3 << std::endl; }
	;

string_constant
	: tkStringLiteral
	{ std::cout << "string constant: \"" << $1 << "\"" << std::endl; }
	;

character_constant
	: tkQuote name tkQuote
	{ std::cout << "char constant: '" << $2 << "'" << std::endl; }
	;

var_ref
	: name
	{ std::cout << "var ref: " << $1 << std::endl; }
	| name tkDot name
	{ std::cout << "class var ref: " << $1 << "." << $3 << std::endl; }
	| name tkLSBrace expr tkRSBrace
	{ std::cout << "array var ref: " << $1 << "[expr]" << std::endl; }
	| name tkDot name tkLSBrace expr tkRSBrace
	{ std::cout << "class array var ref: " << $1 << "[expr]" << std::endl; }
	;

var_or_constant_ref
	: var_ref
	| numeric_constant
	| string_constant
	| character_constant
	;

// Expression
expr
	: var_or_constant_ref
	| function_call
	| binary_operator
	| assign_operator
	;

// Binary operations
binary_operator
	: binary_add
	| binary_sub
	| binary_mul
	| binary_div
	| binary_less
	| binary_gr
	| binary_equals
	;

binary_add
	: var_or_constant_ref tkPlus var_or_constant_ref
	{ std::cout << "binary operator: " << $1 << $2 << $3 << std::endl; }
	;

binary_sub
	: var_or_constant_ref tkMinus var_or_constant_ref
	{ std::cout << "binary operator: " << $1 << $2 << $3 << std::endl; }
	;

binary_mul
	: var_or_constant_ref tkStar var_or_constant_ref
	{ std::cout << "binary operator: " << $1 << $2 << $3 << std::endl; }
	;

binary_div
	: var_or_constant_ref tkSlash var_or_constant_ref
	{ std::cout << "binary operator: " << $1 << $2 << $3 << std::endl; }
	;

binary_less
	: var_or_constant_ref tkLesser var_or_constant_ref
	{ std::cout << "binary operator: " << $1 << $2 << $3 << std::endl; }
	;

binary_gr
	: var_or_constant_ref tkGreater var_or_constant_ref
	{ std::cout << "binary operator: " << $1 << $2 << $3 << std::endl; }
	;

binary_equals
	: var_or_constant_ref tkEqualsEquals var_or_constant_ref
	{ std::cout << "binary equals: " << $1 << $3 << std::endl; }
	;

assign_operator
	: var_ref tkEquals expr
	{ std::cout << "assign: " << $1 << " = " << $3 << std::endl; }
	;

// Function call
function_call
	: name tkLBrace function_call_args tkRBrace
	{ std::cout << "func call: " << $1 << std::endl; }
	| name tkColon tkColon name tkLBrace function_call_args tkRBrace
	{ std::cout << "static class func call: " << $1 << "::" << $4 << std::endl; }
	| name tkDot name tkLBrace function_call_args tkRBrace
	{ std::cout << "class func call: " << $1 << "." << $3 << std::endl; }
	;

function_call_args
	:
	{}
	| expr
	{}
	| function_call_args tkComma expr
	{}
	;

// top level expression
toplevel_expr
	: function_call tkSemicolon
	{ std::cout << "toplevel_expr" << std::endl; }
	| toplevel_var_declaration
	| func_declaration
	| class_declaration
	;

// Variable declaration
toplevel_var_declaration
	: tkIdentifier name tkSemicolon
	{ std::cout << "var_decl: " << $1 << " " << $2 << ";" << std::endl; }
	| tkIdentifier name tkEquals expr tkSemicolon
	{ std::cout << "var_decl: " << $1 << " " << $2 << " = expr;" << std::endl; }
	| tkIdentifier name tkLSBrace tkRSBrace tkSemicolon
	{ std::cout << "dynamic array decl: " << $1 << " " << $2 << std::endl; }
	| tkIdentifier name tkLSBrace numeric_constant tkRSBrace tkSemicolon
	{ std::cout << "static array decl: " << $1 << " " << $2 << std::endl; }
	;

var_declaration
	: name name
	{ $$ = $1 + ":" + $2 + " "; }
	| name name tkLSBrace tkRSBrace
	{ $$ = $1 + ":" + $2 + "[] "; }
	| name name tkLSBrace numeric_constant tkRSBrace
	{ $$ = $1 + ":" + $2 + "[" + $4 + "] "; }
	;

// Function declaration
func_declaration
	: tkIdentifier name tkLBrace func_declaration_arg_list tkRBrace tkLCBrace block_body tkRCBrace
	{ std::cout << "func_declaration: " << $2 << " args: " << $4 << std::endl; }
	;

return_declaration
	: tkReturn tkSemicolon
	{ std::cout << "return_declaration: void" << std::endl; }
	| tkReturn expr tkSemicolon
	{ std::cout << "return_declaration: expr" << std::endl; }
	;

// Block body
block_body
	:
	{}
	| block_body toplevel_var_declaration
	{}
	| block_body expr tkSemicolon
	{}
	| block_body if_expr
	{}
	| block_body return_declaration
	{}
	;

if_expr
	: tkIf tkLBrace expr tkRBrace tkLCBrace block_body tkRCBrace
	{ std::cout << "if expr" << std::endl; }
	| tkIf tkLBrace expr tkRBrace tkLCBrace block_body tkRCBrace tkElse tkLCBrace block_body tkRCBrace
	{ std::cout << "if-else expr" << std::endl; }
	;

func_declaration_arg_list
	:
	{ $$ = ""; }
	| var_declaration
	{ $$ = $1; }
	| func_declaration_arg_list tkComma var_declaration
	{ $$ = $1 + $3; }
	;

// Class
access_type
	: tkPrivate
	{ $$ = "private"; }
	| tkPublic
	{ $$ = "public"; }
	| tkProtected
	{ $$ = "protected"; }
	;

class_declaration
	: tkClass name tkLCBrace class_body tkRCBrace tkSemicolon
	{ std::cout << "class: " << $2 << std::endl; }
	| tkClass name tkColon name tkLCBrace class_body tkRCBrace tkSemicolon
	{ std::cout << "class: " << $2 << " inherits: " << $4 << std::endl; }
	;

class_body
	:
	{}
	| class_body class_field_declaration
	{}
	| class_body class_method_declaration
	{}
	;

class_field_declaration
	// <access_type> <var_declaration>;
	: access_type var_declaration tkSemicolon
	{ std::cout << "class field: (" << $1 << ") " << $2 << std::endl; }
	| var_declaration tkSemicolon
	{ std::cout << "class field: (default private) " << $1 << std::endl; }
	;

class_method_declaration
	// <access_type> <type> <name> (params) { <body> }
	: access_type name name tkLBrace func_declaration_arg_list tkRBrace tkLCBrace block_body tkRCBrace
	{ std::cout << "class method: (" << $1 << ") " << $2  << " " << $3 << " args: " << $5 << std::endl; }
	// <type> <name> (params) { <body> }
	| name name tkLBrace func_declaration_arg_list tkRBrace tkLCBrace block_body tkRCBrace
	{ std::cout << "class method: (default public) " << $1  << " " << $2 << " args: " << $4 << std::endl; }
	;
%%

int main(int argc, char** argv)
{
	if (argc < 2) {
		puts("usage: glslc <fileexprData>");
		return 1;
	}

	char * buffer = 0;
	long length;
	FILE * f = fopen (argv[1], "rb");

	if (f) {
		fseek (f, 0, SEEK_END);
		length = ftell (f);
		fseek (f, 0, SEEK_SET);
		buffer = (char*)malloc (length);

		if (buffer) {
			fread (buffer, 1, length, f);
		}
		fclose (f);
	}

	if (buffer) {
		yy_scan_string(buffer);

		//llvm::Module* module = new llvm::Module("test", llvm::getGlobalContext());
		yyparse(0);

		std::cout << "==================" << std::endl;
		//module->dump();
	}
	return 0;
}