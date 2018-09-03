%{
    #include <stdio.h>
    #include <iostream>
    using namespace std;
    extern "C" int yylex();
    extern "C" int yyparse();
    extern "C" char *yytext;
    extern "C" int line_num;
    extern "C" char file_name;
    extern "C" FILE *yyin;
     
    void yyerror(const char *s);
%}

%union {
	int ival;
	float fval;
	char *sval;
}

// Terminal tokens
%token <sval> PROGRAM
%token <sval> PRINT
%token <sval> IF
%token <sval> ELSE
%token <sval> VAR
%token <sval> INT
%token <sval> FLOAT
%token <sval> SEMICOLON
%token <sval> LEFTBRACKET
%token <sval> RIGHTBRACKET
%token <sval> GREATER
%token <sval> LESS
%token <sval> NOTEQUAL
%token <sval> PLUS
%token <sval> MINUS
%token <sval> TIMES
%token <sval> DIVIDE
%token <sval> LEFTPAREN
%token <sval> RIGHTPAREN
%token <sval> COLON
%token <sval> EQUALS
%token <sval> COMMA
%token <sval> CTESTRING
%token <sval> ID
%token <sval> CTEF
%token <sval> CTEI


// Non Terminal tokens
%type <sval> programa
%type <sval> program_vars
%type <sval> block
%type <sval> vars
%type <sval> statement_block
%type <sval> statement
%type <sval> assignment
%type <sval> condition
%type <sval> writing
%type <sval> expression
%type <sval> exp
%type <sval> comparation
%type <sval> comparation_exp
%type <sval> term
%type <sval> operator
%type <sval> factor 
%type <sval> term_operator
%type <sval> sign
%type <sval> var_cte
%type <sval> var_id
%type <sval> type
%type <sval> vars_block
%type <sval> var_id_2
%type <sval> else_condition
%type <sval> print_val
%type <sval> print_exp

%%
programa:
    PROGRAM ID SEMICOLON program_vars block {std::cout<< "Valid input" <<endl;}
    ;
program_vars:
    vars
    | /*empty*/ {}
    ;
block:
    LEFTBRACKET statement_block RIGHTBRACKET
    ;

statement_block:
    statement statement_block   
    | /*empty*/ {}
    ;
statement:
    assignment
    | condition
    | writing
    ;

expression:
    exp comparation
    ;

comparation:
    GREATER comparation_exp
    | LESS comparation_exp
    | NOTEQUAL comparation_exp
    | /*empty*/ {}
    ;

comparation_exp:
    exp
    ;

exp:
    term operator
    ;

operator:
    PLUS term operator
    | MINUS term operator
    | /*empty*/ {}
    ;

term:
    factor term_operator
    ;

term_operator:
    TIMES factor term_operator
    | DIVIDE factor term_operator
    | /*empty*/ {}
    ;

factor:
    LEFTPAREN expression RIGHTPAREN
    | sign var_cte
    ;

sign:
    PLUS
    | MINUS
    | /*empty*/ {}
    ;

var_cte:
    ID
    | CTEI
    | CTEF
    ;

vars:
    VAR var_id COLON type SEMICOLON vars_block
    ;

var_id:
    ID var_id_2
    ;

var_id_2:
    COMMA ID var_id_2
    | /*empty*/ {}
    ;

type:  
    INT
    | FLOAT
    ;

vars_block:
    var_id COLON type SEMICOLON vars_block
    | /*empty*/ {}
    ;

assignment:
    ID EQUALS expression SEMICOLON
    ;

condition:
    IF LEFTPAREN expression RIGHTPAREN block else_condition SEMICOLON
    ;

else_condition:
    ELSE block
    | /*empty*/ {}
    ;

writing:
    PRINT LEFTPAREN print_val RIGHTPAREN SEMICOLON
    ;

print_val:
    expression print_exp
    | CTESTRING print_exp
    ;

print_exp:
    COMMA  print_val
    | /*empty*/ {}
    ;
%%


int main(int argc, char *argv[]){

    // Read the file to test, gived as first argument
    FILE *file_test = fopen(argv[1], "r");
    // If cant open the file, stop
    if (!file_test) {
        cout << "No file to test found on directory" << endl;
        return -1;
    }
    // Read from the file
    yyin = file_test;
    // Read all the file and then stop
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}
// Function to throw an error
void yyerror(const char *s) {
    printf("Syntax error found at line: %d, unexpected token '%s'\n", line_num, yytext);
    exit(-1);
}