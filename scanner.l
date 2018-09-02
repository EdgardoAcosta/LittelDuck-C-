%{
#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()

#include "preset.tab.h"  

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

\".*\"                      {return CTESTRING;}
[A-za-z]([A-za-z]|[0-9])*   {yylval.sval = strdup(yytext); return ID;}
[0-9]*\.[0-9]+|[0-9]+       {yylval.ival = atof(yytext); return CTEF;}
\d+                         {yylval.ival = atoi(yytext); return CTEI;  }

.                	;
%% 