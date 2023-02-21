%{
#include <stdlib.h>
#include "dasheader.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%

[a-zA-Z]    { if((*yytext)>=97) {
                    yylval.sIndex = *yytext - 'a';
                    }
                else {
                    yylval.sIndex = *yytext - 'A';
                }
                
                return VARIABLE;
            }

0|[-]?[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[-()<>=+*/;{}.] {
                return *yytext;
             }

">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"trap_until"    return WHILE;
"when"            return IF;
"or_when"       return ELSE_IF;
"other"          return ELSE;
"show"         return PRINT;

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
int yywrap(void) {
    return 1;
}
