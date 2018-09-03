%{
#include <iostream>
#include <stdio.h>
#include "parser.tab.h"  
using namespace std;
#define YY_DECL extern "C" int yylex()

int line_num = 1;

%}

%%

program {return PROGRAM;}
print   {return PRINT;}
if      {return IF;}   
else    {return ELSE;}
var     {return VAR;}
int     {return INT;}
float   {return FLOAT;}
";"     {return SEMICOLON;}
"{"     {return LEFTBRACKET;}
"}"     {return RIGHTBRACKET;}
">"     {return GREATER;}
"<"     {return LESS;}
"<>"    {return NOTEQUAL;}
"+"     {return PLUS;}
"-"     {return MINUS;}
"*"     {return TIMES;}
"/"     {return DIVIDE;}
"("     {return LEFTPAREN;}
")"     {return RIGHTPAREN;}
":"     {return COLON;}
"="     {return EQUALS;}
","     {return COMMA;}


[0-9]+            	{ yylval.ival = atoi(yytext); return CTEI; }
[a-zA-Z0-9]+     	{ yylval.sval = strdup(yytext); return ID; }
[0-9]+\.[0-9]+ 		{ yylval.fval = atof(yytext); return CTEF; }
\".*\"				{ return CTESTRING; }

[ \t\r]             { ; }
[\n]                { line_num++; }

.                   { printf("Invalid token (line %d): '%s'\n", line_num, yytext); exit(-1); }
%% 

int yywrap(){ return 1; }
