%{
#include "y.tab.h"
#include "string.h"
int lineCounter = 1;
void yyerror (char *s);
int yylex();

%}

START (START)([^a-zA-Z0-9])
END END
OUTPUT OUTPUT:
newline [\n]
scanner scanner:([^a-zA-Z0-9])
sntc  \".*\"
identifier [a-zA-Z]
and and([^a-zA-Z0-9])
or or([^a-zA-Z0-9])
not not([^a-zA-Z0-9])
num [0-9]+
when IF[^a-zA-Z0-9]
ELSE ELSE[^a-zA-Z0-9]
trap_until trap_until[^a-zA-Z0-9]
equals ==
BIGGER_equals >=
SMALLER_equals <=
BIGGER >
SMALLER <
COMMENT [^a-zA-Z0-9]([//].+[//])[^a-zA-Z0-9]
SEMICOLON ;
FUNC FUNC
RETURN RETURN
FUNCNAME [a-z]+[:]
BOOL true|false

%%
!=	{return not_equals;}
\%      {return MOD;}
\(	{return LP;}
\)	{return RP;}
\,	{return COMMA;}
{FUNCNAME} {return FUNCNAME;}
{RETURN} {return RETURN;}
{FUNC} {return FUNC;}
{sntc} {yylval.pr = strdup(yytext); return sntc ;}
{OUTPUT} {return OUTPUT;}
{scanner} {return scanner ;}
{num}  {yylval.nump = atoi(yytext);return num;}
{trap_until} {return trap_until ;}
{IF} {return IF ;}
{ELSE} {return ELSE ;}
{equals} {return equals ;}
{BIGGER_equals} {return BIGGER_equals ;}
{SMALLER_equals} {return SMALLER_equals ;}
{BIGGER} {return BIGGER ;}
{SMALLER} {return SMALLER ;}
{and} {return and ;}
{or} {return or ;}
{not} {return not ;}
{COMMENT} {return COMMENT ;}
{identifier} {yylval.id = yytext[0]; return identifier;}
{START} {return START ;}
{END} {return END ;}
{SEMICOLON} {return SEMICOLON;}
{newline} {lineCounter++;}
[-+=]                  {return yytext[0];}
[ \t\n]                ;


%%


int yywrap (void) {return 1;}

